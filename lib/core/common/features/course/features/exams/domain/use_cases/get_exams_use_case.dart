import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetExamsUseCase extends FutureUseCaseWithParams<List<Exam>,String>{

  GetExamsUseCase({required this.examRepository,});

  final ExamRepository examRepository;

  @override
  ResultFuture<List<Exam>> call(String p) async{
    return examRepository.getExams(p);
  }
  

}
