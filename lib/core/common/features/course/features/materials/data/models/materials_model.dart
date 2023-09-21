import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/features/course/features/materials/domain/entities/materials.dart';
import 'package:education_app/core/utils/typedefs.dart';

class ResourcesModel extends Resources{

   const ResourcesModel({required super.courseId, required super.id,
    required super.isFile, required super.fileExtension, required super.url,
    required super.uploadDate, super.author,super.description,super.title,});

  factory ResourcesModel.fromMap(DataMap map){

    return ResourcesModel(
      courseId: map['courseId'] as String,
      id:  map['id'] as String,
      isFile: map['isFile'] as bool,
      fileExtension: map['fileExtension'] as String,
      url: map['url'] as String,
      uploadDate: (map['uploadDate'] as Timestamp).toDate(),
      author: map['author'] as String,
      description: map['description'] as String,
      title: map['title'] as String,
    );
  }

  factory ResourcesModel.empty(){
    return ResourcesModel(courseId: 'empty_courseId',
      id: 'empty_id', isFile: true,
      fileExtension: 'empty_extension',
      url: 'empty_url',
      uploadDate: DateTime.now(),
      title: 'empty_title',
      description: 'empty_description',
      author: 'empty_author',
    );
  }

  DataMap toMap(){
    return{
      'courseId':courseId,
      'id':id,
      'isFile':isFile,
      'fileExtension':fileExtension,
      'url':url,
      'uploadDate':FieldValue.serverTimestamp(),
      'title':title,
      'description':description,
      'author':author,
    };
  }

   ResourcesModel copyWith({
     String? courseId,
     String? id,
     bool? isFile,
     String? fileExtension,
     String? url,
     DateTime? uploadDate,
     String? author,
     String? description,
     String? title,
   }) {
     return ResourcesModel(
       courseId: courseId ?? this.courseId,
       id: id ?? this.id,
       isFile: isFile ?? this.isFile,
       fileExtension: fileExtension ?? this.fileExtension,
       url: url ?? this.url,
       uploadDate: uploadDate ?? this.uploadDate,
       author: author ?? this.author,
       description: description ?? this.description,
       title: title ?? this.title,
     );
   }


}
