import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/utils/typedefs.dart';

class CourseModel extends Course{
  const CourseModel({required super.id, required super.title,
    required super.createdAt, required super.groupId,
    required super.numberOfExams, required super.updatedAt,
    required super.numberOfVideos, required super.numberOfMaterials,
  super.description,super.image,super.imageAsFile,
  });

  factory CourseModel.empty(){
    return CourseModel(id: '', title: '',
        description: ''
        , createdAt: DateTime.now(),
      groupId: '', numberOfExams: 0, updatedAt: DateTime.now(),
      numberOfVideos: 0, numberOfMaterials: 0,);
  }

  factory CourseModel.fromMap(DataMap json){
    return CourseModel(id: json['id'] as String, title: json['title'] as String,
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        groupId: json['groupId'] as String,
        numberOfExams: (json['numberOfExams'] as num).toInt(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate(),
        numberOfVideos: (json['numberOfVideos'] as num).toInt(),
        numberOfMaterials: (json['numberOfMaterials'] as num).toInt(),);
  }

  DataMap toMap(){
    return {
      'id':id,
      'title':title,
      'description':description,
      'numberOfExams':numberOfExams,
      'numberOfMaterials':numberOfMaterials,
      'numberOfVideos':numberOfVideos,
      'groupId':groupId,
      'image':image,
      'createdAt':FieldValue.serverTimestamp(),
      'updatedAt':FieldValue.serverTimestamp(),
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    int? numberOfExams,
    int? numberOfMaterials,
    int? numberOfVideos,
    String? groupId,
    String? image,
    bool? imageAsFile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      numberOfExams: numberOfExams ?? this.numberOfExams,
      numberOfMaterials: numberOfMaterials ?? this.numberOfMaterials,
      numberOfVideos: numberOfVideos ?? this.numberOfVideos,
      groupId: groupId ?? this.groupId,
      image: image ?? this.image,
      imageAsFile: imageAsFile ?? this.imageAsFile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }


}
