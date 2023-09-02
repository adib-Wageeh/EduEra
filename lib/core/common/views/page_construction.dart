import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';

import '../../res/media_res.dart';

class PageUnderConstructionScreen extends StatelessWidget {
  const PageUnderConstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(
            MediaRes.onBoardingBackground,),)
        ,),
        child: SafeArea(
           child: Center(child: Lottie.asset(MediaRes.pageUnderConstruction)),
        ),
      ),
    );
  }
}
