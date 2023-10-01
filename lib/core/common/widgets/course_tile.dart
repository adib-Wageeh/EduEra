import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  const CourseTile({
    required this.onPressed,
    required this.course,super.key});
  final Course course;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: onPressed,
    behavior: HitTestBehavior.opaque,
    child: SizedBox(
        width: 54,
        child: Column(
          children: [
            SizedBox(
              width: 54,
              height: 54,
              child: CoreUtils.imageType(course.image!),
            ),
            const SizedBox(height: 5,),
            Text(
              course.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
