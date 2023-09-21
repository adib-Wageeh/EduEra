import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class SubmitExamsUseCase extends UseCaseWithParams<void,UserExam>{

  SubmitExamsUseCase({required this.examRepository,});

  final ExamRepository examRepository;

  @override
  ResultFuture<void> call(UserExam p) async{
    return examRepository.submitExam(p);
  }


}
