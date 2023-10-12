import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/authentication/domain/entities/user_entity.dart';
import 'package:education_app/src/authentication/domain/usecases/forget_password_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/signin_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/signup_usecase.dart';
import 'package:education_app/src/authentication/domain/usecases/update_data_usecase.dart';
import 'package:education_app/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInUseCase extends Mock implements SignInUseCase{}
class MockSignUpUseCase extends Mock implements SignUpUseCase{}
class MockForgetPasswordUseCase extends Mock implements ForgetPasswordUseCase{}
class MockUpdateDataUseCase extends Mock implements UpdateDataUseCase{}


void main() {

  late SignInUseCase signInUseCase;
  late SignUpUseCase signUpUseCase;
  late ForgetPasswordUseCase forgetPasswordUseCase;
  late UpdateDataUseCase updateDataUseCase;
  late AuthBloc authBloc;
  final tUser = UserEntity.empty();
  const tServerFailure = ServerFailure(error: 'error happened',
      code: 400,);

  final tSignInParams = SignInParams.empty();
  final tSignUpParams = SignUpParams.empty();
  final tUpdateUserParams = UpdateDataParams.empty();
  const tUserAction = UpdateUserAction.email;
  const tData = 'email';


  setUp((){

    signInUseCase = MockSignInUseCase();
    signUpUseCase = MockSignUpUseCase();
    forgetPasswordUseCase = MockForgetPasswordUseCase();
    updateDataUseCase = MockUpdateDataUseCase();
    authBloc = AuthBloc(signInUseCase: signInUseCase,
        signUpUseCase: signUpUseCase,
        forgetPasswordUseCase: forgetPasswordUseCase,
        updateDataUseCase: updateDataUseCase,);

  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() => authBloc.close());

  test(' intial state should be authInitial',(){
    expect(authBloc.state, AuthInitial());
  },);

  group('sign in', () {

    blocTest<AuthBloc,AuthState>(
        'user signs in successfully',
      build: (){
          when(()=> signInUseCase(any()),).thenAnswer((_) async=>
              Right(tUser),);
          return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(
        email: tSignInParams.email,
        password: tSignInParams.password,
      ),),
      expect: ()=>[
        const AuthLoading(),
        SignedIn(user: tUser),
      ],
      verify: (_){
        verify(()=> signInUseCase(tSignInParams)).called(1);
        verifyNoMoreInteractions(signInUseCase);
      },
    );

    blocTest<AuthBloc,AuthState>(
      'Failure is thrown when user unsuccessfully signs in',
      build: (){
        when(()=> signInUseCase(any()),
        ).thenAnswer((_) async=>
        const Left(tServerFailure,),);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(
        email: tSignInParams.email,
        password: tSignInParams.password,
      ),),
      expect: ()=>[
        const AuthLoading(),
        AuthError(
          errorMessage: tServerFailure.error,
        ),
      ],
      verify: (_){
        verify(()=> signInUseCase(tSignInParams)).called(1);
        verifyNoMoreInteractions(signInUseCase);
      },
    );

  });

  group('sign up', () {

    blocTest<AuthBloc,AuthState>(
      'user signs up successfully',
      build: (){
        when(()=> signUpUseCase(
          any(),
        ),).thenAnswer((_) async=>
            const Right(null),);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
        name: '',
        email: tSignUpParams.email,
        password: tSignUpParams.password,
      ),),
      expect: ()=>const[
         AuthLoading(),
         SignedUp(),
      ],
      verify: (_){
        verify(()=> signUpUseCase(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUpUseCase);
      },
    );

    blocTest<AuthBloc,AuthState>(
      'Failure is thrown when user unsuccessfully signs up',
      build: (){
        when(()=> signUpUseCase(
          any(),
        ),).thenAnswer((_) async=>
        const Left(tServerFailure,),);
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
        name: tSignUpParams.fullName,
        email: tSignUpParams.email,
        password: tSignUpParams.password,
      ),),
      expect: ()=>[
        const AuthLoading(),
        AuthError(
          errorMessage: tServerFailure.error,
        ),
      ],
      verify: (_){
        verify(()=> signUpUseCase(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUpUseCase);
      },
    );

  });

  group('forgetPassword', () {

    blocTest<AuthBloc,AuthState>(
      'user resets password successfully',
      build: (){
        when(()=> forgetPasswordUseCase(
          any(),
        ),).thenAnswer((_) async=>
            const Right(null),);
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgetPasswordEvent(
        email: 'email',
      ),),
      expect: ()=>const[
        AuthLoading(),
        ForgetPasswordSent(),
      ],
    );

    blocTest<AuthBloc,AuthState>(
      'Failure is thrown when user unsuccessfully resets password',
      build: (){
        when(()=> forgetPasswordUseCase(
          any(),
        ),).thenAnswer((_) async=>
        const Left(tServerFailure,),);
        return authBloc;
      },
      act: (bloc) => bloc.add(ForgetPasswordEvent(
        email: tUser.email,
      ),),
      expect: ()=>[
        const AuthLoading(),
        AuthError(
          errorMessage: tServerFailure.error,
        ),
      ],
    );

  });

  group('update data', () {

    blocTest<AuthBloc,AuthState>(
      'user updates data successfully',
      build: (){
        when(()=> updateDataUseCase(
          any(),
        ),).thenAnswer((_) async=>
        const Right(null),);
        return authBloc;
      },
      act: (bloc) => bloc.add(UpdateDataEvent(
        action: tUserAction,
        data: tData,
      ),),
      expect: ()=>const[
        AuthLoading(),
        UserUpdated(),
      ],
    );

    blocTest<AuthBloc,AuthState>(
      'Failure is thrown when user updates the data unsuccessfully',
      build: (){
        when(()=> updateDataUseCase(
          any(),
        ),).thenAnswer((_) async=>
        const Left(tServerFailure,),);
        return authBloc;
      },
      act: (bloc) => bloc.add(UpdateDataEvent(
        action: tUserAction,
        data: tData,
      ),),
      expect: ()=>[
        const AuthLoading(),
        AuthError(
          errorMessage: tServerFailure.error,
        ),
      ],
    );

  });

}
