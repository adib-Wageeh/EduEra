import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/add_notification_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo_mock.dart';

void main() {

  late NotificationRepo notificationRepo;
  late AddNotificationUseCase addNotificationUseCase;
  final tNotification = NotificationEntity.empty();
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );

  setUp(() {

    notificationRepo = NotificationRepoMock();
    addNotificationUseCase = AddNotificationUseCase
      (notificationRepo: notificationRepo);
    registerFallbackValue(tNotification);
  });

  test('should return right hand side void', () async{

      when(()=> notificationRepo.addNotification(any()))
          .thenAnswer((_) async=> const Right(null));

      final result = await addNotificationUseCase(tNotification);

      expect(result, const Right<dynamic,void>(null));
      verify(
          ()=> notificationRepo.addNotification(tNotification)
      ,).called(1);
      verifyNoMoreInteractions(notificationRepo);

  });

  test('should return left hand side failure', () async{

    when(()=> notificationRepo.addNotification(any()))
        .thenAnswer((_) async=> const Left(tFailure));

    final result = await addNotificationUseCase(tNotification);

    expect(result, const Left<Failure,dynamic>(tFailure));
    verify(
          ()=> notificationRepo.addNotification(tNotification)
      ,).called(1);
    verifyNoMoreInteractions(notificationRepo);

  });

}
