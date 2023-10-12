import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:education_app/src/chat/presentation/widgets/group_tile.dart';
import 'package:education_app/src/chat/presentation/widgets/your_group_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {

  void getGroups(){
    context.read<GroupCubit>().getGroups();
  }
  bool showingDialog = false;

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
       backgroundColor: Colors.white,
       body: BlocConsumer<GroupCubit,GroupState>(
         listener: (context,state){
           if (showingDialog) {
             Navigator.of(context).pop();
             showingDialog = false;
           }
           if (state is GroupError) {
             CoreUtils.showSnackBar(context, state.message);
           } else if (state is JoiningGroup) {
             showingDialog = true;
             CoreUtils.showLoadingDialog(context);
           } else if (state is JoinedGroup) {
             CoreUtils.showSnackBar(context, 'Joined group successfully');
           }
         },
         buildWhen: (prev,current){
           if(current is LeftGroup || current is JoinedGroup) {
             return false;
           }
           return true;
         },
         builder: (context,state){
           if (state is LoadingGroups) {
             return const LoadingView();
           }else if (state is GroupsLoaded && state.groups.isNotEmpty){
               final joinedGroups = CoreUtils.getJoinedGroups(state.groups);
               final otherGroups = CoreUtils.getOtherGroups(state.groups);
               return ListView(
                 padding: const EdgeInsets.all(20),
                 children: [
                   if(joinedGroups.isNotEmpty)...[
                     Text(
                       'Your Groups',
                       style: context.getTheme.
                       textTheme.titleMedium?.copyWith(
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                     Divider(color: Colors.grey.shade300),
                     ...joinedGroups.map((group) {
                       return YourGroupTile(group: group,);
                     }),
                   ],
                   if (otherGroups.isNotEmpty) ...[
                     Text(
                       'Groups',
                       style: context.getTheme.textTheme.titleMedium?.copyWith(
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                     Divider(color: Colors.grey.shade300),
                     ...otherGroups.map(OtherGroupTile.new),
                   ],
                 ],
               );
             }
             return const SizedBox();
         },
       ),
    );
  }
}
