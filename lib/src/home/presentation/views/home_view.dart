import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/home/presentation/refactors/home_body.dart';
import 'package:education_app/src/home/presentation/widget/home_app_bar.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: HomeAppBar(),
      body: GradientBackground(image: MediaRes.homeGradientBackground,child:
        HomeBody(),),
    );
  }
}
