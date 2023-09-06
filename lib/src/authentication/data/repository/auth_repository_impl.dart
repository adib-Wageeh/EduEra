import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository{

  AuthenticationRepositoryImpl({required this.authRemoteDataSource});
  final AuthRemoteDataSource authRemoteDataSource;

  @override
  ResultFuture<void> forgetPassword({required String email}) async{

  try{
    await authRemoteDataSource.forgetPassword(email);
    return const Right(null);
  }on ServerException catch(e){
    return Left(ServerFailure(error: e.error, code: e.code));
    }

  }

  @override
  ResultFuture<UserEntity> signIn({required String email
    , required String password,})async{
    try{
      final response = await authRemoteDataSource.signIn(email,password);
      return Right(response);
    }on ServerException catch(e){
      return Left(ServerFailure(error: e.error, code: e.code));
    }


  }

  @override
  ResultFuture<void> signUp({required String email,
    required String password, required String fullName,}) async{
    try{
      await authRemoteDataSource.signUp(email,password,
      fullName,);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure(error: e.error, code: e.code));
    }
  }

  @override
  ResultFuture<void> updateData({required dynamic userData,
    required UpdateUserAction action,}) async{
    try{
      await authRemoteDataSource.updateUser(action,userData,);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure(error: e.error, code: e.code));
    }
  }



}