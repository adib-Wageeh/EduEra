import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';
import 'package:education_app/src/notification/domain/usecases/get_notifications_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'notification_repo_mock.dart';


void main() {

  late NotificationRepo notificationRepo;
  late GetNotificationsUseCase getNotificationsUseCase;
  const tFailure = ServerFailure(
    error: 'unknown error',
    code: 404,
  );

  setUp(() {

    notificationRepo = NotificationRepoMock();
    getNotificationsUseCase = GetNotificationsUseCase
      (notificationRepo: notificationRepo);

  });

  test('should return right hand side list<Notification>', (){

    when(()=> notificationRepo.getNotifications())
        .thenAnswer((_) => Stream.value(const Right([])));

    final result = getNotificationsUseCase();

    expect(result, emits(const Right<dynamic,List<NotificationEntity>>([])));
    verify(
          ()=> notificationRepo.getNotifications()
      ,).called(1);
    verifyNoMoreInteractions(notificationRepo);

  });

  test('should return left hand side failure', () {

    when(()=> notificationRepo.getNotifications())
        .thenAnswer((_) => Stream.value(const Left(tFailure)));

    final result = getNotificationsUseCase();

    expect(result, emits(const Left<Failure,dynamic>(tFailure)));
    verify(
          ()=> notificationRepo.getNotifications()
      ,).called(1);
    verifyNoMoreInteractions(notificationRepo);

  });

}
