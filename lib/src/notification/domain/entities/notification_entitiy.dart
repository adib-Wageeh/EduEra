import 'package:education_app/core/enums/notification.dart';
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable{

  const NotificationEntity({
    required this.category,
    required this.id,
    required this.title,
    required this.body,
    required this.sentAt,
    this.seen = false,
});

  factory NotificationEntity.empty(){
    return NotificationEntity(
      id: '_empty.id',
      title: '_empty.title', body: '_empty.body',
      category: NotificationCategory.NONE
      , sentAt: DateTime.now(),
    );
  }

  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final bool? seen;
  final DateTime sentAt;

  @override
  List<Object?> get props => [id];

}
