import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/home/presentation/refactors/home_body.dart';
import 'package:education_app/src/home/presentation/widget/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: GradientBackground(image: MediaRes.homeGradientBackground,child:
        RefreshIndicator(
        onRefresh: ()async{
          await context.read<CourseCubit>().getCourses();
        }
        ,child: const HomeBody(),),),
    );
  }
}
