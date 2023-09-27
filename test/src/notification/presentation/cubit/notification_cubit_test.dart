import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:education_app/src/notification/domain/usecases/add_notification_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/clear_a_notification_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/clear_all_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/get_notifications_use_case.dart';
import 'package:education_app/src/notification/domain/usecases/mark_as_read_use_case.dart';
import 'package:education_app/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClear extends Mock implements ClearANotificationUseCase {}
class MockClearAll extends Mock implements ClearAllUseCase {}
class MockGetNotifications extends Mock implements GetNotificationsUseCase {}
class MockMarkAsRead extends Mock implements MarkAsReadUseCase {}
class MockSendNotification extends Mock implements AddNotificationUseCase {}

void main() {

  late NotificationCubit cubit;
  late ClearANotificationUseCase clear;
  late ClearAllUseCase clearAll;
  late GetNotificationsUseCase getNotifications;
  late MarkAsReadUseCase markAsRead;
  late AddNotificationUseCase sendNotification;

  setUp(() {
    clear = MockClear();
    clearAll = MockClearAll();
    getNotifications = MockGetNotifications();
    markAsRead = MockMarkAsRead();
    sendNotification = MockSendNotification();
    cubit = NotificationCubit(
      clear: clear,
      clearAll: clearAll,
      getNotifications: getNotifications,
      markAsRead: markAsRead,
      sendNotification: sendNotification,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is NotificationInitial', () {
    expect(cubit.state, const NotificationInitial());
  });

  const tFailure = ServerFailure(error: 'Server Error', code: 500);

  group('clear', () {
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[ClearingNotifications, NotificationInitial] when successful',
      build: () {
        when(() => clear(any())).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clear('id'),
      expect: () => [
        const ClearingNotifications(),
        const NotificationInitial(),
      ],
      verify: (_) {
        verify(() => clear('id')).called(1);
        verifyNoMoreInteractions(clear);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[ClearingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(() => clear(any())).thenAnswer(
              (_) async => const Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.clear('id'),
      expect: () => [
        const ClearingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => clear('id')).called(1);
        verifyNoMoreInteractions(clear);
      },
    );
  });

  group('clearAll', () {
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[ClearingNotifications, NotificationInitial] when successful',
      build: () {
        when(() => clearAll()).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => [
        const ClearingNotifications(),
        const NotificationInitial(),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[ClearingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(() => clearAll()).thenAnswer(
              (_) async => const Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.clearAll(),
      expect: () => [
        const ClearingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => clearAll()).called(1);
        verifyNoMoreInteractions(clearAll);
      },
    );
  });

  group('markAsRead', () {
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[NotificationInitial] when successful',
      build: () {
        when(() => markAsRead(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.markAsRead('id'),
      expect: () => [const NotificationInitial()],
      verify: (_) {
        verify(() => markAsRead('id')).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[NotificationError] when unsuccessful',
      build: () {
        when(() => markAsRead(any())).thenAnswer(
              (_) async => const Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.markAsRead('id'),
      expect: () => [NotificationError(tFailure.errorMessage)],
      verify: (_) {
        verify(() => markAsRead('id')).called(1);
        verifyNoMoreInteractions(markAsRead);
      },
    );
  });

  group('sendNotification', () {
    final tNotification = NotificationModel.empty();
    setUp(() => registerFallbackValue(tNotification));

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[SendingNotification, NotificationSent] when successful',
      build: () {
        when(() => sendNotification(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => [
        const SendingNotification(),
        const NotificationSent(),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[SendingNotification, NotificationError] when unsuccessful',
      build: () {
        when(() => sendNotification(any())).thenAnswer(
              (_) async => const Left(tFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.sendNotification(tNotification),
      expect: () => [
        const SendingNotification(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => sendNotification(tNotification)).called(1);
        verifyNoMoreInteractions(sendNotification);
      },
    );
  });

  group('getNotifications', () {
    final tNotifications = [NotificationModel.empty()];
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[GettingNotifications, NotificationsLoaded] when successful',
      build: () {
        when(() => getNotifications()).thenAnswer(
              (_) => Stream.value(Right(tNotifications)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => [
        const GettingNotifications(),
        NotificationsLoaded(tNotifications),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
    blocTest<NotificationCubit, NotificationState>(
      'should emit '
          '[GettingNotifications, NotificationError] when unsuccessful',
      build: () {
        when(() => getNotifications()).thenAnswer(
              (_) => Stream.value(const Left(tFailure)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getNotifications(),
      expect: () => [
        const GettingNotifications(),
        NotificationError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getNotifications()).called(1);
        verifyNoMoreInteractions(getNotifications);
      },
    );
  });

}
