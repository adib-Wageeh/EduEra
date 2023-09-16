import 'package:bloc/bloc.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/domain/use-cases/add_course_use_case.dart';
import 'package:education_app/core/common/features/course/domain/use-cases/get_courses_use_case.dart';

import 'package:equatable/equatable.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit({
    required AddCourseUseCase addCourseUseCase,
    required GetCoursesUseCase getCoursesUseCase,
}) : _addCourseUseCase = addCourseUseCase,
  _getCoursesUseCase = getCoursesUseCase,
        super(const CourseInitial());

  final AddCourseUseCase _addCourseUseCase;
  final GetCoursesUseCase _getCoursesUseCase;

  Future<void> addCourse(Course course)async{

    emit(const AddingCourse());
    final result = await _addCourseUseCase.call(course);

    result.fold((l){
      emit(CourseError(l.error));
    }, (r){
      emit(const CourseAdded());
    });

  }

  Future<void> getCourses()async{

    emit(const LoadingCourses());

    final result = await _getCoursesUseCase.call();

    result.fold((l) {
      emit(CourseError(l.error));
    }, (r) {
      emit(CoursesLoaded(r));
    });

  }

}
