import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:education_app/src/chat/presentation/widgets/chat_app_bar.dart';
import 'package:education_app/src/chat/presentation/widgets/chat_input_field.dart';
import 'package:education_app/src/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.group, super.key});

  final Group group;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  void getMessages() {
    context.read<ChatCubit>().getMessages(widget.group.id);
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        if(state is LeftGroup){
          CoreUtils.showSnackBar(context,'Left group successfully');
          context.popTab();
        }
      },
      child: Scaffold(
        appBar: ChatAppBar(group: widget.group,),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child:
              BlocConsumer<ChatCubit, ChatState>(
                buildWhen: (prev, curr) {
                  if (curr is MessageSent) {
                    return false;
                  }
                  return true;
                },
                listener: (context, state) {
                  if (state is ChatError) {
                    CoreUtils.showSnackBar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is MessagesLoaded) {
                    return ListView.builder(
                      reverse: true,
                      itemBuilder: (context, index) {
                      final current = state.messages[index];
                      final next = (index+1 < state.messages.length)
                          ? state.messages[index+1]:null;
                      final prev = (index-1 >= 0)
                          ? state.messages[index-1]:null;
                      final showSenderInfo = CoreUtils.showSenderInfo
                        (current,prev,next,state.messages.length);
                      return BlocProvider(
                        create: (_) => sl<ChatCubit>(),
                        child: MessageBubble(
                          current, showSenderInfo: showSenderInfo,),
                      );
                    },
                      itemCount: state.messages.length,
                    );
                  }
                  return const Center(child: CircularProgressIndicator(),);
                },
              ),
            ),
            ChatInputField(groupId: widget.group.id,),
          ],
        ),
      ),
    );
  }
}
