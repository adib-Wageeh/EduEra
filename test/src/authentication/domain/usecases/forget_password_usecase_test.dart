import 'package:dartz/dartz.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:education_app/src/authentication/domain/usecases/forget_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_authentication_repository.dart';



void main() {

  late AuthenticationRepository authenticationRepository;
  late ForgetPasswordUseCase forgetPasswordUseCase;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    forgetPasswordUseCase = ForgetPasswordUseCase(authenticationRepository:
    authenticationRepository,);
  });

  const tEmail = 'email@gmail.com';
  test('calls authenticationRepository and received right(void)', () async{

    // arrange
    when(()=> authenticationRepository.forgetPassword(email: tEmail)).
    thenAnswer((_) async=> const Right(null));

    // act
    final result = await forgetPasswordUseCase.call(tEmail);

    // assert
    expect(result, const Right<dynamic,void>(null));
    verify(()=> authenticationRepository.forgetPassword(email: tEmail))
        .called(1);
    verifyNoMoreInteractions(authenticationRepository);

  });


}
