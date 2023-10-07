import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/course_tile.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickAccessCourseListView extends StatelessWidget {
  const QuickAccessCourseListView({
  required this.onTab
  ,super.key,});
  final void Function(Course) onTab;

  @override
  Widget build(BuildContext context) {
    context.read<CourseCubit>().getCourses();
    return BlocBuilder<CourseCubit,CourseState>(
      builder: (context,state){
        if(state is LoadingCourses){
          return const LoadingView();
        }else if(state is CoursesLoaded && state.courses.isEmpty){
          return const NotFoundText(
            text: 'No Courses Found',
          );
        }else if(state is CoursesLoaded){
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Wrap(
                  spacing: 10.w,
                  runSpacing: 20.h,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: state.courses.map<Widget>((course){
                    return CourseTile(
                      course: course,
                      onPressed: ()=>onTab(course),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }else{
          return const SizedBox.shrink();
        }
      },);
  }
}
