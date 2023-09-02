
import 'package:education_app/core/common/views/page_construction.dart';
import 'package:education_app/src/on_boarding/presentation/on_boarding_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateFunction(RouteSettings routeSettings){

  switch(routeSettings.name){

    // case OnBoardingScreen.route:
    //   return _pageBuilder((_)=>const OnBoardingScreen(),
    //   settings: routeSettings,
    //   );

    default:
      return _pageBuilder((_) => const PageUnderConstructionScreen(),
          settings: routeSettings,);

  }

}

PageRouteBuilder<dynamic> _pageBuilder(Widget Function(BuildContext) page,
    {required RouteSettings settings,}){
return PageRouteBuilder(
settings: settings,
transitionsBuilder: (_,animation,__,child)=> FadeTransition(opacity: animation,
    child: child,)
,pageBuilder: (context,_,__)=> page(context),);
}
