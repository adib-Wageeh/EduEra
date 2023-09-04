import 'package:dartz/dartz.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:education_app/src/authentication/domain/usecases/signin_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_authentication_repository.dart';

void main() {


  late AuthenticationRepository authenticationRepository;
  late SignInUseCase signInUseCase;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    signInUseCase = SignInUseCase(authenticationRepository:
    authenticationRepository,);
  });


  final tUserEntity = UserEntity.empty();
  test('calls authenticationRepository.signIn and received right(UserEntity)',
          () async{

    // arrange
    when(()=> authenticationRepository.signIn(email: any(named: 'email'),
    password: any(named: 'password'),),).
    thenAnswer((_) async=> Right(tUserEntity));

    // act
    final result = await signInUseCase.call(const SignInParams(email: ''
        , password: '',),);

    // assert
    expect(result, Right<dynamic,UserEntity>(tUserEntity));
    verify(()=> authenticationRepository.signIn(email: '',
    password: '',),)
        .called(1);
    verifyNoMoreInteractions(authenticationRepository);

  });

}