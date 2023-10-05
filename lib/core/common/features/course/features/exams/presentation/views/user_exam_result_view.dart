import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/quick_access/presentation/widgets/quick_access_exam_tile.dart';
import 'package:flutter/material.dart';
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                text: 'Date Submitted: ',
                style: const TextStyle(color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                ),
                children: [
                  TextSpan(text: formattedDate,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                  )
                ]
              ,),),
            ),
            const SizedBox(height: 20),
            ...exam.examAnswers.where((answer) =>
            answer.userChoice != answer.correctChoice,).map((answer){
              final questionNumber = exam.examAnswers.indexOf(answer) + 1;
              return ExpansionTile(
                  title: Text('Question $questionNumber',
                  style: const TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w600,
                  ),
                  ),
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Wrong',style: TextStyle(
                      color: Colours.redColour,
                        fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Your Answer: ${answer.userChoice}',style:
                    const TextStyle(
                      color: Colours.redColour,
                        fontSize: 18,
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
