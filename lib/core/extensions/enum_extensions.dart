import 'package:education_app/core/enums/notification.dart';

extension NotificationExt on String{

NotificationCategory get toNotificationCategory{

    switch(this){
      case 'test':
        return NotificationCategory.TEST;
      case 'video':
        return NotificationCategory.VIDEO;
      case 'material':
        return NotificationCategory.MATERIAL;
      case 'course':
        return NotificationCategory.COURSE;
      default:
        return NotificationCategory.NONE;
    }

}

}