import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/clear_all_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo_mock.dart';


void main() {

  late NotificationRepo notificationRepo;
  late ClearAllUseCase clearAllUseCase;
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );

  setUp(() {

    notificationRepo = NotificationRepoMock();
    clearAllUseCase = ClearAllUseCase
      (notificationRepo: notificationRepo);
  });

  test('should return right hand side void', () async{

    when(()=> notificationRepo.clearAll())
        .thenAnswer((_) async=> const Right(null));

    final result = await clearAllUseCase();

    expect(result, const Right<dynamic,void>(null));
    verify(
          ()=> notificationRepo.clearAll()
      ,).called(1);
    verifyNoMoreInteractions(notificationRepo);

  });

  test('should return left hand side failure', () async{

    when(()=> notificationRepo.clearAll())
        .thenAnswer((_) async=> const Left(tFailure));

    final result = await clearAllUseCase();

    expect(result, const Left<Failure,dynamic>(tFailure));
    verify(
          ()=> notificationRepo.clearAll()
      ,).called(1);
    verifyNoMoreInteractions(notificationRepo);

  });

}
