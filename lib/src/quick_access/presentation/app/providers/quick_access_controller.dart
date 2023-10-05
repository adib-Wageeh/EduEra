import 'package:education_app/core/res/media_res.dart';
import 'package:flutter/foundation.dart';

class QuickAccessController extends ChangeNotifier{

int _currentIndex = 0;

int get currentIndex => _currentIndex;

String get currentImage{
  switch(_currentIndex){
    case 0:
      return MediaRes.bluePotPlant;
    case 1:
      return MediaRes.steamCup;
    default:
      return MediaRes.turquoisePotPlant;
  }
}

void changeIndex(int newIndex){
  if(newIndex == _currentIndex) return;
  _currentIndex = newIndex;
  notifyListeners();
}


}
