import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/utils/datasource_utils.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/quiz_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/quiz_question_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/data/models/user_quiz_model.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/quiz.dart';
import 'package:pacola_quiz/src/course/features/quizzes/domain/entities/user_quiz.dart';

abstract class QuizRemoteDataSrc {
  Future<List<QuizModel>> getQuizzes(String courseId);
  Future<void> uploadQuiz(Quiz quiz);
  Future<List<QuizQuestionModel>> getQuizQuestions(Quiz quiz);
  Future<void> updateQuiz(Quiz quiz);
  Future<void> submitQuiz(UserQuiz quiz);
  Future<List<UserQuizModel>> getUserQuizzes();
  Future<List<UserQuizModel>> getUserCourseQuizzes(String courseId);
  Future<List<QuizModel>> getQuizzesUsingMaterial(String materialId);
}

class QuizRemoteDataSrcImpl implements QuizRemoteDataSrc {
  const QuizRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required Connectivity connectivity,
  })  : _auth = auth,
        _firestore = firestore,
        _connectivity = connectivity;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  @override
  Future<List<QuizModel>> getQuizzes(String courseId) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final result = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('quizzes')
          .get();

      return result.docs.map((doc) => QuizModel.fromMap(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> uploadQuiz(Quiz quiz) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final user = _auth.currentUser;
      final quizDocRef = _firestore
          .collection('courses')
          .doc(quiz.courseId)
          .collection('quizzes')
          .doc();

      final quizToUpload = (quiz as QuizModel).copyWith(
        id: quizDocRef.id,
        createdBy: user?.uid,
      );

      await quizDocRef.set(quizToUpload.toMap());

      final questions = quiz.questions;
      if (questions != null && questions.isNotEmpty) {
        final batch = _firestore.batch();
        for (final question in questions) {
          final questionDocRef = quizDocRef.collection('questions').doc();
          var questionToUpload = (question as QuizQuestionModel).copyWith(
            id: questionDocRef.id,
            quizId: quizDocRef.id,
          );
          batch.set(questionDocRef, questionToUpload.toMap());
        }
        await batch.commit();
      }

      // Update materials to include this quiz
      for (String materialId in quizToUpload.materialIds) {
        final materialDoc = await _firestore
            .collection('courses')
            .doc(quiz.courseId)
            .collection('materials')
            .doc(materialId)
            .get();

        if (materialDoc.exists) {
          await materialDoc.reference.update({
            'used_in_quizzes': FieldValue.arrayUnion([quizToUpload.id])
          });
        }
      }

      await _firestore.collection('courses').doc(quiz.courseId).update({
        'number_of_quizzes': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<QuizQuestionModel>> getQuizQuestions(Quiz quiz) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final result = await _firestore
          .collection('courses')
          .doc(quiz.courseId)
          .collection('quizzes')
          .doc(quiz.id)
          .collection('questions')
          .get();

      return result.docs
          .map((doc) => QuizQuestionModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final quizRef = _firestore
          .collection('courses')
          .doc(quiz.courseId)
          .collection('quizzes')
          .doc(quiz.id);

      await quizRef.update((quiz as QuizModel).toMap());

      final questions = quiz.questions;
      if (questions != null && questions.isNotEmpty) {
        final batch = _firestore.batch();
        for (final question in questions) {
          final questionDocRef =
              quizRef.collection('questions').doc(question.id);
          batch.set(questionDocRef, (question as QuizQuestionModel).toMap(),
              SetOptions(merge: true));
        }
        await batch.commit();
      }

      // Update materials relationship
      final oldQuizData = await quizRef.get();
      final oldMaterialIds = List<String>.from(
          oldQuizData.data()?['material_ids'] as List<dynamic>? ?? []);
      final newMaterialIds = quiz.materialIds;

      final materialsToRemove =
          oldMaterialIds.where((id) => !newMaterialIds.contains(id));
      final materialsToAdd =
          newMaterialIds.where((id) => !oldMaterialIds.contains(id));

      for (final materialId in materialsToRemove) {
        await _firestore
            .collection('courses')
            .doc(quiz.courseId)
            .collection('materials')
            .doc(materialId)
            .update(
          {
            'used_in_quizzes': FieldValue.arrayRemove([quiz.id])
          },
        );
      }

      for (final materialId in materialsToAdd) {
        await _firestore
            .collection('courses')
            .doc(quiz.courseId)
            .collection('materials')
            .doc(materialId)
            .update({
          'used_in_quizzes': FieldValue.arrayUnion([quiz.id])
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> submitQuiz(UserQuiz quiz) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);
      final user = _auth.currentUser!;

      final userQuizModel = (quiz as UserQuizModel).copyWith(
        dateSubmitted: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('courses')
          .doc(quiz.courseId)
          .collection('quizzes')
          .doc(quiz.quizId)
          .set(userQuizModel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<UserQuizModel>> getUserQuizzes() async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final user = _auth.currentUser!;
      final coursesSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('courses')
          .get();

      List<UserQuizModel> allQuizzes = [];

      for (var courseDoc in coursesSnapshot.docs) {
        final quizzesSnapshot =
            await courseDoc.reference.collection('quizzes').get();
        final courseQuizzes = quizzesSnapshot.docs
            .map((doc) => UserQuizModel.fromMap(doc.data()))
            .toList();
        allQuizzes.addAll(courseQuizzes);
      }

      return allQuizzes;
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<UserQuizModel>> getUserCourseQuizzes(String courseId) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final user = _auth.currentUser!;
      final result = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('courses')
          .doc(courseId)
          .collection('quizzes')
          .get();

      return result.docs
          .map((doc) => UserQuizModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<QuizModel>> getQuizzesUsingMaterial(String materialId) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final quizzesSnapshot = await _firestore
          .collectionGroup('quizzes')
          .where('material_ids', arrayContains: materialId)
          .get();

      return quizzesSnapshot.docs
          .map((doc) => QuizModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
          message: e.message ?? 'Unknown error', statusCode: e.code);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }
}
