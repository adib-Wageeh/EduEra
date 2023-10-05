import 'package:flutter/material.dart';

class QuickAccessChangerItem extends StatelessWidget {
  const QuickAccessChangerItem({
  required this.isSelected,
  required this.onPressed,
  required this.text,
  super.key,});
  final bool isSelected;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected?Colors.grey.shade300:
              Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: Text(text,
          style: TextStyle(
            fontWeight: isSelected? FontWeight.w500:FontWeight.w400,
            color: isSelected? Colors.black:
            Colors.grey.shade400,
          ),
          ),
        ),
      ),
    );
  }
}
