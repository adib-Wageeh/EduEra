import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_exam_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UserExamResultView extends StatelessWidget {
  const UserExamResultView({
  required this.exam
  ,super.key,});
  static const route = 'user-exam-result';
  final UserExam exam;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(exam.dateSubmitted);
    return Scaffold(
      appBar: AppBar(
        leading: const NestedBackButton(),
        title: Text(exam.examTitle),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             QuickAccessExamTile(
               onTab: (){}
            ,exam: exam,),
             SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                text: 'Date Submitted: ',
                style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                ),
                children: [
                  TextSpan(text: formattedDate,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ]
              ,),),
            ),
             SizedBox(height: 20.h),
            ...exam.examAnswers.where((answer) =>
            answer.userChoice != answer.correctChoice,).map((answer){
              final questionNumber = exam.examAnswers.indexOf(answer) + 1;
              return ExpansionTile(
                  title: Text('Question $questionNumber',
                  style: TextStyle(fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  ),
                  ),
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Wrong',style: TextStyle(
                      color: Colours.redColour,
                        fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Your Answer: ${answer.userChoice}',style:
                     TextStyle(
                      color: Colours.redColour,
                        fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                ],
              );
            }),

          ],
        ),
      ),
    );
  }
}
