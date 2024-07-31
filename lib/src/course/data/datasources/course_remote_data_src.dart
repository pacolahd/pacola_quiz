import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pacola_quiz/core/enums/update_enums.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/utils/datasource_utils.dart';
import 'package:pacola_quiz/src/course/data/models/course_model.dart';
import 'package:pacola_quiz/src/course/domain/entities/course.dart';

abstract class CourseRemoteDataSrc {
  const CourseRemoteDataSrc();

  Future<List<CourseModel>> getCourses();
  Future<void> addCourse(Course course);
  Future<void> updateCourse({
    required UpdateCourseAction action,
    required String courseId,
    dynamic courseData,
  });
  Future<void> deleteCourse(String courseId);
}

class CourseRemoteDataSrcImpl implements CourseRemoteDataSrc {
  const CourseRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
    required Connectivity connectivity,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth,
        _connectivity = connectivity;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final Connectivity _connectivity;

  @override
  Future<void> addCourse(Course course) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }

      final courseRef = _firestore.collection('courses').doc();
      var courseModel = (course as CourseModel).copyWith(
        id: courseRef.id,
        createdBy: user.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (courseModel.image != null) {
        final file = File(courseModel.image!);
        if (await file.exists()) {
          final imageRef = _storage.ref().child(
                'courses/${courseModel.id}/course_image'
                '/${courseModel.title}-pfp',
              );
          await imageRef.putFile(file);
          final imageUrl = await imageRef.getDownloadURL();
          courseModel = courseModel.copyWith(image: imageUrl);
        }
      }

      await courseRef.set(courseModel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final user = _auth.currentUser;

      final coursesSnapshot = await _firestore
          .collection('courses')
          .where('created_by', isEqualTo: user?.uid)
          .get();

      return coursesSnapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> deleteCourse(String courseId) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      // Delete course image
      await _storage
          .ref()
          .child('courses/$courseId/course_image')
          .delete()
          .catchError((_) {});

      // Delete all materials associated with the course
      final materialsSnapshot = await _firestore
          .collection('materials')
          .where('course_id', isEqualTo: courseId)
          .get();

      for (final doc in materialsSnapshot.docs) {
        final materialId = doc.id;
        await _storage
            .ref()
            .child('courses/$courseId/materials/$materialId')
            .delete()
            .catchError((_) {});
        await doc.reference.delete();
      }

      // Finally, delete the course
      await _firestore.collection('courses').doc(courseId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<void> updateCourse({
    required UpdateCourseAction action,
    required String courseId,
    dynamic courseData,
  }) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      switch (action) {
        case UpdateCourseAction.title:
          await _updateCourseData(courseId, {'title': courseData as String});
        case UpdateCourseAction.description:
          await _updateCourseData(
              courseId, {'description': courseData as String});
        case UpdateCourseAction.image:
          final imageRef = _storage.ref().child(
                'courses/$courseId/course_image'
                '/$courseId-pfp',
              );
          await imageRef.putFile(courseData as File);
          final url = await imageRef.getDownloadURL();
          await _updateCourseData(courseId, {'image': url});
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  Future<void> _updateCourseData(
      String courseId, Map<String, dynamic> data) async {
    await _firestore.collection('courses').doc(courseId).update(data);
  }
}
