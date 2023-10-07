import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, required this.pageController,
    super.key,});
  final PageContent pageContent;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(pageContent.image,
          height: size.height*0.4,),
        SizedBox(height: size.height*0.09,),
        Padding(padding: const EdgeInsets.all(20).copyWith(bottom: 0),
        child: Column(
          children: [
            Text(pageContent.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.aeonik,
                fontSize: 40.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: size.height*0.02,),
            Text(pageContent.subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
            SizedBox(
              height: size.height *0.05,
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

            }, child: Text('Get Started',
              style: TextStyle(
                fontFamily: Fonts.aeonik,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),) else
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 60.w,
                  width: 60.w,
                  decoration: const BoxDecoration(
                     shape: BoxShape.circle,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.primaryColour,
                      foregroundColor: Colors.white,
                    )
                    ,onPressed: (){
                    pageController.animateToPage(
                      pageContent.index+1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }, child: Center(
                    child: Icon(
                        FontAwesomeIcons.chevronRight,
                      size: 24.sp,
                    ),
                  ),),
                ),
              ),
          ],
        )
          ,
        ),
      ],
    );
  }
}
