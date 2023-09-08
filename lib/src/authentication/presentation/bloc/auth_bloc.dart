import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/authentication/domain/usecases/forget_password_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/signin_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/signup_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/update_data_usecase.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required SignInUseCase signInUseCase
    ,required SignUpUseCase signUpUseCase
    , required ForgetPasswordUseCase forgetPasswordUseCase,
  required UpdateDataUseCase updateDataUseCase,}) :
   _updateDataUseCase = updateDataUseCase,
  _forgetPasswordUseCase = forgetPasswordUseCase,
  _signUpUseCase = signUpUseCase,
  _signInUseCase = signInUseCase
  ,super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });

    on<SignInEvent>(_signIn);
    on<SignUpEvent>(_signUp);
    on<ForgetPasswordEvent>(_forgetPassword);
    on<UpdateDataEvent>(_updateData);

  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final UpdateDataUseCase _updateDataUseCase;

  Future<void> _signIn(SignInEvent event, Emitter<AuthState> emit)async{

    final result = await _signInUseCase.call(SignInParams(email: event.email,
        password: event.password,),);
    result.fold((error){
      emit(AuthError(errorMessage: error.error));
    }, (user){
      emit(SignedIn(user: user));
    });

  }

  Future<void> _signUp(SignUpEvent event, Emitter<AuthState> emit)async{

    final result = await _signUpUseCase.call(SignUpParams(email: event.email,
      password: event.password,
    fullName: event.name,
    ),);
    result.fold((error){
      emit(AuthError(errorMessage: error.error));
    }, (user){
      emit(const SignedUp());
    });

  }

  Future<void> _forgetPassword(ForgetPasswordEvent event,
      Emitter<AuthState> emit,)async{

    final result = await _forgetPasswordUseCase.call(event.email);
    result.fold((error){
      emit(AuthError(errorMessage: error.error));
    }, (user){
      emit(const ForgetPasswordSent());
    });
  }

  Future<void> _updateData(UpdateDataEvent event,
      Emitter<AuthState> emit,)async{

    final result = await _updateDataUseCase.call(
      UpdateDataParams(userData: event.data, action: event.action),
    );
    result.fold((error){
      emit(AuthError(errorMessage: error.error));
    }, (user){
      emit(const UserUpdated());
    });
  }

}
