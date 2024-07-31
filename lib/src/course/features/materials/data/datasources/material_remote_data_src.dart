import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pacola_quiz/core/enums/update_enums.dart';
import 'package:pacola_quiz/core/errors/exceptions.dart';
import 'package:pacola_quiz/core/utils/datasource_utils.dart';
import 'package:pacola_quiz/src/course/features/materials/data/models/resource_model.dart';
import 'package:pacola_quiz/src/course/features/materials/domain/entities/material.dart';

abstract class MaterialRemoteDataSrc {
  Future<List<ResourceModel>> getMaterials(String courseId);
  Future<void> addMaterial(Resource material);
  Future<void> updateMaterial({
    required UpdateMaterialAction action,
    required String materialId,
    required dynamic materialData,
  });
  Future<void> deleteMaterial(String materialId);
  Future<void> addMaterialToQuiz(String materialId, String quizId);
  Future<List<ResourceModel>> getMaterialsForQuiz(
      String courseId, String quizId);
}

class MaterialRemoteDataSrcImpl implements MaterialRemoteDataSrc {
  const MaterialRemoteDataSrcImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required Connectivity connectivity,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage,
        _connectivity = connectivity;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Connectivity _connectivity;

  @override
  Future<void> addMaterial(Resource material) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final materialRef = _firestore
          .collection('courses')
          .doc(material.courseId)
          .collection('materials')
          .doc();

      var materialModel = (material as ResourceModel).copyWith(
        id: materialRef.id,
        uploadedBy: _auth.currentUser!.uid,
        usedInQuizzes: [],
        uploadDate: DateTime.now(),
      );

      final materialFileRef = _storage.ref().child(
            'courses/${materialModel.courseId}/materials/${materialModel.id}/material',
          );
      await materialFileRef
          .putFile(File(materialModel.fileURL))
          .then((value) async {
        final url = await value.ref.getDownloadURL();
        materialModel = materialModel.copyWith(fileURL: url);
      });

      await materialRef.set(materialModel.toMap());

      await _firestore.collection('courses').doc(material.courseId).update({
        'number_of_materials': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<List<ResourceModel>> getMaterials(String courseId) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final materialsRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('materials');
      final materials = await materialsRef.get();

      return materials.docs
          .map((doc) => ResourceModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> deleteMaterial(String materialId) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final materialDoc = await _firestore
          .collectionGroup('materials')
          .where('id', isEqualTo: materialId)
          .get()
          .then((value) => value.docs.first);

      final courseId = materialDoc.reference.parent.parent!.id;

      // Delete the file from storage
      final filePath = 'courses/$courseId/materials/$materialId/material';
      await _storage.ref().child(filePath).delete();

      // Delete the material from the database
      await materialDoc.reference.delete();

      // Decrement the numberOfMaterials in the course document
      await _firestore.collection('courses').doc(courseId).update({
        'number_of_materials': FieldValue.increment(-1),
      });

      // Remove this material from all quizzes that were using it
      final quizzes = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('quizzes')
          .where('material_ids', arrayContains: materialId)
          .get();

      for (var quizDoc in quizzes.docs) {
        await quizDoc.reference.update({
          'material_ids': FieldValue.arrayRemove([materialId])
        });
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateMaterial({
    required UpdateMaterialAction action,
    required String materialId,
    required dynamic materialData,
  }) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final materialDoc = await _firestore
          .collectionGroup('materials')
          .where('id', isEqualTo: materialId)
          .get()
          .then((value) => value.docs.first);

      switch (action) {
        case UpdateMaterialAction.title:
          await materialDoc.reference.update({'title': materialData as String});
        case UpdateMaterialAction.description:
          await materialDoc.reference
              .update({'description': materialData as String});
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> addMaterialToQuiz(String materialId, String quizId) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final materialDoc = await _firestore
          .collectionGroup('materials')
          .where('id', isEqualTo: materialId)
          .get()
          .then((value) => value.docs.first);

      await materialDoc.reference.update({
        'used_in_quizzes': FieldValue.arrayUnion([quizId])
      });

      final courseId = materialDoc.reference.parent.parent!.id;
      await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('quizzes')
          .doc(quizId)
          .update({
        'material_ids': FieldValue.arrayUnion([materialId])
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<List<ResourceModel>> getMaterialsForQuiz(
    String courseId,
    String quizId,
  ) async {
    try {
      await DataSourceUtils.checkInternetConnection(_connectivity);
      await DataSourceUtils.authorizeUser(_auth);

      final materialsSnapshot = await _firestore
          .collection('courses')
          .doc(courseId)
          .collection('materials')
          .where('used_in_quizzes', arrayContains: quizId)
          .get();

      return materialsSnapshot.docs
          .map((doc) => ResourceModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }
}
