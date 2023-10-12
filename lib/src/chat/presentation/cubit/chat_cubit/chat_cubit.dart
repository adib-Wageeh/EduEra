import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/usecases/get_messages_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/get_user_by_id_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/send_message_use_case.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required GetMessagesUseCase getMessages,
    required GetUserByIdUseCase getUserById,
    required SendMessageUseCase sendMessage,
  })  :
        _getMessages = getMessages,
        _getUserById = getUserById,
        _sendMessage = sendMessage,
        super(const ChatInitial());


  final GetMessagesUseCase _getMessages;
  final GetUserByIdUseCase _getUserById;
  final SendMessageUseCase _sendMessage;

  Future<void> sendMessage(MessageEntity message) async {
    emit(const SendingMessage());
    final result = await _sendMessage(message);
    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (_) => emit(const MessageSent()),
    );
  }



  Future<void> getUser(String userId) async {
    emit(const GettingUser());
    final result = await _getUserById(userId);

    result.fold(
      (failure) => emit(ChatError(failure.errorMessage)),
      (user) => emit(UserFound(user)),
    );
  }

  void getMessages(String groupId) {
    emit(const LoadingMessages());
    StreamSubscription<Either<Failure, List<MessageEntity>>>? subscription;
    subscription = _getMessages(groupId).listen(
      (result) {
        result.fold(
          (failure) => emit(ChatError(failure.errorMessage)),
          (messages)
        {
         return emit(MessagesLoaded(messages));
        }
        );
      },
      onError: (dynamic error) {
        emit(ChatError(error.toString()));
        subscription?.cancel();
      },
      onDone: () {
        subscription?.cancel();
      },
    );
  }
}
