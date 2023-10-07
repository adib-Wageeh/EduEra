import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class GetMessagesUseCase extends StreamUseCaseWithParams
    <List<MessageEntity>,String>{

  const GetMessagesUseCase({required this.chatRepo,});
  final ChatRepo chatRepo;
  @override
  ResultStream<List<MessageEntity>> call(String p){
    return chatRepo.getMessages(p);
  }


}
