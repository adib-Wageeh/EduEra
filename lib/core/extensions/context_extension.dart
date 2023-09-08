import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtension on BuildContext{

  ThemeData get getTheme{
    return Theme.of(this);
  }

  MediaQueryData get getMediaQuery{
    return MediaQuery.of(this);
  }

  Size get size => getMediaQuery.size;
  double get height => size.height;
  double get width => size.width;

  UserProvider get getUserProvider{

    return read<UserProvider>();
  }

  UserModel? get currentUser => getUserProvider.user;

}
