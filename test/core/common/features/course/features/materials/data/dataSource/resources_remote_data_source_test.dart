import 'dart:io';

import 'package:education_app/core/common/features/course/features/materials/data/dataSource/resources_reomte_data_source.dart';
import 'package:education_app/core/common/features/course/features/materials/data/models/materials_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';



void main() {

  late FakeFirebaseFirestore firestore;
  late MockFirebaseStorage storage;
  late MockFirebaseAuth auth;
  late ResourcesRemoteDataSource dataSource;
  final tRes = ResourcesModel.empty();

  setUp(() async{

    firestore = FakeFirebaseFirestore();

    final user =MockUser(
      displayName: 'display_name',
      uid: 'uid',
      email: 'email',
    );

    final googleSignIn = MockGoogleSignIn();
    final signIn = await googleSignIn.signIn();
    final authentication = await signIn!.authentication;
    final googleCredentials = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user,);
    await auth.signInWithCredential(googleCredentials);

    storage = MockFirebaseStorage();
    dataSource = ResourcesRemoteDataSourceImpl(
      firestore: firestore,
      storage: storage,
      auth: auth,
    );

    await firestore.collection('courses').doc(tRes.courseId)
        .set(tRes.copyWith(id: tRes.courseId).toMap());
  });

  group('add resource', () {

    test('add resource to database successfully', () async{

      await dataSource.addResource(tRes);

      final courseRef = await firestore.collection('courses')
          .doc(tRes.courseId).get();

      expect(courseRef.data()!['numberOfMaterials'], 1);

      final resRef = await courseRef.reference.collection('materials')
          .get();

      expect(resRef.size, 1);

    });

    test('add resource file to storage successfully', () async{

      final file = File('assets/images/default_user.png');
      tRes.copyWith(
        isFile: true,
        url: file.path,
      );

      await dataSource.addResource(tRes);

      final result = await firestore.collection('courses')
      .doc(tRes.courseId).collection('materials').get();

       final ref = await storage.ref().child('courses').child(tRes.courseId)
      .child('materials').getDownloadURL();
       
       expect(result.docs.first.data()['url'], ref);

    });

  });

  group('get resources', () {

    test('get resources from firebase course',
        () async{

            await dataSource.addResource(tRes);
            final result = await dataSource.getResources(tRes.courseId);

            expect(result.length, 1);

        });


  });

}
