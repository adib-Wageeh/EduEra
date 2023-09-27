import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/data/datasources/notification_remote_data_source.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';


class NotificationRepoImpl extends NotificationRepo{

  NotificationRepoImpl({required this.notificationRemoteDataSource,});

  final NotificationRemoteDataSource notificationRemoteDataSource;

  @override
  ResultFuture<void> addNotification(NotificationEntity notification) async{
    try{

      await notificationRemoteDataSource.addNotification(notification);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }

  }

  @override
  ResultFuture<void> clearANotification(String notificationId) async{
    try{
      await notificationRemoteDataSource.clearANotification(notificationId);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> clearAll() async{

    try{
      await notificationRemoteDataSource.clearAll();
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultStream<List<NotificationEntity>> getNotifications() {

   return notificationRemoteDataSource.getNotifications().transform(
       StreamTransformer<List<NotificationModel>,
           Either<Failure, List<NotificationEntity>>>.fromHandlers(
         handleData: (data,sink){
           sink.add(Right(data));
         },
         handleError: (error,_,sink){
           if(error is ServerException){
             sink.add(Left(ServerFailure.fromException(error)));
           }else{
             sink.add(Left(ServerFailure(
               error: error.toString(),
               code: 505,
             ),),);

           }
         },
       ),
    );

  }

  @override
  ResultFuture<void> markAsRead(String notificationId) async{
    try{
      await notificationRemoteDataSource.markAsRead(notificationId);
      return const Right(null);
    }on ServerException catch(e){
      return Left(ServerFailure.fromException(e));
    }
  }



}
