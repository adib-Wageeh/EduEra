import 'package:education_app/core/common/features/course/data/datasourses/course_remote_data_source.dart';
import 'package:education_app/core/common/features/course/data/models/course_model.dart';
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
  late CourseRemoteDataSourceImpl courseRemoteDataSourceImpl;
  final course = CourseModel.empty();

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
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user,);
    await auth.signInWithCredential(credentials);

    storage = MockFirebaseStorage();
    courseRemoteDataSourceImpl = CourseRemoteDataSourceImpl(
        storage: storage, firestore: fireStore,
        auth: auth,);

  });

  group('add course', () {

    test('successfully adding the course', () async{

      // arrange


      // act
      await courseRemoteDataSourceImpl.addCourse(course);

      // assert
      final fireStoreData = await fireStore.collection('courses')
      .get();
      expect(fireStoreData.docs.length, 1);

      final courseRef = fireStoreData.docs.first;
      expect(courseRef.data()['id'], courseRef.id);

      final fireStoreGroupData = await fireStore.collection('groups')
          .get();
      expect(fireStoreGroupData.docs.length, 1);

      final groupRef = fireStoreGroupData.docs.first;
      expect(groupRef.data()['id'], groupRef.id);
      expect(courseRef.data()['groupId'], groupRef.id);
      expect(groupRef.data()['courseId'], courseRef.id);

    });

  });

  group('get courses', () {

    test('successfully getting courses', () async{

      // arrange
      final firstDate = DateTime.now();
      final coursesList = [
        CourseModel.empty().copyWith(
          createdAt: firstDate,
        ),
        CourseModel.empty().copyWith(
          id: '2',
        ),
      ];

      for(final course in coursesList){
        await fireStore.collection('courses').add(course.toMap());
      }

      // act
      final result = await courseRemoteDataSourceImpl.getCourses();

      // assert
      expect(result, coursesList);



    });

  });


}
