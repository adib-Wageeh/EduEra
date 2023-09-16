import 'package:education_app/core/common/features/course/domain/entities/course_entity.dart';
import 'package:flutter/widgets.dart';

class CourseOfTheDayNotifier extends ChangeNotifier{

  Course? _courseOfTheDay;

  Course? get course => _courseOfTheDay;

  void setCourseOfTheDay(Course course){
    if(_courseOfTheDay != course) {
      _courseOfTheDay = course;
      notifyListeners();
    }
  }

}
