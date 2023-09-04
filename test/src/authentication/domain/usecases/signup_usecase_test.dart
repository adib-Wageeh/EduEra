import 'package:dartz/dartz.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:education_app/src/authentication/domain/usecases/signup_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_authentication_repository.dart';

void main() {

  late AuthenticationRepository authenticationRepository;
  late SignUpUseCase signUpUseCase;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    signUpUseCase = SignUpUseCase(authenticationRepository:
    authenticationRepository,);
  });

  final tUserEntity = UserEntity.empty();
  test('calls authenticationRepository.signup'
      ' and received right(void)', () async{

    // arrange
    when(()=> authenticationRepository.signUp(
    password: any(named: 'password'),
    fullName: any(named: 'fullName')
    ,email: any(named: 'email'),),).
    thenAnswer((_) async=> const Right(null));

    // act
    final result = await signUpUseCase.call(SignUpParams(
        email: tUserEntity.email,
    fullName: tUserEntity.fullName,password: '',
    ),);

    // assert
    expect(result, const Right<dynamic,void>(null));
    verify(()=> authenticationRepository.signUp(
      password: '',fullName: tUserEntity.fullName,
      email: tUserEntity.email,
    ),).called(1);
    verifyNoMoreInteractions(authenticationRepository);

  });

}
