import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/usecase/usecase.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateDataUseCase extends UseCaseWithParams<void,UpdateDataParams>{

  const UpdateDataUseCase({required this.authenticationRepository});
  final AuthenticationRepository authenticationRepository;

  @override
  ResultFuture<void> call(UpdateDataParams p){
    return authenticationRepository.updateData(
      action: p.action,userData: p.userData,
    );
  }

}

class UpdateDataParams extends Equatable{

  const UpdateDataParams({required this.userData,required this.action,});

  factory UpdateDataParams.empty()=> const UpdateDataParams(
    userData: '',action: UpdateUserAction.displayName,);
  final dynamic userData;
  final UpdateUserAction action;

  @override
  List<Object?> get props => [userData,action,];

}
