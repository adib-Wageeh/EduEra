import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/data/datasources/notification_remote_data_source.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:education_app/src/notification/data/repos/notification_repo_impl.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class NotificationRemoteDataSourceMock extends Mock implements
    NotificationRemoteDataSource{}

void main() {

  late NotificationRemoteDataSource remoteDataSource;
  late NotificationRepoImpl repoImpl;
  final tNotification = NotificationEntity.empty();
  const tException = ServerException(
    error: 'unknown error',
    code: '404',
  );

  setUp(() {
    remoteDataSource = NotificationRemoteDataSourceMock();
    repoImpl = NotificationRepoImpl(notificationRemoteDataSource:
    remoteDataSource,);
    registerFallbackValue(tNotification);
  });


  group('addNotification', () {

    test('should return right hand side void', () async{

      when(()=> remoteDataSource.addNotification(any()))
          .thenAnswer((_) async=> Future.value());

      final result = await repoImpl.addNotification(tNotification);

      expect(result, const Right<dynamic,void>(null));
      verify(
          ()=> remoteDataSource.addNotification(tNotification),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);

    });

    test('should return left hand side void', () async{

      when(()=> remoteDataSource.addNotification(any()))
          .thenThrow(tException);

      final result = await repoImpl.addNotification(tNotification);

      expect(result,
           Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> remoteDataSource.addNotification(tNotification),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('clearANotification', () {

    test('should return right hand side void', () async{

      when(()=> remoteDataSource.clearANotification(any()))
          .thenAnswer((_) async=> Future.value());

      final result = await repoImpl.clearANotification('notificationId');

      expect(result, const Right<dynamic,void>(null));
      verify(
            ()=> remoteDataSource.clearANotification('notificationId'),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);

    });

    test('should return left hand side void', () async{

      when(()=> remoteDataSource.clearANotification(any()))
          .thenThrow(tException);

      final result = await repoImpl.clearANotification('notificationId');

      expect(result,
        Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> remoteDataSource.clearANotification('notificationId'),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('clearAll', () {

    test('should return right hand side void', () async{

      when(()=> remoteDataSource.clearAll())
          .thenAnswer((_) async=> Future.value());

      final result = await repoImpl.clearAll();

      expect(result, const Right<dynamic,void>(null));
      verify(
            ()=> remoteDataSource.clearAll(),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);

    });

    test('should return left hand side void', () async{

      when(()=> remoteDataSource.clearAll())
          .thenThrow(tException);

      final result = await repoImpl.clearAll();

      expect(result,
        Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> remoteDataSource.clearAll(),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getNotifications', () {

    test('should emit right hand side list<notification> '
        'when it receives data successfully', () {

      final notifications = [NotificationModel.empty(),];
      when(()=> remoteDataSource.getNotifications())
          .thenAnswer((_) => Stream.value(notifications));

      final result = repoImpl.getNotifications();

      expect(result,
          emits(Right<dynamic,List<NotificationEntity>>(notifications)),);
      verify(
            ()=> remoteDataSource.getNotifications(),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);

    });

    test('should emit sever failure '
        'when stream throws a serverException', () {

      when(()=> remoteDataSource.getNotifications())
          .thenAnswer((_) => Stream.error(tException));

      final result = repoImpl.getNotifications();

      expect(result,
        emits(
        Left<Failure,dynamic>(ServerFailure.fromException(tException)),),);
      verify(
            ()=> remoteDataSource.getNotifications(),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('markAsRead', () {

    test('should return right hand side void', () async{

      when(()=> remoteDataSource.markAsRead(any()))
          .thenAnswer((_) => Future.value());

      final result = await repoImpl.markAsRead('notificationId');

      expect(result, const Right<dynamic,void>(null));
      verify(
            ()=> remoteDataSource.markAsRead('notificationId'),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);

    });

    test('should return left hand side void', () async{

      when(()=> remoteDataSource.markAsRead(any()))
          .thenThrow(tException);

      final result = await repoImpl.markAsRead('notificationId');

      expect(result,

          Left<Failure,dynamic>(ServerFailure.fromException(tException)),);
      verify(
            ()=> remoteDataSource.markAsRead('notificationId'),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

}
