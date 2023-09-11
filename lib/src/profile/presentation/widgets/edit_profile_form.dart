import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/extensions/string_extensions.dart';
import 'package:education_app/src/profile/presentation/widgets/edit_profile_form_field.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({required this.passwordController,
    required this.oldPasswordController, required this.bioController,
    required this.emailController, required this.fullNameController,
    super.key,});

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;

  @override
  Widget build(BuildContext context) {
    final GlobalKey formKey = GlobalKey<FormState>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileFormField(
          controller: fullNameController,
          fieldTitle: 'FULL NAME',
          hintText: context.currentUser!.fullName,
        ),
        EditProfileFormField(
          controller: emailController,
          fieldTitle: 'EMAIL',
          hintText: context.currentUser!.email.obscureEmail,
        ),
        EditProfileFormField(
          controller: oldPasswordController,
          fieldTitle: 'CURRENT PASSWORD',
          hintText: '********',
        ),
        StatefulBuilder(
          builder: (context,refresh) {
            oldPasswordController.addListener(() {
              refresh((){});
            });
            return EditProfileFormField(
              controller: passwordController,
              fieldTitle: 'NEW PASSWORD',
              hintText: '********',
              readOnly:
              oldPasswordController.text
                  .trim()
                  .isEmpty,
            );
          },
        ),
        EditProfileFormField(
          controller: bioController,
          fieldTitle: 'BIO',
          hintText: context.currentUser!.bio,
        ),
      ],
    );
  }
}
