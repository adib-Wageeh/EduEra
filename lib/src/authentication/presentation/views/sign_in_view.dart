import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/rounded_button.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/authentication/presentation/views/sign_up_view.dart';
import 'package:education_app/src/authentication/presentation/widgets/sign_in_form.dart';
import 'package:education_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const route = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();
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
                       Text('Easy to learn, discover more skills',
                      style: TextStyle(
                        fontFamily: Fonts.aeonik,
                        fontWeight: FontWeight.w700,
                        fontSize: 32.sp,
                      ),
                      ),
                       SizedBox(
                        height: 10.h,
                      ),
                       Text('Sign in to your account',
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,),
                            onPressed: (){
                            Navigator.pushReplacementNamed(context,
                            SignUpScreen.route,);
                          }, child:
                           Text(
                          textAlign: TextAlign.right
                          ,'Register account?',
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          ),
                          ),
                        ),
                       SizedBox(
                        height: 10.h,
                      ),
                      SignInForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: formKey,
                      ),
                       SizedBox(
                        height: 20.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(onPressed: (){
                          Navigator.pushNamed(context,
                            '/forgot-password',);
                        }, child:
                         Text('Forgot password?',
                        style: TextStyle(fontSize: 14.sp),),
                        ),
                      ),
                       SizedBox(
                        height: 10.h,
                      ),
                      if (state is AuthLoading) const
                      Center(child: CircularProgressIndicator(),)
                      else RoundedButton(
                        label: 'Sign In',
                        onPressed: (){
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if(formKey.currentState!.validate()){
                            context.read<AuthBloc>().add(SignInEvent(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()
                              ,),);
                          }
                        },
                      ),
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
