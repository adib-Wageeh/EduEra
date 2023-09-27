import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';

class MarkAsReadUseCase extends FutureUseCaseWithParams<void,String>{

  const MarkAsReadUseCase({required this.notificationRepo,});
  final NotificationRepo notificationRepo;

  @override
  ResultFuture<void> call(String p) async{
    return notificationRepo.markAsRead(p);
  }


}
