import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class SignUpUseCase extends FutureUseCaseWithParams<void,SignUpParams>{

  const SignUpUseCase({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  @override
  ResultFuture<void> call(SignUpParams p){
    return authenticationRepository.signUp(
        fullName: p.fullName,email: p.email,password: p.password,);
  }

}

class SignUpParams extends Equatable{

  const SignUpParams({required this.email,required this.password,
    required this.fullName,});

  factory SignUpParams.empty()=> const SignUpParams(
  fullName: ''
  ,email: '', password: '',);
  final String email;
  final String password;
  final String fullName;

  @override
  List<Object?> get props => [email,password,fullName];

}
