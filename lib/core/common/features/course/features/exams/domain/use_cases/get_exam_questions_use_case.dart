import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/entities/exam_question.dart';
import 'package:education_app/core/common/features/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetExamsQuestionsUseCase extends FutureUseCaseWithParams<List<ExamQuestion>
,Exam>{

  GetExamsQuestionsUseCase({required this.examRepository,});

  final ExamRepository examRepository;

  @override
  ResultFuture<List<ExamQuestion>> call(Exam p) async{
    return examRepository.getExamQuestions(p);
  }


}
