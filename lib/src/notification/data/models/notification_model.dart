import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/notification.dart';
import 'package:education_app/core/extensions/enum_extensions.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/notification/domain/entities/notification_entitiy.dart';

class NotificationModel extends NotificationEntity{

  const NotificationModel({required super.category, required super.id,
    required super.title, required super.body,required super.sentAt,
    super.seen,});

  factory NotificationModel.empty(){
    return NotificationModel(
      id: '_empty.id',
        title: '_empty.title', body: '_empty.body',
      category: NotificationCategory.NONE
      , sentAt: DateTime.now(),
    );
  }

  factory NotificationModel.fromMap(DataMap json){
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      sentAt: (json['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      seen: json['seen'] as bool,
      category: (json['category'] as String).toNotificationCategory,
    );
  }

  DataMap toMap(){
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category.value,
      'seen': seen,
      'sentAt': FieldValue.serverTimestamp(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? sentAt,
    bool? seen,
    NotificationCategory? category,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      sentAt: sentAt ?? this.sentAt,
      seen: seen ?? this.seen,
      category: category ?? this.category,
    );
  }

}
