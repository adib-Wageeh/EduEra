import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/utils/typedefs.dart';

abstract class CourseRepository{

  const CourseRepository();

  ResultFuture<List<Course>> getCourses();
  ResultFuture<void> addCourse(Course course);
  
}
