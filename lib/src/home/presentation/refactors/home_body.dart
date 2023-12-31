import 'package:education_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/home/presentation/providers/tinder_provider.dart';
import 'package:education_app/src/home/presentation/refactors/home_courses.dart';
import 'package:education_app/src/home/presentation/refactors/home_header.dart';
import 'package:education_app/src/home/presentation/refactors/home_videos.dart';
import 'package:education_app/src/home/presentation/refactors/shimmers/home_body_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  void getCourses(){
    context.read<CourseCubit>().getCourses();
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseCubit,CourseState>(
      builder: (context,state){
      if(state is LoadingCourses){
        return const HomeBodyShimmer();
      }else{
        if(state is CoursesLoaded && state.courses.isEmpty
        || state is CourseError){
          return const NotFoundText(
            text:
              'No courses found\nPlease contact admin '
                  'If you are admin please add courses.',
          );
        }else if(state is CoursesLoaded)
        {
          final courses = state.courses..sort(
                (a,b)=> b.updatedAt.compareTo(a.updatedAt),);
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ChangeNotifierProvider(
              create: (_)=> TinderProvider(List<Course>.from(courses)),
              child: const HomeHeader(),),
               SizedBox(
                height: 10.h,
              ),
              HomeCourses(courses: courses,),
               SizedBox(
                height: 20.h,
              ),
              const HomeVideos(),
            ],
          );
        }
        return const SizedBox.shrink();
      }

    },
        listener: (context,state){
        if(state is CourseError){
          CoreUtils.showSnackBar(context, state.message);
        }else if(state is CoursesLoaded && state.courses.isNotEmpty){
          final courses = state.courses..shuffle();
          final courseOfTheDay = courses.first;
          context.read<CourseOfTheDayNotifier>().setCourseOfTheDay
            (courseOfTheDay);
        }
    },);
  }
}
