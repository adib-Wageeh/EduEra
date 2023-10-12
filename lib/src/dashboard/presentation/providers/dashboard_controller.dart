import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/features/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:education_app/core/common/features/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/core/common/features/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/core/common/views/persistent_view.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit/chat_cubit.dart';
import 'package:education_app/src/chat/presentation/cubit/group_cubit/group_cubit.dart';
import 'package:education_app/src/chat/presentation/views/group_view.dart';
import 'package:education_app/src/home/presentation/views/home_view.dart';
import 'package:education_app/src/notification/presentation/cubit/notification_cubit.dart';
import 'package:education_app/src/profile/presentation/views/profile_view.dart';
import 'package:education_app/src/quick_access/presentation/app/providers/quick_access_controller.dart';
import 'package:education_app/src/quick_access/presentation/views/quick_access_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DashBoardController extends ChangeNotifier {

  List<int> _indexHistory = [0];
  final List<Widget> screens = [
    ChangeNotifierProvider(
      create: (_) =>
          TabNavigator(
            TabItem(child: MultiBlocProvider(
              providers: [
                BlocProvider<CourseCubit>(
                  create: (_) => sl<CourseCubit>(),
                ),
                BlocProvider<VideoCubit>(
                  create: (_) => sl<VideoCubit>(),
                ),
                BlocProvider.value(
                  value: sl<NotificationCubit>(),
                ),
              ],
              child: const HomeView(),
            ),),
          ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) =>
          TabNavigator(
            TabItem(child: ChangeNotifierProvider(
              create: (_) => QuickAccessController(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => sl<CourseCubit>(),
                  ),
                  BlocProvider(
                    create: (_) => sl<ExamCubit>(),
                  ),
                ],
                child: const QuickAccessView(),),),),
          ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) =>
          TabNavigator(
            TabItem(child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<ChatCubit>(),
                ),
                BlocProvider.value(
                  value: sl<GroupCubit>(),
                ),
              ],
              child: const GroupView(),
            ),),
          ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) =>
          TabNavigator(
            TabItem(child: const ProfileView(),),
          ),
      child: const PersistentView(),
    ),
  ];

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (index == _currentIndex) {
      return;
    }
    _currentIndex = index;
    _indexHistory.add(_currentIndex);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _currentIndex = 0;
    _indexHistory = [0];
    notifyListeners();
  }

}
