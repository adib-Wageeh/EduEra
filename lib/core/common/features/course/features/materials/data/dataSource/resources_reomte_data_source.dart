import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/materials/data/models/materials_model.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ResourcesRemoteDataSource{

  Future<void> addResource(Resources resources);
  Future<List<Resources>> getResources(String courseId);

}

class ResourcesRemoteDataSourceImpl implements ResourcesRemoteDataSource{

  ResourcesRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
}):_auth = auth,
  _storage = storage,
  _firestore = firestore;


  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  @override
  Future<void> addResource(Resources resources) async{
    try{

      var resourcesModel = resources as ResourcesModel;

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }

      final materialDoc = _firestore.collection('courses')
      .doc(resourcesModel.courseId).collection('materials').doc();

      if(resourcesModel.isFile){
        final materialFileRef = _storage.ref().child(
          'courses/${resourcesModel.courseId}/materials/${materialDoc.id}/material',
        );
        final refPath = await materialFileRef.putFile(File(resourcesModel.url));
       final ref = await refPath.ref.getDownloadURL();
        resourcesModel = resourcesModel.copyWith(url: ref);
      }
      resourcesModel = resourcesModel.copyWith(id: materialDoc.id);

      await materialDoc.set(resourcesModel.toMap());

      await _firestore.collection('courses')
          .doc(resourcesModel.courseId).update({
        'numberOfMaterials': FieldValue.increment(1)
      });

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }


  }

  @override
  Future<List<Resources>> getResources(String courseId) async{
    try{

      if(_auth.currentUser == null){
        throw  const ServerException(
          error: 'unAuthenticated user',
          code: '404',
        );
      }

      final materialsSnapshot = await _firestore.collection('courses')
    .doc(courseId).collection('materials').get();

      return materialsSnapshot.docs.map((e){
        return ResourcesModel.fromMap(e.data());
      }).toList();

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }


  }



}
