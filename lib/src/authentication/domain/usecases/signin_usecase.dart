import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class SignInUseCase extends UseCaseWithParams<UserEntity,SignInParams>{

  const SignInUseCase({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  @override
  ResultFuture<UserEntity> call(SignInParams p){
    return authenticationRepository.signIn(email: p.email,password: p.password);
  }


}

class SignInParams extends Equatable{

  const SignInParams({required this.email,required this.password});

  factory SignInParams.empty()=> const SignInParams(email: '', password: '');
  final String email;
  final String password;

  @override
  List<Object?> get props => [email,password];

}
