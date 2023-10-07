import 'package:education_app/core/common/widgets/i_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({required this.passwordController, required this.formKey,
    required this.emailController, required this.fullNameController,
    required this.confirmPasswordController, super.key,});
  final TextEditingController fullNameController;
  final TextEditingController confirmPasswordController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.fullNameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.name,
          ),
           SizedBox(
            height: 10.h,
          ),
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
            }, icon: Icon(obscurePassword? IconlyLight.show
                :IconlyLight.hide,
              color: Colors.grey,
            ),),
            keyboardType: TextInputType.visiblePassword,
            obscureText: obscurePassword,
          ),
           SizedBox(
            height: 10.h,
          ),
          IField(
            controller: widget.confirmPasswordController,
            hintText: 'Confirm Password',
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                obscureConfirmPassword = !obscureConfirmPassword;
              });
            }, icon: Icon(obscureConfirmPassword? IconlyLight.show
                :IconlyLight.hide,
              color: Colors.grey,
            ),),
            validator: (text){
              if(text != widget.passwordController.text){
                return "password confirmation doesn't match";
              }
              return null;
            },
            overrideValidator: true,
            obscureText: obscureConfirmPassword,
          ),
           SizedBox(
            height: 20.h,
          ),

        ],
      ),

    );
  }
}
