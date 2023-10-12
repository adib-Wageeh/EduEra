part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();
  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {
  const GroupInitial();
}

class LeftGroup extends GroupState {
  const LeftGroup();
}

class JoinedGroup extends GroupState {
  const JoinedGroup();
}

class GroupsLoaded extends GroupState {
  const GroupsLoaded(this.groups);

  final List<Group> groups;

  @override
  List<Object> get props => [groups.map(
        (group) => group.members.contains
      (sl<FirebaseAuth>().currentUser!.uid),),];
}

class JoiningGroup extends GroupState {
  const JoiningGroup();
}

class LeavingGroup extends GroupState {
  const LeavingGroup();
}

class LoadingGroups extends GroupState {
  const LoadingGroups();
}

class GroupError extends GroupState {
  const GroupError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}