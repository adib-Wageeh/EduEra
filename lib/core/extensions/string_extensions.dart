import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

extension StringExtensions on String{

  String get obscureEmail{

    final index = indexOf('@');
    var username = substring(0,index);
    final domain = substring(index+1);

    username = '${username[0]}****${username[username.length-1]}';
    return '$username@$domain';
  }

  bool get checkIfYoutube => contains('youtube.com/watch?v=') ||
    contains('youtu.be/');

  String get iconFromExtension{
    switch(this){

      case 'pdf':
        return MediaRes.pdf2;
      case 'json':
        return MediaRes.json2;
      default:
        return MediaRes.material;

    }

  }

}
