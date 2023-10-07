import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/views/course_exams_view.dart';
import 'package:education_app/core/common/features/course/features/materials/presentation/views/course_materials_view.dart';
import 'package:education_app/src/quick_access/presentation/app/providers/quick_access_controller.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_appbar.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_changer_item.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_course_list_view.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_exam_list_view.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class QuickAccessView extends StatefulWidget {
  const QuickAccessView({super.key});

  @override
  State<QuickAccessView> createState() => _QuickAccessViewState();
}

class _QuickAccessViewState extends State<QuickAccessView> {

  @override
  void initState() {
    super.initState();
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
                    SizedBox(width: 10.w,),
                   QuickAccessChangerItem(
                     isSelected: controller.currentIndex == 1,
                     text: 'Exam',
                     onPressed: (){
                       controller.changeIndex(1);
                     },
                   ),
                    SizedBox(width: 10.w,),
                   QuickAccessChangerItem(
                     isSelected: controller.currentIndex == 2,
                     text: 'Passed',
                     onPressed: (){
                       controller.changeIndex(2);
                     },
                   ),

                 ],
              ),
              SizedBox(height: 20.h,),
              if (controller.currentIndex != 2)
                QuickAccessCourseListView(onTab: (Course course){
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
                },)
              else
                const QuickAccessExamListView(),
            ],
          ),
        );
      },
    );
  }
}
