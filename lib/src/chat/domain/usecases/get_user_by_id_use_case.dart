import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/chat/domain/repos/chat_repo.dart';

class GetUserByIdUseCase extends FutureUseCaseWithParams<UserModel,String>{

  const GetUserByIdUseCase({required this.chatRepo,});
  final ChatRepo chatRepo;

  @override
  ResultFuture<UserModel> call(String p){
    return chatRepo.getUserById(p);
  }


}
