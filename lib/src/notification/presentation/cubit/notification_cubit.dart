import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';
import 'package:education_app/src/notification/domain/usecases/add_notification_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/clear_a_notification_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/clear_all_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/get_notifications_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/mark_as_read_use_case.dart';
import 'package:equatable/equatable.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required ClearANotificationUseCase clear,
    required ClearAllUseCase clearAll,
    required GetNotificationsUseCase getNotifications,
    required MarkAsReadUseCase markAsRead,
    required AddNotificationUseCase sendNotification,
  })  : _clear = clear,
        _clearAll = clearAll,
        _getNotifications = getNotifications,
        _markAsRead = markAsRead,
        _sendNotification = sendNotification,
        super(const NotificationInitial());

  final ClearANotificationUseCase _clear;
  final ClearAllUseCase _clearAll;
  final GetNotificationsUseCase _getNotifications;
  final MarkAsReadUseCase _markAsRead;
  final AddNotificationUseCase _sendNotification;

  Future<void> clear(String notificationId) async {
    emit(const ClearingNotifications());
    final result = await _clear(notificationId);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationCleared()),
    );
  }

  Future<void> clearAll() async {
    emit(const ClearingNotifications());
    final result = await _clearAll();
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationCleared()),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _markAsRead(notificationId);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationInitial()),
    );
  }

  Future<void> sendNotification(NotificationEntity notification) async {
    emit(const SendingNotification());
    final result = await _sendNotification(notification);
    result.fold(
      (failure) => emit(NotificationError(failure.errorMessage)),
      (_) => emit(const NotificationCleared()),
    );
  }

  void getNotifications() {
    emit(const GettingNotifications());
    StreamSubscription<Either<Failure,List<NotificationEntity>>>? subscription;

    subscription = _getNotifications().listen(
      /*onData:*/
      (result) {
        result.fold(
          (failure) {
            emit(NotificationError(failure.errorMessage));
            subscription?.cancel();
          },
          (notifications) => emit(NotificationsLoaded(notifications)),
        );
      },
      onError: (dynamic error) {
        emit(NotificationError(error.toString()));
        subscription?.cancel();
      },
      onDone: () {
        subscription?.cancel();
      },
    );
  }
}
