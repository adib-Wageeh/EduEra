import 'dart:io';

import 'package:education_app/core/common/features/course/features/videos/data/data_source/video_remote_data_source.dart';
import 'package:education_app/core/common/features/course/features/videos/data/models/video_model.dart';
import 'package:education_app/core/common/features/course/features/videos/domain/entities/video.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {

  late FakeFirebaseFirestore fireStore;
  late MockFirebaseStorage storage;
  late MockFirebaseAuth auth;
  late VideoRemoteDataSource videoRemoteDataSourceImpl;
  final tVideo = VideoModel.empty();

  setUp(() async{
    fireStore = FakeFirebaseFirestore();

    final user = MockUser(
      email: 'email',
      uid: 'uId',
      displayName: 'displayName',
    );
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    auth = MockFirebaseAuth(mockUser: user,);
    await auth.signInWithCredential(credentials);
    storage = MockFirebaseStorage();
    videoRemoteDataSourceImpl = VideoRemoteDataSourceImpl(firebaseAuth: auth,
        firebaseStorage: storage, firestore: fireStore,);

    await fireStore.collection('courses').doc(tVideo.courseId)
    .set(tVideo.copyWith(id: tVideo.courseId).toMap());
  });

  group('add video', () {

    test('video added successfully to firebase and returns null', () async{

      await videoRemoteDataSourceImpl.addVideo(tVideo);

      final videoRef = await fireStore.collection('courses')
          .doc(tVideo.courseId).collection('videos').get();

      expect(videoRef.size>0, true);
      expect(videoRef.docs.first.data()['title'], tVideo.title);

      final courseRef = await fireStore.collection('courses')
      .doc(tVideo.courseId).get();

      expect(courseRef.data()!['numberOfVideos'], 1);

    });
    
    test('check if thumbnail has been added to storage', () async{
      
      final thumb = File('assets/images/auth_gradient_background.png');

      final newVideo = tVideo.copyWith(
        thumbnailIsAFile: true,
        thumbnail: thumb.path,
      );

      await videoRemoteDataSourceImpl.addVideo(newVideo);

      final videoRef = await fireStore.collection('courses')
      .doc(tVideo.courseId).collection('videos')
      .get();

      final savedVideo = videoRef.docs.first.data();

      final thumbRef = await storage.ref().child('courses')
      .child(newVideo.courseId).child('videos')
      .child(savedVideo['id'] as String).child('thumbnail').getDownloadURL();

      expect(savedVideo['thumbnail'], thumbRef);



      
    });


  });

  group('get videos', () { 
    
    test('getting videos from firestore', () async{

      await videoRemoteDataSourceImpl.addVideo(tVideo);
      final result = await videoRemoteDataSourceImpl.getVideos(tVideo.courseId);

      expect(result, isA<List<Video>>());
      expect(result.length, equals(1));

    });
    
    
  });

}
