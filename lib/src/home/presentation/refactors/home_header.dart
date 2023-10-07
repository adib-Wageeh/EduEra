import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/src/home/presentation/widget/tinder_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255.h,
      child: Stack(
        children: [
            Text('Hello,\n${context.read<UserProvider>().user!.fullName}',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w600,
            ),
              maxLines: 2,
            ),
             Positioned(
             top: context.height >= 926 ? -25.h : context.height >= 844 ? -6.h :
            context.height <=
            800 ? 10.h : 10.h
            ,right: -14.w
          ,child: const TinderContainer(),),
        ],
      ),
    );
  }
}
