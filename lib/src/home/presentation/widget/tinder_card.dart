import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/src/home/providers/tinder_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class TinderCard extends StatelessWidget {
  const TinderCard({
  required this.course,
  required this.index
  ,super.key,});
  final Course course;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cardColor = Provider.of<TinderProvider>(context,listen: false)
    .colorsList[
      Provider.of<TinderProvider>(context,listen: false).currentIndex+index];
    return Container(
      alignment: Alignment.bottomCenter,
      height: 137,
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardColor.gradiantTopColor,
            cardColor.gradiantBottomColor
          ],
        ),
        color: cardColor.backGroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            course.title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const Row(
            children: [
              Icon(IconlyLight.notification, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '45 minutes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
