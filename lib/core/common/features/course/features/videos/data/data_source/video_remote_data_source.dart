import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/videos/data/models/video_model.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class VideoRemoteDataSource{

  Future<void> addVideo(Video video);
  Future<List<Video>> getVideos(String courseId);

}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource{

  VideoRemoteDataSourceImpl({required FirebaseAuth firebaseAuth,
  required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firestore,
  }):
  _auth = firebaseAuth,
  _storage = firebaseStorage,
  _firestore = firestore
  ;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  @override
  Future<void> addVideo(Video video) async{

    try{
      if(_auth.currentUser == null){
        throw const ServerException(error: 'user is not authenticated'
          ,code: '404',);
      }
      var videoModel = video as VideoModel;
      final videoDoc = _firestore.collection('courses')
          .doc(videoModel.courseId).collection('videos').doc();

      if(videoModel.thumbnailIsAFile){
        final fileRef = await _storage.ref().child('courses')
            .child(videoModel.courseId).child('videos')
        .child(videoDoc.id).child('thumbnail')
            .putFile(File(videoModel.thumbnail!));
        final url = await fileRef.ref.getDownloadURL();
        videoModel = videoModel.copyWith(thumbnail: url);
      }

      await _firestore.collection('courses')
          .doc(video.courseId).collection('videos').add(
          videoModel.copyWith(id: videoDoc.id).toMap(),
      );

      await _firestore.collection('courses').doc(video.courseId)
      .update({
        'numberOfVideos': FieldValue.increment(1), 
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
  Future<List<Video>> getVideos(String courseId) async{

    try{
      if(_auth.currentUser == null){
        throw const ServerException(error: 'user is not authenticated'
          ,code: '404',);
      }

      final videosRef = await _firestore.collection('courses').doc(courseId)
          .collection('videos').get();

      return videosRef.docs.map((e) {
        return VideoModel.fromMap(e.data());
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
