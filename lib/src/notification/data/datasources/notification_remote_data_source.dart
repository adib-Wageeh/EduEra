import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class NotificationRemoteDataSource{

  Future<void> addNotification(NotificationEntity notificationEntity);
  Future<void> clearANotification(String notificationId);
  Future<void> clearAll();
  Stream<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);

}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource{

  NotificationRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
}):
      _firebaseAuth = auth,
      _firebaseFirestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<void> addNotification(NotificationEntity notificationEntity) async{

    try{

      final user = _firebaseAuth.currentUser;
      if(user == null){
        throw const ServerException
          (code: '401',error: 'user is not authenticated');
      }

      final users = await _firebaseFirestore.collection('users').get();

      if (users.docs.length > 500) {
        for (var i = 0; i < users.docs.length; i += 500) {
          // 1400
          final batch = _firebaseFirestore.batch();
          final end = i + 500;
          final usersBatch = users.docs
              .sublist(i, end > users.docs.length ? users.docs.length : end);
          for (final user in usersBatch) {
            final newNotificationRef =
            user.reference.collection('notifications').doc();
            batch.set(
              newNotificationRef,
              (notificationEntity as NotificationModel)
                  .copyWith(id: newNotificationRef.id)
                  .toMap(),
            );
          }
          await batch.commit();
        }
      } else {
        final batch = _firebaseFirestore.batch();
        for (final user in users.docs) {
          final newNotificationRef =
          user.reference.collection('notifications').doc();
          batch.set(
            newNotificationRef,
            (notificationEntity as NotificationModel)
                .copyWith(id: newNotificationRef.id)
                .toMap(),
          );
        }
        await batch.commit();
      }


    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }

  }

  @override
  Future<void> clearANotification(String notificationId) async{

    try{

      final user = _firebaseAuth.currentUser;
      if(user == null){
        throw const ServerException
          (code: '401',error: 'user is not authenticated');
      }

      await _firebaseFirestore.collection('users')
      .doc(user.uid).collection('notifications')
          .doc(notificationId).delete();

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }

  }

  @override
  Future<void> clearAll() async{

    try{

      final user = _firebaseAuth.currentUser;
      if(user == null){
        throw const ServerException
          (code: '401',error: 'user is not authenticated');
      }

      final notificationRef = await _firebaseFirestore.collection('users')
      .doc(user.uid).collection('notifications')
      .get();

      final batch = _firebaseFirestore.batch();
      for(final notification in notificationRef.docs){
        batch.delete(notification.reference);
      }
      await batch.commit();

    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }

  }

  @override
  Stream<List<NotificationModel>> getNotifications() {
    try{

      final user = _firebaseAuth.currentUser;
      if(user == null){
        throw const ServerException
          (code: '401',error: 'user is not authenticated');
      }

      final notificationsStream =
      _firebaseFirestore.collection('users')
      .doc(user.uid).collection('notifications')
      .orderBy('sentAt',descending: true)
      .snapshots().map((event) => event.docs
      .map((e) => NotificationModel.fromMap(e.data())).toList(),);

      return notificationsStream.handleError((dynamic error){
        if (error is FirebaseException) {
          throw ServerException(
            error: error.message ?? 'Unknown error occurred',
            code: error.code,
          );
        }
        throw ServerException(error: error.toString(), code: '505');
      });


    }on FirebaseException catch(e){
     return Stream.error(ServerException
        (code: e.code,error: e.message??'unknown error occurred'),);
    } on ServerException catch(e){
      return Stream.error(e);
    }catch(e){
      return Stream.error(ServerException
        (code: '505',error: e.toString()),);
    }

  }



  @override
  Future<void> markAsRead(String notificationId) async{

    try{

      final user = _firebaseAuth.currentUser;
      if(user == null){
        throw const ServerException
          (code: '401',error: 'user is not authenticated');
      }
      await _firebaseFirestore.collection('users')
        .doc(user.uid).collection('notifications')
        .doc(notificationId).update
        ({
        'seen': true
      });
    }on FirebaseException catch(e){
      throw ServerException
        (code: e.code,error: e.message??'unknown error occurred');
    } on ServerException{
      rethrow;
    }catch(e){
      throw ServerException
        (code: '505',error: e.toString());
    }

  }

}
