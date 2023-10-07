import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
  required this.sectionTitle,
  required this.onPressed,
  required this.seeAll,
  super.key,});
  final String sectionTitle;
  final bool seeAll;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            sectionTitle,
          style:  TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        if(seeAll)
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              splashFactory: NoSplash.splashFactory,
            ),
              onPressed: onPressed,
              child: Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colours.primaryColour,
                  fontSize: 16.sp,
                ),
              ),
          ),
      ],
    );
  }
}
