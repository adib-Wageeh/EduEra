import 'package:education_app/core/common/widgets/PopUpMenuItem.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({required this.group, super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const NestedBackButton(),
      titleSpacing: 0,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(group.groupImage!),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 7),
          Text(group.name),
        ],
      ),
      foregroundColor: Colors.white,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
        ),
      ),
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.more_horiz),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (_) =>
          [
            PopupMenuItem<void>(
              child: const PopUpItem(
                text: 'Exit Group',
                icon: Icons.exit_to_app,
                color: Colours.redColour,
              ),
              onTap: () async {
                final groupCubit = BlocProvider.of<GroupCubit>(context);
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      title: const Text('Exit Group'),
                      content: const Text(
                        'Are you sure you want to leave the group?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text('Exit group'),
                        ),
                      ],
                    );
                  },
                );
                if (result ?? false) {
                  await groupCubit.leaveGroup(groupId: group.id,);
                }
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
