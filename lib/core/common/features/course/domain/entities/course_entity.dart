import 'package:equatable/equatable.dart';

class Course extends Equatable{

  const Course({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.groupId,
    required this.numberOfExams,
    required this.updatedAt,
    required this.numberOfVideos,
    required this.numberOfMaterials,
    this.image,
    this.description,
    this.imageAsFile =false,
});

  factory Course.empty(){
    return Course(id: '', title: '', createdAt: DateTime.now(), groupId: '',
        numberOfExams: 0, updatedAt: DateTime.now(), numberOfVideos: 0,
        numberOfMaterials: 0, description: '',
    );
  }

  final String id;
  final String title;
  final String? description;
  final int numberOfExams;
  final int numberOfMaterials;
  final int numberOfVideos;
  final String groupId;
  final String? image;
  final bool imageAsFile;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id];


}
