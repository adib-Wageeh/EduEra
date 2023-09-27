import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';
import 'package:education_app/src/notification/domain/repos/notification_repo.dart';

class GetNotificationsUseCase extends
StreamUseCaseWithoutParams<List<NotificationEntity>>{

  const GetNotificationsUseCase({required this.notificationRepo,});
  final NotificationRepo notificationRepo;

  @override
  ResultStream<List<NotificationEntity>> call(){
    return notificationRepo.getNotifications();
  }


}
