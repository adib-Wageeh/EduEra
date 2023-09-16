import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth{}

class MockAuthCredential extends Mock implements AuthCredential {}
class MockUser extends Mock implements User{

  String _uId = 'test id';

  @override
  String get uid => _uId;

  set uid(String value){
    _uId = value;
  }

}

class MockUserCredential extends Mock implements UserCredential{

  MockUserCredential([User? user]): _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value){
    if(value != _user){
      _user = value;
    }
  }
}


void main(){

  late FirebaseFirestore cloudStoreClient;
  late FirebaseAuth authClient;
  late MockFirebaseStorage storageClient;
  late AuthRemoteDataSource authRemoteDataSource;
  late MockUser mockUser;
  late UserCredential userCredential;
  late DocumentReference<DataMap> documentReference;
  final tUser = UserModel.empty();

  setUpAll(() async{

    cloudStoreClient = FakeFirebaseFirestore();
    storageClient = MockFirebaseStorage();
    authClient = MockFirebaseAuth();

    documentReference = cloudStoreClient.collection('users').doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );
    mockUser = MockUser()..uid = documentReference.id;
    userCredential = MockUserCredential(mockUser);

    authRemoteDataSource = AuthRemoteDataSourceImpl(
      firebaseFirestore: cloudStoreClient,
      firebaseStorage: storageClient,
      firebaseAuth: authClient,);

    when(()=> authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'test Password';
  const tFullName = 'test fullName';
  const tEmail = 'email@mail.org';
  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  group('forget password', () {
    
    test('should complete successfully when no exception is thrown',
        () async{
               // arrange
          when(()=> authClient.sendPasswordResetEmail(email: any(named: 'email'
            ,),),).thenAnswer((_) async=> Future.value());

              // act
          final call = authRemoteDataSource.forgetPassword(tEmail);

          expect(call, completes);

          verify(() => authClient.sendPasswordResetEmail(email: tEmail))
              .called(1);
          verifyNoMoreInteractions(authClient);

        });

    test('should throw ServerException when FirebaseAuthException is caught',
            () async{
          // arrange
          when(()=> authClient.sendPasswordResetEmail(email: any(named: 'email'
            ,),),).thenThrow(tFirebaseAuthException);

          // act
          final call = authRemoteDataSource.forgetPassword;

          expect(()async=>call(tEmail), throwsA(isA<ServerException>()));

          verify(() => authClient.sendPasswordResetEmail(email: tEmail))
              .called(1);
          verifyNoMoreInteractions(authClient);

        });

  });

  group('signIn', () {

    test('should complete successfully and return the user model', () async{

      // arrange
        when(()=> authClient.signInWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password',),),)
            .thenAnswer((_) async=> userCredential);
      // act
        final result = await authRemoteDataSource.signIn(tEmail, tPassword);

      // assert
        expect(result.uiD, userCredential.user!.uid);
        verify(() => authClient.signInWithEmailAndPassword
          (email: tEmail,password: tPassword,),)
            .called(1);
        verifyNoMoreInteractions(authClient);
    });

    test('should return ServerException when user is null'
        , () async{
          final emptyMockCredential = MockUserCredential();
          // arrange
          when(()=> authClient.signInWithEmailAndPassword(
            email: any(named: 'email'), password: any(named: 'password',),),)
              .thenAnswer((_) async=> emptyMockCredential);
          // act
          final call = authRemoteDataSource.signIn;

          // assert
          expect(()async=>call(tEmail,tPassword),
            throwsA(isA<ServerException>(),),);
          verify(() => authClient.signInWithEmailAndPassword
            (email: tEmail,password: tPassword,),)
              .called(1);
          verifyNoMoreInteractions(authClient);
        });

    test('should return ServerException when FirebaseAuthException is thrown'
        , () async{

      // arrange
      when(()=> authClient.signInWithEmailAndPassword(
        email: any(named: 'email'), password: any(named: 'password',),),)
          .thenThrow(FirebaseAuthException);
      // act
      final call = authRemoteDataSource.signIn;

      // assert
      expect(()async=>call(tEmail,tPassword),throwsA(isA<ServerException>()));
      verify(() => authClient.signInWithEmailAndPassword
        (email: tEmail,password: tPassword,),)
          .called(1);
      verifyNoMoreInteractions(authClient);
    });


  });


  group('signup', () {

    test('should complete successfully and return null', ()async{

      // arrange
      when(()=> authClient.createUserWithEmailAndPassword(
        email: any(named: 'email',),password: any(named: 'password'),
      ),).thenAnswer((_) async=> userCredential);

      when(() => userCredential.user?.updateDisplayName(any())).thenAnswer(
            (_) async => Future.value(),
      );

      when(() => userCredential.user?.updatePhotoURL(any())).thenAnswer(
            (_) async => Future.value(),
      );
      // act
      final result = authRemoteDataSource.signUp(tEmail,
          tPassword,tFullName,);

      expect(result, completes);

      verify(
            () => authClient.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      await untilCalled(() => userCredential.user?.updateDisplayName(any()));
      await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

      verify(() => userCredential.user?.updateDisplayName(tFullName))
          .called(1);
      verify(() => userCredential.user?.updatePhotoURL(kDefaultAvatar))
          .called(1);

      verifyNoMoreInteractions(authClient);

    });

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
          () async {
        when(
              () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = authRemoteDataSource.forgetPassword;

        expect(() => call(tEmail), throwsA(isA<ServerException>()));

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);
      },
    );
  });

  group('update user', () {

    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });
    test('update user displayName successfully ', ()async{

      // arrange
      when(()=> mockUser.updateDisplayName(any())).thenAnswer(
              (_) => Future.value(),);
      // act
      await authRemoteDataSource.updateUser
        (UpdateUserAction.displayName, 'name');


      verify(() => mockUser.updateDisplayName('name'))
          .called(1);
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePassword(any()));

      final userData = await cloudStoreClient.collection('users')
          .doc(mockUser.uid).get();
      expect(userData.data()!['fullName'],'name');

    });

    test('update user email successfully ', ()async{

      // arrange
      when(()=> mockUser.updateEmail(any())).thenAnswer(
            (_) => Future.value(),);
      // act
      await authRemoteDataSource.updateUser
        (UpdateUserAction.email, 'email');


      verify(() => mockUser.updateEmail('email'))
          .called(1);
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePassword(any()));

      final userData = await cloudStoreClient.collection('users')
          .doc(mockUser.uid).get();
      expect(userData.data()!['email'],'email');

    });

    test('update user bio successfully ', ()async{

      // act
      await authRemoteDataSource.updateUser
        (UpdateUserAction.bio, 'bio');

      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));
      verifyNever(() => mockUser.updatePassword(any()));

      final userData = await cloudStoreClient.collection('users')
          .doc(mockUser.uid).get();
      expect(userData.data()!['bio'],'bio');

    });

    test('update user password successfully ', ()async{

      // arrange
      when(()=> mockUser.reauthenticateWithCredential(
          any(),
      ),).thenAnswer(
            (_) async=> userCredential,);

      when(()=> mockUser.updatePassword(any())).thenAnswer(
            (_) async=> Future.value(),);

      when(() => mockUser.email).thenReturn(tEmail);
      // act
      await authRemoteDataSource.updateUser
        (UpdateUserAction.password,
        jsonEncode(
          {'oldPassword':'oldPassword','newPassword':tPassword},),);

      verify(() => mockUser.updatePassword(tPassword));
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePhotoURL(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));

      final userData = await cloudStoreClient.collection('users')
          .doc(mockUser.uid).get();
      expect(userData.data()!['password'],null);

    });

    test('update user profile pic successfully ', ()async{

      // arrange
      final newProfilePic = File('assets/images/onBoarding_background.png');
      when(()=> mockUser.updatePhotoURL(any())).thenAnswer(
            (_) async=> Future.value(),);

      // act
      await authRemoteDataSource.updateUser
        (UpdateUserAction.profilePic,
        newProfilePic,);

      verify(() => mockUser.updatePhotoURL(any())).called(1);
      verifyNever(() => mockUser.updateEmail(any()));
      verifyNever(() => mockUser.updatePassword(any()));
      verifyNever(() => mockUser.updateDisplayName(any()));

      expect(storageClient.storedFilesMap.isNotEmpty, isTrue);

    });

  });

}
