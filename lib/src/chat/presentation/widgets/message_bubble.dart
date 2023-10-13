import 'package:cached_network_image/cached_network_image.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble(this.message, {required this.showSenderInfo
    ,required this.isLast, super.key});

  final MessageEntity message;
  final bool showSenderInfo;
  final bool isLast;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {

  UserEntity? user;
  late bool isCurrentUser;

  void updateCurrentUser(){
    if (widget.message.senderId == context.currentUser!.uiD) {
      user = context.currentUser;
      isCurrentUser = true;
    } else {
      isCurrentUser = false;
      context.read<ChatCubit>().getUser(widget.message.senderId);
    }
  }


  @override
  void initState() {
    updateCurrentUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (_, state) {
        if (state is UserFound && user == null) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: Container(
        constraints: BoxConstraints(maxWidth:
        MediaQuery.of(context).size.width - 150,),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (widget.showSenderInfo && !isCurrentUser)
              Row(
                children: [
                  if(user == null)
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: const CircleAvatar(
                    radius: 16,
                  ),)
                  else CircleAvatar(
                    radius: 16,
                    backgroundImage: CachedNetworkImageProvider(
                          (user!.profilePic == null)
                          ? kDefaultAvatar
                          : user!.profilePic!,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if(user == null)
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 100,
                      height: 20,
                      color: Colors.grey,
                    ),)
                  else
                  Text(
                     user!.fullName,
                  ),
                ],
              ),
            Container(
              margin: EdgeInsets.only(top: 4, left: isCurrentUser ? 0 : 20),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              constraints: BoxConstraints(maxWidth:
              MediaQuery.of(context).size.width - 70,),
              decoration: BoxDecoration(
                borderRadius: isCurrentUser?
                    const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ) :
                    (widget.isLast)?
                    const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ):(widget.showSenderInfo)?
                    const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ) : const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(16),
                    )
                ,
                color: isCurrentUser
                    ? Colours.currentUserChatBubbleColour
                    : Colours.otherUserChatBubbleColour,
              ),
              child: Text(
                widget.message.message,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
