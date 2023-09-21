import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetUserCourseExamUseCase extends UseCaseWithParams<List<UserExam>,String>{

  GetUserCourseExamUseCase({required this.examRepository,});

  final ExamRepository examRepository;

  @override
  ResultFuture<List<UserExam>> call(String p) async{
    return examRepository.getUserCourseExams(p);
  }


}
