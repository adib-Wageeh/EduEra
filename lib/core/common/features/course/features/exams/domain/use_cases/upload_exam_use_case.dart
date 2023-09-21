import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class UploadExamsUseCase extends UseCaseWithParams<void,Exam>{

  UploadExamsUseCase({required this.examRepository,});

  final ExamRepository examRepository;

  @override
  ResultFuture<void> call(Exam p) async{
    return examRepository.uploadExam(p);
  }


}
