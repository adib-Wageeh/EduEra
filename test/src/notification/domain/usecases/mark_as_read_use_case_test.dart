import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/mark_as_read_use_case.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo_mock.dart';

void main() {

  late NotificationRepo notificationRepo;
  late MarkAsReadUseCase markAsReadUseCase;
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );

  setUp(() {

    notificationRepo = NotificationRepoMock();
    markAsReadUseCase = MarkAsReadUseCase
      (notificationRepo: notificationRepo);
  });

  test('should return right hand side void', () async{

    when(()=> notificationRepo.markAsRead(any()))
        .thenAnswer((_) async=> const Right(null));

    final result = await markAsReadUseCase('notificationId');

    expect(result, const Right<dynamic,void>(null));
    verify(
          ()=> notificationRepo.markAsRead('notificationId')
      ,).called(1);
    verifyNoMoreInteractions(notificationRepo);

  });

  test('should return left hand side failure', () async{

    when(()=> notificationRepo.markAsRead(any()))
        .thenAnswer((_) async=> const Left(tFailure));

    final result = await markAsReadUseCase('notificationId');

    expect(result, const Left<Failure,dynamic>(tFailure));
    verify(
          ()=> notificationRepo.markAsRead('notificationId')
      ,).called(1);
    verifyNoMoreInteractions(notificationRepo);

  });

}
