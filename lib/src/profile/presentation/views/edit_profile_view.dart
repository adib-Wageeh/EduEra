import 'dart:convert';
import 'dart:io';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/profile/presentation/widgets/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  File? pickedImage;



  @override
  void initState() {
    fullNameController.text = context.currentUser!.fullName.trim();
    bioController.text = context.currentUser!.bio?.trim() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    bioController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool get nameChanged => fullNameController.text.trim()
      != context.currentUser!.fullName.trim();

  bool get emailChanged => emailController.text.trim().isNotEmpty;

  bool get bioChanged => bioController.text.trim().isNotEmpty;

  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get imageChanged => pickedImage != null;

  bool get nothingChanged =>
  !nameChanged && !emailChanged && !bioChanged && !passwordChanged
      && !imageChanged;

  Future<void> selectImage()async{
   final image = await CoreUtils.pickImage();
   setState(() {
     pickedImage = image;
   });

  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthBloc,AuthState>(
      builder: (context,state){
        return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true
          ,
        appBar: AppBar(
          leading: const NestedBackButton(),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              if(nothingChanged){
                context.popTab();
              }else{
                final bloc = context.read<AuthBloc>();
                if(passwordChanged){
                  if(oldPasswordController.text.trim().isEmpty){
                    CoreUtils.showSnackBar(context
                      , 'please enter your old password',);
                    return;
                  }
                    bloc.add(
                      UpdateDataEvent(action:
                      UpdateUserAction.password,
                        data: jsonEncode({
                          'oldPassword':oldPasswordController.text.trim(),
                        'newPassword':passwordController.text.trim()}),),
                    );
                }
                if(nameChanged){
                  bloc.add(
                      UpdateDataEvent(action:
                      UpdateUserAction.displayName,
                          data: fullNameController.text.trim(),),
                  );
                }
                if(emailChanged){
                  bloc.add(
                    UpdateDataEvent(action:
                    UpdateUserAction.email,
                      data: emailController.text.trim(),),
                  );
                }
                if(bioChanged){
                  bloc.add(
                    UpdateDataEvent(action:
                    UpdateUserAction.bio,
                      data: bioController.text.trim(),),
                  );
                }
                if(imageChanged){
                  bloc.add(UpdateDataEvent(
                      action: UpdateUserAction.profilePic
                      , data: pickedImage,),);
                }

              }

            }
                , child:
                (state is AuthLoading)?
                    const Center(
                      child: CircularProgressIndicator(),
                    ):
                    StatefulBuilder(
                      builder: (_,refresh) {
                        fullNameController.addListener(() => refresh((){}));
                        bioController.addListener(() => refresh((){}));
                        passwordController.addListener(() => refresh((){}));
                        emailController.addListener(() => refresh((){}));
                        return Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: nothingChanged?Colors.grey:
                                Colors.blueAccent,
                          ),
                        );
                      },
                    ),
            ),
          ],
        )
        ,body: GradientBackground(image: MediaRes.profileGradientBackground
          ,child:
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Builder(
                  builder: (context) {
                    final user = context.currentUser!;
                    final userImage = user.profilePic == null ||
                    user.profilePic!.isEmpty ? null : user.profilePic;

                    return Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: (pickedImage != null)?
                            FileImage(pickedImage!):
                            (userImage != null)? NetworkImage(userImage):
                            const AssetImage(MediaRes.user) as ImageProvider,
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.linearToSrgbGamma(),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                              (pickedImage != null || user.profilePic != null)?
                                  Icons.edit:Icons.add_a_photo,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'We recommend an image of at least 400x400',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF777E90),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                EditProfileForm(
                  fullNameController: fullNameController,
                  bioController: bioController,
                  emailController: emailController,
                  oldPasswordController: oldPasswordController,
                  passwordController: passwordController,
                )
              ],
            )
              ,),
        );

      }, listener: (context,state){
      if(state is AuthError){
        CoreUtils.showSnackBar(context
            , state.errorMessage,);
      }
      if(state is UserUpdated){
        CoreUtils.showSnackBar(context
          , 'Data has been updated successfully',);
        context.popTab();
      }
    },);
  }
}
