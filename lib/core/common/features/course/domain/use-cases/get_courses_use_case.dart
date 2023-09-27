import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetCoursesUseCase extends FutureUseCaseWithoutParams<List<Course>>{

  const GetCoursesUseCase({required this.courseRepository});
  final CourseRepository courseRepository;

  @override
  ResultFuture<List<Course>> call(){
    return courseRepository.getCourses();
  }



}
