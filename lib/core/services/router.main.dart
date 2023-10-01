part of 'router.dart';

Route<dynamic> generateFunction(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case '/':
      final prefs = sl<SharedPreferences>();
      return _pageBuilder((context) {
        if (prefs.getBool(sharedPrefsKey) ?? true) {
          return BlocProvider<OnBoardingCubit>(
            create: (_) => sl<OnBoardingCubit>(),
            child: const OnBoardingScreen(),
          );
        } else if (sl<FirebaseAuth>().currentUser != null) {
          final user = sl<FirebaseAuth>().currentUser;
          final userModel = UserModel(email: user!.email ?? '',
            fullName: user.displayName ?? '', points: 0
            , uiD: user.uid,);
          context.getUserProvider.initUser(userModel);
          return const DashboardScreen();
        }
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        );
      },
        settings: routeSettings,
      );

    case SignUpScreen.route:
      return _pageBuilder((_) =>
          BlocProvider<AuthBloc>(
            create: (_) => sl<AuthBloc>(),
            child: const SignUpScreen(),
          )
        , settings: routeSettings,);

    case SignInScreen.route:
      return _pageBuilder((_) =>
          BlocProvider<AuthBloc>(
            create: (_) => sl<AuthBloc>(),
            child: const SignInScreen(),
          )
        , settings: routeSettings,);

    case DashboardScreen.route:
      return _pageBuilder((_) =>
      const DashboardScreen()
        , settings: routeSettings,);

    case '/forgot-password':
      return _pageBuilder((_) =>
      const fui.ForgotPasswordScreen()
        , settings: routeSettings,);

    case CourseDetailsScreen.route:
      return _pageBuilder((_) =>
          CourseDetailsScreen(course: routeSettings.arguments! as Course)
        , settings: routeSettings,);

    case CourseVideosView.route:
      return _pageBuilder((_) =>
          BlocProvider<VideoCubit>(
            create: (_) => sl<VideoCubit>(),
            child: CourseVideosView(
                course: routeSettings.arguments! as Course,),
          )
        , settings: routeSettings,);

    case VideoPlayerView.route:
      return _pageBuilder((_) =>
          VideoPlayerView(
            videoUrl: routeSettings.arguments! as String,)
        , settings: routeSettings,);

    case AddVideoView.route:
      return _pageBuilder((_) =>
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CourseCubit>()),
              BlocProvider(create: (_) => sl<VideoCubit>()),
              BlocProvider(create: (_) => sl<NotificationCubit>()),
            ]
            , child: const AddVideoView(),)
        , settings: routeSettings,);

    case AddMaterialsView.route:
      return _pageBuilder((_) =>
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CourseCubit>()),
              BlocProvider(create: (_) => sl<ResourceCubit>()),
            ]
            , child: const AddMaterialsView(),)
        , settings: routeSettings,);

    case AddExamView.route:
      return _pageBuilder((_) =>
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<CourseCubit>()),
              BlocProvider(create: (_) => sl<ExamCubit>()),
            ]
            , child: const AddExamView(),)
        , settings: routeSettings,);

    default:
      return _pageBuilder((_) => const PageUnderConstructionScreen(),
        settings: routeSettings,);
  }
}

PageRouteBuilder<dynamic> _pageBuilder(Widget Function(BuildContext) page,
    {required RouteSettings settings,}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation,
          child: child,)
    , pageBuilder: (context, _, __) => page(context),);
}
