import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/features/course/domain/use-cases/add_course_use_case.dart';
import 'package:education_app/core/common/features/course/domain/use-cases/get_courses_use_case.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class AddCourseUseCaseMock extends Mock implements AddCourseUseCase{}

class GetCoursesUseCaseMock extends Mock implements GetCoursesUseCase{}

void main() {

  late GetCoursesUseCase getCoursesUseCase;
  late AddCourseUseCase addCourseUseCase;
  late CourseCubit courseCubit;
  final tCourse = CourseModel.empty();
  const tServerFailure =ServerFailure(error: 'unknown exception', code: '404');

setUp(() {

  getCoursesUseCase = GetCoursesUseCaseMock();
  addCourseUseCase = AddCourseUseCaseMock();
  courseCubit = CourseCubit(addCourseUseCase: addCourseUseCase,
      getCoursesUseCase: getCoursesUseCase,);
  registerFallbackValue(tCourse);
});

tearDown(() {
  courseCubit.close();
});

test('initial state should be CourseInitial', () {
  expect(courseCubit.state, const CourseInitial());
});

group('add course', () {

  blocTest<CourseCubit,CourseState>(
    'emits [AddingCourse, CourseAdded] when addCourse is called',
    build: (){
      when(()=>
      addCourseUseCase.call(any()),
      ).thenAnswer((_) async=> const Right(null));
      return courseCubit;
    },
   act: (cubit)=> cubit.addCourse(tCourse),
   expect: ()=> <CourseState>[
     const AddingCourse(),
     const CourseAdded()
   ],
    verify: (_){
      verify(()=>addCourseUseCase.call(tCourse)).called(1);
      verifyNoMoreInteractions(addCourseUseCase);
    },

  );

  blocTest<CourseCubit,CourseState>(
    'emits [AddingCourse, CourseError] when addCourse is called',
    build: (){
      when(()=>
          addCourseUseCase.call(any()),
      ).thenAnswer((_) async=> const Left(tServerFailure));
      return courseCubit;
    },
    act: (cubit)=> cubit.addCourse(tCourse),
    expect: ()=> <CourseState>[
      const AddingCourse(),
      CourseError(tServerFailure.error)
    ],
    verify: (_){
      verify(()=>addCourseUseCase.call(tCourse)).called(1);
      verifyNoMoreInteractions(addCourseUseCase);
    },

  );

});

group('getting courses', () {

  blocTest<CourseCubit,CourseState>(
    'emits [LoadingCourses, CoursesLoaded] when getCourse is called',
    build: (){
      when(()=> getCoursesUseCase.call())
          .thenAnswer((_) async=> const Right([]));
      return courseCubit;
    },
    act: (cubit)=> cubit.getCourses(),
    expect: ()=> <CourseState>[
      const LoadingCourses(),
      const CoursesLoaded([]),
    ],
  );

  blocTest<CourseCubit,CourseState>(
    'emits [LoadingCourses, CourseError] when getCourse is called',
    build: (){
      when(()=> getCoursesUseCase.call())
          .thenAnswer((_) async=> const Left(tServerFailure));
      return courseCubit;
    },
    act: (cubit)=> cubit.getCourses(),
    expect: ()=> <CourseState>[
      const LoadingCourses(),
      CourseError(tServerFailure.error),
    ],
  );

});


}
