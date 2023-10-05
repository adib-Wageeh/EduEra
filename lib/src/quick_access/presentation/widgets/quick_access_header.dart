import 'package:flutter/material.dart';

class QuickAccessHeader extends StatelessWidget {
  const QuickAccessHeader({
  required this.image
  ,super.key,});
  final String image;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: MediaQuery.of(context).size.height*0.4,
      child: Center(
        child: Padding(
        padding: const EdgeInsets.all(32),
        child: Image.asset(image,),),
      ),
    );
  }
}
