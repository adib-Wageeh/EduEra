import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({
    required this.onPressed,
    required this.course,super.key});
  final Course course;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
    onTap: onPressed,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
          width: size.width*0.20,
          child: Column(
            children: [
              SizedBox(
                width: size.width*0.20,
                height: size.width*0.20,
                child: CoreUtils.imageType(course.image!),
              ),
               SizedBox(height: 5.h,),
              Text(
                course.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
    ),
    );
  }
}
