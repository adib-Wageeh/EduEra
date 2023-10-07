import 'package:education_app/core/common/widgets/i_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({required this.passwordController,
    required this.emailController, required this.formKey,
    super.key,});
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.emailController,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
          ),
           SizedBox(
            height: 10.h,
          ),
          IField(
            controller: widget.passwordController,
            hintText: 'Password',
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                obscurePassword = !obscurePassword;
              });
            }, icon: Icon(obscurePassword? IconlyLight.hide
                :IconlyLight.show,
            color: Colors.grey,
            ),),
            keyboardType: TextInputType.visiblePassword,
            obscureText: obscurePassword,
          ),
           SizedBox(
            height: 20.h,
          ),

        ],
      ),

    );
  }
}
