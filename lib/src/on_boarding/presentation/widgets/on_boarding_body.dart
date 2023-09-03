import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});
  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(pageContent.image,
          height: context.height*0.4,),
        SizedBox(height: context.height*0.09,),
        Padding(padding: const EdgeInsets.all(20).copyWith(bottom: 0),
        child: Column(
          children: [
            Text(pageContent.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: Fonts.aeonik,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.height*0.02,),
            Text(pageContent.subTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: context.height *0.05,
            ),
            if (pageContent.title == 'Easy to join the lesson') ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50,
                  vertical: 17,
                ),
                backgroundColor: Colours.primaryColour,
                foregroundColor: Colors.white,
              )
              ,onPressed: (){
              context.read<OnBoardingCubit>().cacheFirstTime();

            }, child: const Text('Get Started',
              style: TextStyle(
                fontFamily: Fonts.aeonik,
                fontWeight: FontWeight.bold,
              ),
            ),) else const SizedBox()
          ],
        )
          ,
        ),
      ],
    );
  }
}