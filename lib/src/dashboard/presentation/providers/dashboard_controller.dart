import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/views/persistent_view.dart';
import 'package:education_app/src/profile/presentation/views/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DashBoardController extends ChangeNotifier{

  List<int> _indexHistory = [0];
  final List<Widget> screens =[
    ChangeNotifierProvider(
      create: (_)=>
      TabNavigator(
        TabItem(child: Placeholder()),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_)=>
          TabNavigator(
            TabItem(child: Placeholder()),
          ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_)=>
          TabNavigator(
            TabItem(child: Placeholder()),
          ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_)=>
          TabNavigator(
            TabItem(child: const ProfileView(),),
          ),
      child: const PersistentView(),
    ),
  ];

  int _currentIndex =0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index){
    if(index == _currentIndex) {
      return;
    }
    _currentIndex = index;
    _indexHistory.add(_currentIndex);
    notifyListeners();
  }

  void goBack(){
    if(_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex(){
    _currentIndex=0;
    _indexHistory = [0];
    notifyListeners();
  }

}
