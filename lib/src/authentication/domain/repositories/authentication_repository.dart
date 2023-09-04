import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationRepository{

  const AuthenticationRepository();

  ResultFuture<UserEntity> signIn({
    required String email,required String password,});

  ResultFuture<void> signUp({
    required String email,required String password,
  required String fullName,
  });

  ResultFuture<void> forgetPassword({
     String email,});

  ResultFuture<void> updateData({
     dynamic userData,
    UpdateUserAction action,
  });

}
