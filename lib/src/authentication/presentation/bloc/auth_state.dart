part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class SignedIn extends AuthState {

  const SignedIn({required this.user});
  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class SignedUp extends AuthState {
  const SignedUp();
}

class ForgetPasswordSent extends AuthState {
  const ForgetPasswordSent();
}

class UserUpdated extends AuthState {
  const UserUpdated();
}


class AuthError extends AuthState {

  const AuthError({required this.errorMessage});
  final String errorMessage;

  @override
  List<String> get props => [errorMessage];
}
