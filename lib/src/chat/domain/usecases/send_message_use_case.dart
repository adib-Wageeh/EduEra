import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class SendMessageUseCase extends FutureUseCaseWithParams<void,MessageEntity>{

  const SendMessageUseCase({required this.chatRepo,});
  final ChatRepo chatRepo;

  @override
  ResultFuture<void> call(MessageEntity p) async{
    return chatRepo.sendMessage(p);
  }

}
