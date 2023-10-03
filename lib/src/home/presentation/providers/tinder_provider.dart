import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:flutter/cupertino.dart';

class TinderProvider extends ChangeNotifier{

  TinderProvider(List<Course> courses){
    _courses = courses;
    for(final course in _courses){
      _colorsList.add(TinderCardsColors.tinderRandomColors());
    }
    _index = 0;
    notifyListeners();
  }

  int _index = 0;
  final List<TinderCardsColors> _colorsList =[];
  List<Course> _courses = [];


  Course get currentCourse => _courses[_index];
  List<Course> get coursesList => _courses;

  List<TinderCardsColors> get colorsList => _colorsList;

  int get currentIndex => _index;

  void add(){
    if(_courses.length == 1){
      return;
    }else {
      if (_courses.length < 3) {
        _courses..add(_courses[_index])..add(_courses[_index + 1]);
        _colorsList..add(TinderCardsColors.tinderRandomColors())..add(
            TinderCardsColors.tinderRandomColors());
        _index = _index + 1;
      } else {
        _courses.add(_courses[_index]);
        _colorsList.add(TinderCardsColors.tinderRandomColors());
        _index = _index + 1;
      }
      notifyListeners();
    }
  }

}
