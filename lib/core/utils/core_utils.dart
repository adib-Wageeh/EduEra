import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:education_app/core/enums/notification.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/notification/data/models/notification_model.dart';
import 'package:education_app/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CoreUtils{

  const CoreUtils._();

  static void showSnackBar(BuildContext context,String message){
    ScaffoldMessenger.of(context)..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),),
      behavior: SnackBarBehavior.floating,
        backgroundColor: Colours.primaryColour,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),);

  }

  static void showLoadingDialog(BuildContext context){

    showDialog<void>(
    barrierDismissible: false
    ,context: context, builder: (_){
      return const Center(
        child: CircularProgressIndicator(),
      );
    },);
  }

  static Future<File?> pickImage()async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image != null) {
        return File(image.path);
    }
    return null;
  }

  static Widget imageType(String image
  ,{String replacement = MediaRes.examQuestions,
      double dimensions = 32,}){
    if(image.isEmpty){
      return Image.asset(replacement,
        height: dimensions.h,
        width: dimensions.w,
        fit: BoxFit.cover,
      );
    }
    return CachedNetworkImage(
      imageUrl: image,
      height: dimensions.w,
      width: dimensions.h,
      fit: BoxFit.cover,
    );
  }

  static void sendNotification(String title,
      String body
      ,NotificationCategory category,BuildContext context,){

    context.read<NotificationCubit>().sendNotification(
      NotificationModel.empty().copyWith(
        title: title,
        body: body,
        category: category,
      ),
    );
  }

}
