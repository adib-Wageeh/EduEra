import 'package:education_app/core/common/widgets/time_text.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:education_app/src/chat/presentation/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YourGroupTile extends StatelessWidget {
  const YourGroupTile({
  required this.group
  ,super.key,});
  final Group group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        context.pushTab(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_)=>sl<ChatCubit>(),
              ),
              BlocProvider.value(
                value: sl<GroupCubit>(),
              ),
            ],
            child: ChatView(group: group,),
          ),
        );
      },
      title: Text(group.name),
      subtitle: group.lastMessage != null
          ? RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: '~ ${group.lastMessageSenderName}: ',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12.sp,
          ),
          children: [
            TextSpan(
              text: '${group.lastMessage}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          : null,
      trailing: group.lastMessage != null
          ? TimeText(
        group.lastMessageTimeStamp!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )
          : null,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child:(group.groupImage!= null)? Image.network(group.groupImage!)
          : Image.asset(MediaRes.course),
        ),
      ),
    );
  }
}
