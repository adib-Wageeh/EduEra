import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class PopUpItem extends StatelessWidget {
  const PopUpItem({
    required this.text,
    required this.icon,
    this.color
    , super.key,
  });

  final String text;
  final IconData icon;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color??Colours.neutralTextColour,
              ),
            ),
            Icon(icon,

            ),
          ],
    );
  }
}
