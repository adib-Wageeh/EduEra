import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsNotifier extends ChangeNotifier{

  NotificationsNotifier(this.sharedPreferences){
    _mute = sharedPreferences.getBool(key) ?? false;
  }

  late bool _mute;
  final SharedPreferences sharedPreferences;
  static const key = 'muteNotifications';

  bool get getMuteState => _mute;


  // void enableMuteNotifications(){
  //   _mute = true;
  //   sharedPreferences.setBool(key, true);
  //   notifyListeners();
  // }
  //
  // void disableMuteNotifications(){
  //   _mute = false;
  //   sharedPreferences.setBool(key, false);
  //   notifyListeners();
  // }

  void toggleMuteNotifications(){
    _mute = !_mute;
    sharedPreferences.setBool(key, _mute);
    notifyListeners();
  }



}
