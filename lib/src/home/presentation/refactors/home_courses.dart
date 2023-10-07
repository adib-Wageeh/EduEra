import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/presentation/views/all_courses_view.dart';
import 'package:education_app/core/common/features/course/presentation/views/course_details_screen.dart';
import 'package:education_app/core/common/widgets/course_tile.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/home/presentation/widget/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCourses extends StatelessWidget {
  const HomeCourses({required this.courses, super.key});
  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          sectionTitle: 'Courses',
          seeAll: courses.length>4,
          onPressed: (){
            context.pushTab(AllCoursesView(courses: courses,));
          },
        ),
         Text('Explore our courses',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colours.neutralTextColour,
          fontSize: 14.sp,
        ),
        ),
         SizedBox(height: 20.h,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: courses.take(4).map((course){
            return CourseTile(course: course,onPressed: (){
              Navigator.of(context).pushNamed(CourseDetailsScreen.route
              ,arguments: course,);
            },);
          }).toList(),
        ),
      ],

    );
  }
}
