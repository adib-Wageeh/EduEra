import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/course_exams_view.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/user_exam_result_view.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/course_tile.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/src/quick_access/presentation/app/providers/quick_access_controller.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_appbar.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_changer_item.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_exam_tile.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class QuickAccessView extends StatefulWidget {
  const QuickAccessView({super.key});

  @override
  State<QuickAccessView> createState() => _QuickAccessViewState();
}

class _QuickAccessViewState extends State<QuickAccessView> {

  void getCourses(){
    context.read<CourseCubit>().getCourses();
  }

  void getExams(){
    context.read<ExamCubit>().getUserExams();
  }

  @override
  void initState() {
    super.initState();
    getCourses();
    getExams();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuickAccessController>(
      builder: (_,controller,__){
        return Scaffold(
            appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight)
        ,child: QuickAccessAppBar(),),

          backgroundColor: Colors.white,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuickAccessHeader(image: controller.currentImage,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   QuickAccessChangerItem(
                     isSelected: controller.currentIndex == 0,
                     text: 'Document',
                     onPressed: (){
                       controller.changeIndex(0);
                     },
                   ),
                   const SizedBox(width: 10,),
                   QuickAccessChangerItem(
                     isSelected: controller.currentIndex == 1,
                     text: 'Exam',
                     onPressed: (){
                       controller.changeIndex(1);
                     },
                   ),
                   const SizedBox(width: 10,),
                   QuickAccessChangerItem(
                     isSelected: controller.currentIndex == 2,
                     text: 'Passed',
                     onPressed: (){
                       controller.changeIndex(2);
                     },
                   ),

                 ],
              ),
              const SizedBox(height: 20,),
              if (controller.currentIndex != 2)
                BlocBuilder<CourseCubit,CourseState>(
              builder: (context,state){
                if(state is LoadingCourses){
                  return const LoadingView();
                }else if(state is CoursesLoaded && state.courses.isEmpty){
                  return const NotFoundText(
                    text: 'No Courses Found',
                  );
                }else if(state is CoursesLoaded){
                  return Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    runAlignment: WrapAlignment.spaceEvenly,
                    children: state.courses.map<Widget>((course){
                      return CourseTile(
                        course: course,
                        onPressed: (){
                          if(controller.currentIndex==0){
                            Navigator.pushNamed(context
                                ,CourseMaterialsView.route,
                            arguments: course,
                            );
                          }else{
                            Navigator.pushNamed(context
                              ,CourseExamsView.route,
                              arguments: course,
                            );
                          }
                        },
                      );
                    }).toList(),
                  );
                }else{
                  return const SizedBox.shrink();
                }
              },)
              else
                BlocBuilder<ExamCubit,ExamState>
                  (builder: (context,state){
                  if(state is GettingUserExams){
                    return const LoadingView();
                  }else if(state is UserExamsLoaded && state.exams.isEmpty){
                    return const NotFoundText(
                      text: 'No Exams Found',
                    );
                  }else if(state is UserExamsLoaded){
                    return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.exams.length,
                    itemBuilder: (context,index){
                    final userExam = UserExam.empty();
                    return QuickAccessExamTile(
                    onTab: (){
                      Navigator.pushNamed(context,
                        UserExamResultView.route,
                      arguments: state.exams[index],
                      );
                    }
                    ,exam: userExam,);
                    },);
                  }else{
                    return const SizedBox.shrink();
                  }
                },)
            ],
          ),
        );

      },
    );
  }
}
