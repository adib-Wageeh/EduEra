import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class ExamDetailsRow extends StatelessWidget {
  const ExamDetailsRow({
  required this.title,
  required this.subTitle,
  required this.icon
  ,super.key,});
  final String title;
  final String subTitle;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        SizedBox(
          height: 48,
          width: 48,
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Transform.scale(scale: 1.48, child: Image.asset(icon)),
          ),
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black,
            ),
            ),
            Text(subTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colours.neutralTextColour,
              ),
            ),
          ],
        ),

      ],
    );
  }
}
