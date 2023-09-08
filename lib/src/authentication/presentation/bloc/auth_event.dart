part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent{
  const SignInEvent({required this.password,required this.email});
  final String email;
  final String password;

  @override
  List<String> get props => [email,password];
}

class SignUpEvent extends AuthEvent{
  const SignUpEvent({required this.password,required this.email
  ,required this.name,});
  final String email;
  final String password;
  final String name;
  @override
  List<String> get props => [email,password,name];
}

class ForgetPasswordEvent extends AuthEvent{
  const ForgetPasswordEvent({required this.email});
  final String email;

  @override
  List<String> get props => [email];
}

class UpdateDataEvent extends AuthEvent {
  UpdateDataEvent({required this.action, required this.data})
      : assert(
  data is String || data is File,
  'data must be a string or a file, but was ${data.runtimeType}',
  );
  final UpdateUserAction action;
  final dynamic data;

  @override
  List<Object?> get props => [action, data];
}
