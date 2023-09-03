import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext{

  ThemeData get getTheme{
    return Theme.of(this);
  }

  MediaQueryData get getMediaQuery{
    return MediaQuery.of(this);
  }

  Size get size => getMediaQuery.size;
  double get height => size.height;
  double get widget => size.width;

}
