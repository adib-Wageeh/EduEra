import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';


class AddNotificationUseCase extends FutureUseCaseWithParams<void,NotificationEntity>{

  const AddNotificationUseCase({required this.notificationRepo,});
  final NotificationRepo notificationRepo;

  @override
  ResultFuture<void> call(NotificationEntity p) async{
    return notificationRepo.addNotification(p);
  }


}