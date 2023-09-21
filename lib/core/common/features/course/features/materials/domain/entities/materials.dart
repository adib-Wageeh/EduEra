import 'package:equatable/equatable.dart';

class Resources extends Equatable{

  const Resources({
    required this.courseId,
    required this.id,
    required this.fileExtension,
    required this.url,
    required this.uploadDate,
    this.isFile = false,
    this.title,
    this.description,
    this.author,
  });

  factory Resources.empty(){
    return Resources(courseId: 'empty_courseId',
        id: 'empty_id', isFile: true,
        fileExtension: 'empty_extension',
        url: 'empty_url',
        uploadDate: DateTime.now(),
      title: 'empty_title',
      description: 'empty_description',
      author: 'empty_author',
    );
  }

  final String? title;
  final String id;
  final String courseId;
  final bool isFile;
  final String url;
  final String fileExtension;
  final String? description;
  final String? author;
  final DateTime uploadDate;



  @override
  List<Object?> get props => [id,courseId];




}