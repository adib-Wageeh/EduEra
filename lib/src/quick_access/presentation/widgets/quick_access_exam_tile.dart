import 'package:education_app/core/common/features/course/features/exams/domain/entities/user_exam.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class QuickAccessExamTile extends StatelessWidget {
  const QuickAccessExamTile({
  required this.exam,
  required this.onTab
  ,super.key,});
  final UserExam exam;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    final totalCorrectAnswers =
    exam.examAnswers.where
      ((answer) => answer.userChoice == answer.correctChoice).length;
    return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTab
    ,child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.09,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colours.literatureTileColour,
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(MediaRes.test),
                ),
              ),
              const SizedBox(width: 12,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exam.examTitle,
                    style: const TextStyle(color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    ),),
                  const SizedBox(height: 4,),
                  const Text('You have completed',
                    style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    fontSize: 12,
                    ),),
                  RichText(text:
                  TextSpan(
                    text: '$totalCorrectAnswers/${exam.totalQuestions}',
                    style: TextStyle(color:
                    (totalCorrectAnswers*2 >= exam.totalQuestions)?
                      Colors.green:Colours.redColour,
                    ),
                    children: const [
                      TextSpan(text: ' questions',
                      style: TextStyle(color: Colors.black),
                      ),
                    ]
                  ,),),
                ],
              ),
              const Spacer(),
              CircularStepProgressIndicator(
                totalSteps: exam.totalQuestions,
                currentStep: totalCorrectAnswers,
                stepSize: 10,
                width: MediaQuery.of(context).size.height*0.09,
                height: MediaQuery.of(context).size.height*0.09,
                selectedColor:(totalCorrectAnswers*2 >= exam.totalQuestions)?
                Colors.green:Colours.redColour,
                unselectedColor: Colors.grey[200],
                padding: 0,
                selectedStepSize: 15,
                roundedCap: (_, __) => true,
                child: Center(
                  child: Text(
                    ((totalCorrectAnswers/exam.totalQuestions)*100)
                        .toInt().toString(),
                  style: TextStyle(color:
                  (totalCorrectAnswers*2 >= exam.totalQuestions)?
                  Colors.green:Colours.redColour,
                  fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
