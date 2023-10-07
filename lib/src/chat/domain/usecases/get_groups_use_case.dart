import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class GetGroupsUseCase extends StreamUseCaseWithoutParams<List<Group>>{

  const GetGroupsUseCase({required this.chatRepo,});
  final ChatRepo chatRepo;
  @override
  ResultStream<List<Group>> call(){
    return chatRepo.getGroups();
  }


}
