import 'dart:async';
import 'package:education_app/core/common/widgets/PopUpMenuItem.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AppBarWidget extends StatelessWidget
    implements PreferredSizeWidget{
  const AppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Account',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        PopupMenuButton<void>(
          offset: const Offset(0, 50),
          icon: const Icon(Icons.more_horiz),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          itemBuilder: (_)=>[
             PopupMenuItem(
                child:const PopUpItem(
                  text: 'Edit Profile',
                  icon: Icons.edit_outlined,
                ),
              onTap: ()=>context.pushTab(const Placeholder()),
            ),
            PopupMenuItem(
              child:const PopUpItem(
                text: 'Notifications',
                icon: IconlyLight.notification,
              ),
              onTap: ()=>context.pushTab(const Placeholder()),
            ),
            PopupMenuItem(
              child:const PopUpItem(
                text: 'Help',
                icon: Icons.help_outline_outlined,
              ),
              onTap: ()=>context.pushTab(const Placeholder()),
            ),
            PopupMenuItem(
              height: 1,
                padding: EdgeInsets.zero,
                child: Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                  endIndent: 16,
                  indent: 16,
                ),),
            PopupMenuItem(
              child:const PopUpItem(
                text: 'Log Out',
                icon: Icons.logout_rounded,
                color: Colors.black,
              ),
              onTap: ()async{
                final navigator = Navigator.of(context);
                await sl<FirebaseAuth>().signOut();
                unawaited(navigator.pushNamedAndRemoveUntil
                  ( '/', (route) => false),);
              },
            ),
             ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

