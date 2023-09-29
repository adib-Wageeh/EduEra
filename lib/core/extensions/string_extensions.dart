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

}
