import 'package:education_app/core/common/widgets/time_text.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeTile extends StatelessWidget {
  const TimeTile(this.time, {super.key, this.prefixText});

  final DateTime time;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colours.primaryColour,
        borderRadius: BorderRadius.circular(90),
      ),
      child: TimeText(
        time,
        prefixText: prefixText,
        style:  TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
