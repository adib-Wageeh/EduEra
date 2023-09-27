import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';

class ClearAllUseCase extends FutureUseCaseWithoutParams<void>{

  const ClearAllUseCase({required this.notificationRepo,});
  final NotificationRepo notificationRepo;

  @override
  ResultFuture<void> call() async{
    return notificationRepo.clearAll();
  }


}
