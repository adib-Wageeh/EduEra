import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherGroupTile extends StatelessWidget {
  const OtherGroupTile(this.group, {super.key});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(group.name),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.network(group.groupImage!),
        ),
      ),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.primaryColour,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          context.read<GroupCubit>().joinGroup(groupId: group.id,);
        },
        child: const Text('Join'),
      ),
    );
  }
}
