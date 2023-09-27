import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';

class ForgetPasswordUseCase extends FutureUseCaseWithParams<void,String>{

  const ForgetPasswordUseCase({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  @override
  ResultFuture<void> call(String p){
    return authenticationRepository.forgetPassword(email: p);
  }


}