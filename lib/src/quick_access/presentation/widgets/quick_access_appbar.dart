import 'package:cached_network_image/cached_network_image.dart';
import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickAccessAppBar extends StatelessWidget {
  const QuickAccessAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Materials'),
      actions: [
        Consumer<UserProvider>(builder: (_,controller,__){
          final user = controller.user!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              radius: 30,
              backgroundImage:
              user.profilePic != null ? CachedNetworkImageProvider
                (user.profilePic!):
              Image.asset(MediaRes.user,).image,
            ),
          );
        },),
      ],
    );
  }
}
