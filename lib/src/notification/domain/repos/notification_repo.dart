import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';

abstract class NotificationRepo{

  ResultFuture<void> markAsRead(String notificationId);
  ResultStream<List<NotificationEntity>> getNotifications();
  ResultFuture<void> addNotification(NotificationEntity notification);
  ResultFuture<void> clearAll();
  ResultFuture<void> clearANotification(String notificationId);

}
