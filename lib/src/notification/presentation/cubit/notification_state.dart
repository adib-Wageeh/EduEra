part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class GettingNotifications extends NotificationState {
  const GettingNotifications();
}

class SendingNotification extends NotificationState {
  const SendingNotification();
}

class ClearingNotifications extends NotificationState {
  const ClearingNotifications();
}

class NotificationCleared extends NotificationState {
  const NotificationCleared();
}

class NotificationSent extends NotificationState {
  const NotificationSent();
}

class NotificationsLoaded extends NotificationState {
  const NotificationsLoaded(this.notifications);

  final List<NotificationEntity> notifications;

  @override
  List<Object> get props => notifications;
}

class NotificationError extends NotificationState {
  const NotificationError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
