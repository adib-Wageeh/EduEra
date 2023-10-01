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

  void toggleMuteNotifications(){
    _mute = !_mute;
    sharedPreferences.setBool(key, _mute);
    notifyListeners();
  }



}
