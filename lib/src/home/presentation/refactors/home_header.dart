import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/src/home/presentation/widget/tinder_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Text('Hello,\n${context.read<UserProvider>().user!.fullName}',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
          ),
          Positioned(
            top: context.height >= 926 ? -25 : context.height >= 844 ? -6 :
            context.height <=
                800 ? 10 : 10,
          right:  -14,
          child: const TinderContainer(),)
        ],
      ),
    );
  }
}
