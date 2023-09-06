import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/data/repository/auth_repository_impl.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource{}

void main() {

  late AuthenticationRepositoryImpl authenticationRepositoryImpl;
  late AuthRemoteDataSource authRemoteDataSource;
  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tEmail = 'Test email';
  const tUpdateAction = UpdateUserAction.password;
  const tUserData = 'New password';
  final tUserModel = UserModel.empty();

  setUp(() {
    authRemoteDataSource = MockAuthRemoteDataSource();
    authenticationRepositoryImpl = AuthenticationRepositoryImpl
      (authRemoteDataSource: authRemoteDataSource);
    registerFallbackValue(tUpdateAction);
  });



  group('forgetPassword', () {

    test('calls authRemoteDataSource successfully and returns void', () async{

      // arrange
      when(() =>
      authRemoteDataSource.forgetPassword(any()),
      ).thenAnswer((_) async=> Future.value());

      // act
      final result = await authenticationRepositoryImpl.forgetPassword
        (email: tEmail);

      // assert
      expect(result, equals(const Right<dynamic,void>(null)));
      verify(()=> authRemoteDataSource.forgetPassword(tEmail)).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });


    test('calls authRemoteDataSource unsuccessfully and returns ServerFailure',
            () async{

      // arrange
      when(() =>
          authRemoteDataSource.forgetPassword(any()),
      ).thenThrow(const ServerException(error: 'unreachable server',
          code: '400',),);

      // act
      final result = await authenticationRepositoryImpl.forgetPassword(
          email: tEmail,);

      // assert
      expect(result
          ,equals(const Left<ServerFailure,dynamic>
          (ServerFailure(error: 'unreachable server',
          code: '400',),),),);
      verify(()=> authRemoteDataSource.forgetPassword(tEmail)).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });

  });

  group('signIn', () {

    test('calls authRemoteDataSource successfully and returns UserEntity'
        , () async{

      // arrange
      when(() =>
          authRemoteDataSource.signIn(any(),any()),
      ).thenAnswer((_) async=> tUserModel);

      // act
      final result = await authenticationRepositoryImpl.signIn
        (email: tEmail, password: tPassword);


      // assert
      expect(result, equals(Right<dynamic,UserEntity>(tUserModel)));
      verify(()=> authRemoteDataSource.signIn(tEmail,
      tPassword,),).called(1);
      verifyNoMoreInteractions(authRemoteDataSource);
    });


    test('calls authRemoteDataSource unsuccessfully and returns ServerFailure',
            () async{

          // arrange
          when(() =>
              authRemoteDataSource.signIn(any(),any()),
          ).thenThrow(const ServerException(error: 'unreachable server',
            code: '400',),);

          // act
          final result = await authenticationRepositoryImpl.signIn
            (email: tEmail, password: tPassword);

          // assert
          expect(result
            ,equals(const Left<ServerFailure,dynamic>
              (ServerFailure(error: 'unreachable server',
              code: '400',),),),);
          verify(()=> authRemoteDataSource.signIn(tEmail,
          tPassword,),).called(1);
          verifyNoMoreInteractions(authRemoteDataSource);
        });

  });

  group('signUp', () {

    test('calls authRemoteDataSource successfully and returns Right(null)'
        , () async{

          // arrange
          when(() =>
              authRemoteDataSource.signUp(any(),
                  any(),any(),),
          ).thenAnswer((_) async=> Future.value());

          // act
          final result = await authenticationRepositoryImpl.signUp
            (email: tEmail, password: tPassword,fullName: tFullName);


          // assert
          expect(result, equals(const Right<dynamic,void>(null)));
          verify(()=> authRemoteDataSource.signUp(tEmail,
            tPassword,tFullName,),).called(1);
          verifyNoMoreInteractions(authRemoteDataSource);
        });


    test('calls authRemoteDataSource unsuccessfully and returns ServerFailure',
            () async{

          // arrange
          when(() =>
              authRemoteDataSource.signUp(any(),any(),any()),
          ).thenThrow(const ServerException(error: 'unreachable server',
            code: '400',),);

          // act
          final result = await authenticationRepositoryImpl.signUp
            (email: tEmail, password: tPassword,fullName: tFullName);

          // assert
          expect(result
            ,equals(const Left<ServerFailure,dynamic>
              (ServerFailure(error: 'unreachable server',
              code: '400',),),),);
          verify(()=> authRemoteDataSource.signUp(tEmail,
            tPassword,tFullName,),).called(1);
          verifyNoMoreInteractions(authRemoteDataSource);
        });

  });

  group('update data', () {

    test('calls authRemoteDataSource successfully and returns Right(null)'
        , () async{

          // arrange
          when(() =>
              authRemoteDataSource.updateUser(any(),
                any<dynamic>(),),
          ).thenAnswer((_) async=> Future.value());

          // act
          final result = await authenticationRepositoryImpl.updateData
            (action: tUpdateAction,userData: tUserData);


          // assert
          expect(result, equals(const Right<dynamic,void>(null)));
          verify(()=> authRemoteDataSource.updateUser(tUpdateAction,
            tUserData,),).called(1);
          verifyNoMoreInteractions(authRemoteDataSource);
        });


    test('calls authRemoteDataSource unsuccessfully and returns ServerFailure',
            () async{

          // arrange
          when(() =>
              authRemoteDataSource.updateUser(any(),any<dynamic>(),),
          ).thenThrow(const ServerException(error: 'unreachable server',
            code: '400',),);

          // act
          final result = await authenticationRepositoryImpl.updateData
            (userData: tUserData,action: tUpdateAction);

          // assert
          expect(result
            ,equals(const Left<ServerFailure,dynamic>
              (ServerFailure(error: 'unreachable server',
              code: '400',),),),);
          verify(()=> authRemoteDataSource.updateUser(tUpdateAction,
            tUserData,),).called(1);
          verifyNoMoreInteractions(authRemoteDataSource);
        });

  });

}
