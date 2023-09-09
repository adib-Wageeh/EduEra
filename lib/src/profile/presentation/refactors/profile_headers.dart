import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context,user,_) {
        final image = user.user?.profilePic == null ||
        user.user!.profilePic!.isEmpty ? null : user.user!.profilePic;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: 
              image != null ? NetworkImage(image):
              const AssetImage(MediaRes.user) as ImageProvider,
            ),
            const SizedBox(height: 16,),
            Text(user.user?.fullName ?? 'No User',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
            ),
            if(user.user?.bio != null && user.user!.bio!.isNotEmpty)
              ...[
                const SizedBox(height: 8,),
                Padding(padding: EdgeInsets.symmetric(
                    horizontal: context.width*0.15,
                ),
                  child: Text(user.user!.bio!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colours.neutralTextColour,
                  ),
                  ),
                ),
                const SizedBox(height: 16,),

              ]
          ],
        );
      },
    );
  }
}
