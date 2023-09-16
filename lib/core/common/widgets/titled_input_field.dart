import 'package:education_app/core/common/widgets/i_field.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:flutter/material.dart';

class TitledInputField extends StatelessWidget {
  const TitledInputField({
  required this.controller,
  required this.title,
  this.required = true,
  this.hintText,
  this.hintStyle,
  this.suffixIcon
  ,super.key,});

  final String title;
  final bool required;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colours.neutralTextColour,
                  ),
                  children: !required ? null :
                      [
                         const TextSpan(
                           text: ' *',
                           style: TextStyle(
                             color: Colours.redColour,

                           ),
                         )
                      ],
                ),),
            if(suffixIcon != null) suffixIcon!,

          ],
        ),
        const SizedBox(
          height: 10,
        ),
        IField(controller: controller,
        hintText: hintText ?? 'Enter $title',
        hintStyle: hintStyle,
        overrideValidator: true,
        validator: (text){
          if(!required) return null;
          if (text == null || text.isEmpty) {
            return 'This field is required';
          }
          return null;
        },

        )
      ],
    );
  }
}
