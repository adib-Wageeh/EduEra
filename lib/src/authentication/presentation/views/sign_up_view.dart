import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/rounded_button.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/authentication/presentation/views/sign_in_view.dart';
import 'package:education_app/src/authentication/presentation/widgets/sign_up_form.dart';
import 'package:education_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const route = '/sign-up';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc,AuthState>(
        listener: (_,state){
          if(state is AuthError){
            CoreUtils.showSnackBar(context, state.errorMessage);
          }else if(state is SignedIn){
            context.read<UserProvider>().initUser(state.user as UserModel);
            Navigator.pushReplacementNamed(context, DashboardScreen.route);
          }else if(state is SignedUp){
            context.read<AuthBloc>().add(SignInEvent(password:
                passwordController.text.trim()
                , email:emailController.text.trim(),),);
          }
        },
        builder: (context,state){
          return GradientBackground(image: MediaRes.authGradientBackground
            , child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding:const EdgeInsets.symmetric(horizontal: 20),
                  children:  [
                    const Text('Easy to learn, discover more skills',
                      style: TextStyle(
                        fontFamily: Fonts.aeonik,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Sign up for a new account',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,)
                        ,onPressed: (){
                          Navigator.pushReplacementNamed(context,
                            SignInScreen.route,);
                        }, child:
                        const Text(
                          // textAlign: TextAlign.right,
                        'Already has an account?',),
                        ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SignUpForm(
                      emailController: emailController,
                      fullNameController: fullNameController,
                      confirmPasswordController: confirmPasswordController,
                      passwordController: passwordController,
                      formKey: formKey,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (state is AuthLoading) const
                    Center(child: CircularProgressIndicator(),)
                    else RoundedButton(
                      label: 'Sign Up',
                      onPressed: (){
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if(formKey.currentState!.validate()){
                          context.read<AuthBloc>().add(SignUpEvent(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            name: fullNameController.text.trim()
                            ,),);
                        }
                      },
                    )
                  ],
                ),
              ),

            ),
          );
        },

      ),
    );
  }
}
