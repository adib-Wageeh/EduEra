import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/domain/usecases/get_groups_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/join_group_use_case.dart';
import 'package:education_app/src/chat/domain/usecases/leave_group_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit({
    required GetGroupsUseCase getGroups,
    required JoinGroupUseCase joinGroup,
    required LeaveGroupUseCase leaveGroup,

}) :
        _getGroups = getGroups,
        _joinGroup = joinGroup,
        _leaveGroup = leaveGroup,
        super(const GroupInitial());

  final GetGroupsUseCase _getGroups;
  final JoinGroupUseCase _joinGroup;
  final LeaveGroupUseCase _leaveGroup;

  Future<void> joinGroup({required String groupId,}) async {
    emit(const JoiningGroup());
    final result = await _joinGroup(groupId,);
    result.fold(
          (failure) => emit(GroupError(failure.errorMessage)),
          (_) => emit(const JoinedGroup()),
    );
  }

  Future<void> leaveGroup({required String groupId,}) async {
    emit(const LeavingGroup());
    final result = await _leaveGroup(groupId,);
    result.fold(
          (failure) => emit(GroupError(failure.errorMessage)),
          (_) => emit(const LeftGroup()),
    );
  }

  void getGroups() {
    emit(const LoadingGroups());

    StreamSubscription<Either<Failure, List<Group>>>? subscription;

    subscription = _getGroups().listen(
          (result) {
        result.fold(
              (failure) => emit(GroupError(failure.errorMessage)),
              (groups) => emit(GroupsLoaded(groups)),
        );
      },
      onError: (dynamic error) {
        emit(GroupError(error.toString()));
        subscription?.cancel();
      },
      onDone: () => subscription?.cancel(),
    );
  }

}
