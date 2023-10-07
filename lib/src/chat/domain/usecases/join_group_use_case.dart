import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class JoinGroupUseCase extends FutureUseCaseWithParams<void,String>{

  const JoinGroupUseCase({required this.chatRepo,});
  final ChatRepo chatRepo;
  @override
  ResultFuture<void> call(String p){
    return chatRepo.joinGroup(p);
  }


}
