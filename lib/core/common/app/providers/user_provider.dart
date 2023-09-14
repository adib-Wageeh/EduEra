import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

  UserModel? _user;

  UserModel? get user => _user;

  void initUser(UserModel? userModel){

    if(userModel != _user){
      _user = userModel;
    }
  }

  set user(UserModel? userModel){
    if(userModel != _user){
      _user = userModel;
      Future.delayed(Duration.zero,notifyListeners,);

    }
  }

}
