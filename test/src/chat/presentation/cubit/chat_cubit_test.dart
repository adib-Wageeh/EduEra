import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';

import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/domain/usecases/get_groups_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/get_messages_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/get_user_by_id_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/join_group_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/leave_group_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/send_message_use_case.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendMessage extends Mock implements SendMessageUseCase {}

class MockGetMessages extends Mock implements GetMessagesUseCase {}

class MockGetGroups extends Mock implements GetGroupsUseCase {}

class MockJoinGroup extends Mock implements JoinGroupUseCase {}

class MockLeaveGroup extends Mock implements LeaveGroupUseCase {}

class MockGetUserById extends Mock implements GetUserByIdUseCase {}

void main() {
  late SendMessageUseCase sendMessage;
  late GetMessagesUseCase getMessages;
  late GetGroupsUseCase getGroups;
  late JoinGroupUseCase joinGroup;
  late LeaveGroupUseCase leaveGroup;
  late GetUserByIdUseCase getUserById;
  late ChatCubit chatCubit;
  late GroupCubit groupCubit;

  setUp(() {
    sendMessage = MockSendMessage();
    getMessages = MockGetMessages();
    getGroups = MockGetGroups();
    joinGroup = MockJoinGroup();
    leaveGroup = MockLeaveGroup();
    getUserById = MockGetUserById();
    chatCubit = ChatCubit(
      sendMessage: sendMessage,
      getMessages: getMessages,
      getUserById: getUserById,
    );
    groupCubit = GroupCubit(getGroups: getGroups,
        joinGroup: joinGroup,
        leaveGroup: leaveGroup,);
  });

  tearDown(() {
    chatCubit.close();
  });

  const tFailure = ServerFailure(error: 'Server Error', code: 500);

  test('initial state is ChatInitial', () {
    expect(chatCubit.state, const ChatInitial());
  });

  group('sendMessage', () {
    final message = MessageModel.empty();

    blocTest<ChatCubit, ChatState>(
      'emits [SendingMessage, MessageSent] when successful',
      build: () {
        when(() => sendMessage(message)).thenAnswer(
          (_) async => const Right(null),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.sendMessage(message),
      expect: () => const [
        SendingMessage(),
        MessageSent(),
      ],
      verify: (_) {
        verify(() => sendMessage(message)).called(1);
        verifyNoMoreInteractions(sendMessage);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [SendingMessage, ChatError] when unsuccessful',
      build: () {
        when(() => sendMessage(message)).thenAnswer(
          (_) async => const Left(tFailure),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.sendMessage(message),
      expect: () => [
        const SendingMessage(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => sendMessage(message)).called(1);
        verifyNoMoreInteractions(sendMessage);
      },
    );
  });

  group('joinGroup', () {
    blocTest<GroupCubit, GroupState>(
      'emits [JoiningGroup, JoinedGroup] when successful',
      build: () {
        when(() => joinGroup(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return groupCubit;
      },
      act: (cubit) => cubit.joinGroup(groupId: 'group_id'),
      expect: () => const [
        JoiningGroup(),
        JoinedGroup(),
      ],
      verify: (_) {
        verify(() => joinGroup('group_id')).called(1);
        verifyNoMoreInteractions(joinGroup);
      },
    );

    blocTest<GroupCubit, GroupState>(
      'emits [JoiningGroup, ChatError] when unsuccessful',
      build: () {
        when(() => joinGroup(any())).thenAnswer(
          (_) async => const Left(tFailure),
        );
        return groupCubit;
      },
      act: (cubit) => cubit.joinGroup(groupId: 'group_id'),
      expect: () => [
        const JoiningGroup(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => joinGroup('group_id')).called(1);
        verifyNoMoreInteractions(joinGroup);
      },
    );
  });

  group('leaveGroup', () {
    blocTest<GroupCubit, GroupState>(
      'emits [LeavingGroup, LeftGroup] when successful',
      build: () {
        when(() => leaveGroup(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return groupCubit;
      },
      act: (cubit) => cubit.leaveGroup(groupId: 'group_id'),
      expect: () => const [
        LeavingGroup(),
        LeftGroup(),
      ],
      verify: (_) {
        verify(() => leaveGroup('group_id')).called(1);
        verifyNoMoreInteractions(leaveGroup);
      },
    );

    blocTest<GroupCubit, GroupState>(
      'emits [LeavingGroup, ChatError] when unsuccessful',
      build: () {
        when(() => leaveGroup(any())).thenAnswer(
          (_) async => const Left(tFailure),
        );
        return groupCubit;
      },
      act: (cubit) => cubit.leaveGroup(groupId: 'group_id'),
      expect: () => [
        const LeavingGroup(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => leaveGroup('group_id')).called(1);
        verifyNoMoreInteractions(leaveGroup);
      },
    );
  });

  group('getUser', () {
    final tUser = UserModel.empty();
    const tUserId = 'userId';
    blocTest<ChatCubit, ChatState>(
      'emits [GettingUser, UserFound] when successful',
      build: () {
        when(() => getUserById(any())).thenAnswer(
          (_) async => Right(tUser),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getUser(tUserId),
      expect: () => [
        const GettingUser(),
        UserFound(tUser),
      ],
      verify: (_) {
        verify(() => getUserById(tUserId)).called(1);
        verifyNoMoreInteractions(getUserById);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits [GettingUser, UserError] when unsuccessful',
      build: () {
        when(() => getUserById(any())).thenAnswer((_) async =>
        const Left(tFailure),);
        return chatCubit;
      },
      act: (cubit) => cubit.getUser(tUserId),
      expect: () => [
        const GettingUser(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUserById(tUserId)).called(1);
        verifyNoMoreInteractions(getUserById);
      },
    );
  });

  group('getGroups', () {
    final tGroups = [GroupModel.empty()];
    blocTest<GroupCubit, GroupState>(
      'should emit [LoadingGroups, GroupsLoaded] when successful',
      build: () {
        when(() => getGroups()).thenAnswer((_) => Stream.value(Right(tGroups)));
        return groupCubit;
      },
      act: (cubit) => cubit.getGroups(),
      expect: () => [
        const LoadingGroups(),
        GroupsLoaded(tGroups),
      ],
      verify: (_) {
        verify(() => getGroups()).called(1);
        verifyNoMoreInteractions(getGroups);
      },
    );
    blocTest<GroupCubit, GroupState>(
      'should emit [LoadingGroups, ChatError] when unsuccessful',
      build: () {
        when(() => getGroups()).thenAnswer((_) =>
            Stream.value(const Left(tFailure)),);
        return groupCubit;
      },
      act: (cubit) => cubit.getGroups(),
      expect: () => [
        const LoadingGroups(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getGroups()).called(1);
        verifyNoMoreInteractions(getGroups);
      },
    );
  });

  group('getMessages', () {
    final tMessages = [MessageModel.empty()];
    const tGroupId = 'groupId';
    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingMessages, MessagesLoaded] when successful',
      build: () {
        when(() => getMessages(any())).thenAnswer(
          (_) => Stream.value(Right(tMessages)),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getMessages(tGroupId),
      expect: () => [
        const LoadingMessages(),
        MessagesLoaded(tMessages),
      ],
      verify: (_) {
        verify(() => getMessages(tGroupId)).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );
    blocTest<ChatCubit, ChatState>(
      'should emit [LoadingMessages, ChatError] when successful',
      build: () {
        when(() => getMessages(any())).thenAnswer(
          (_) => Stream.value(const Left(tFailure)),
        );
        return chatCubit;
      },
      act: (cubit) => cubit.getMessages(tGroupId),
      expect: () => [
        const LoadingMessages(),
        ChatError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getMessages(tGroupId)).called(1);
        verifyNoMoreInteractions(getMessages);
      },
    );
  });
}
