import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class TabNavigator extends ChangeNotifier{

  TabNavigator(this._initialTab){
    _navigationStack.add(_initialTab);
  }

  final TabItem _initialTab;
  final List<TabItem> _navigationStack = [];

  TabItem get currentTab => _navigationStack.last;

  void push(TabItem tab){
    _navigationStack.add(tab);
    notifyListeners();
  }

  void pop(){
    if(_navigationStack.length>1){
      _navigationStack.removeLast();
      notifyListeners();
    }
  }

  void popToRoot(){
    _navigationStack..clear()..add(_initialTab);
    notifyListeners();
  }

  void popTo(TabItem tab){
    _navigationStack.remove(tab);
    notifyListeners();
  }

  void popUntil(TabItem? tab){

    if(tab == null){
      return popToRoot();
    }else{
      if(_navigationStack.length>1){
        _navigationStack.removeRange(1, _navigationStack.indexOf(tab)+1);
      }
    }
    notifyListeners();
  }

  void pushAndRemoveUntil(TabItem tab){
    _navigationStack..clear()..add(tab);
    notifyListeners();
  }


}

class TabNavigatorProvider extends InheritedNotifier<TabNavigator> {
  const TabNavigatorProvider({
    required this.navigator,
    required super.child,
    super.key,
  }) : super(notifier: navigator);

  final TabNavigator navigator;

  static TabNavigator? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TabNavigatorProvider>()
        ?.navigator;
  }
}

class TabItem extends Equatable{

  TabItem({required this.child}):
      id = const Uuid().v1();

  final String id;
  final Widget child;
  @override
  List<dynamic> get props => [id];


}