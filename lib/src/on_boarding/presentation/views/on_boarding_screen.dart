import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:education_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:education_app/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  static const route = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  final PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white
    ,body: GradientBackground(
      image: MediaRes.onBoardingBackground
      ,child: BlocConsumer<OnBoardingCubit,OnBoardingState>(
        builder: (context,state){
          if(state is CheckingIfUserFirstTime || state is CachingFirstTime){
            return const LoadingView();
          }
          return Stack(
            children: [
              PageView(
                controller: pageController,
                children: [
                  OnBoardingBody(pageContent: PageContent.first(),
                      pageController: pageController,),
                  OnBoardingBody(pageContent: PageContent.second(),
                  pageController: pageController,),
                  OnBoardingBody(pageContent: PageContent.third(),
                  pageController: pageController,),
                ],
              ),
              Align(
                alignment: Alignment(0, 0.10.h),
                child: SmoothPageIndicator(
                controller: pageController
                ,count: 3,
                onDotClicked: (index){
                  pageController.animateToPage(
                      index,
                  duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                  effect: WormEffect(
                    dotHeight: 10.h,
                    dotWidth: 10.w,
                    spacing: 40,
                    activeDotColor: Colours.primaryColour,
                    dotColor: Colors.white,
                  ),
                ),
              ),
            ],
          );

        }, listener: (context,state){
          if(state is OnBoardingStatus && !state.isFirstTime)
          {
            Navigator.pushReplacementNamed(context, DashboardScreen.route);
          }else if(state is UserCached){
            Navigator.pushReplacementNamed(context, '/default');

          }
        },),
      ),
    );
  }
}
