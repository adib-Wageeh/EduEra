import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetUserExamsUseCase extends FutureUseCaseWithoutParams<List<UserExam>>{

  GetUserExamsUseCase({required this.examRepository,});

  final ExamRepository examRepository;

  @override
  ResultFuture<List<UserExam>> call() async{
    return examRepository.getUserExams();
  }


}
