import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:education_app/src/authentication/domain/usecases/update_data_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_authentication_repository.dart';

void main() {

  late AuthenticationRepository authenticationRepository;
  late UpdateDataUseCase updateDataUseCase;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    updateDataUseCase = UpdateDataUseCase(authenticationRepository:
    authenticationRepository,);
    registerFallbackValue(UpdateUserAction.password);
  });

  test('calls authenticationRepository.updateData and received right(void)',
          () async{
    // arrange
    when(()=> authenticationRepository.updateData(
      action: any(named: 'action'),
      userData: '',
    ),).
    thenAnswer((_) async=> const Right(null));

    // act
    final result = await updateDataUseCase.call(
      const UpdateDataParams(userData: '', action: UpdateUserAction.email)
    ,);

    // assert
    expect(result, const Right<dynamic,void>(null));
    verify(()=> authenticationRepository.updateData(
      userData: '',action: UpdateUserAction.email,
    ),).called(1);
    verifyNoMoreInteractions(authenticationRepository);

  });
}
