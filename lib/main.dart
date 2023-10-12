import 'package:education_app/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:education_app/core/common/app/providers/notification_notifier.dart';
import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/services/router.dart';
import 'package:education_app/firebase_options.dart';
import 'package:education_app/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
          create: (_)=> UserProvider(),),
          ChangeNotifierProvider(
            create: (_)=> DashBoardController(),),
          ChangeNotifierProvider(
            create: (_)=> CourseOfTheDayNotifier(),),
          ChangeNotifierProvider(
            create: (_)=> NotificationsNotifier(sl<SharedPreferences>()),),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              color: Colors.transparent,
            ),
            fontFamily: Fonts.poppins,
            colorScheme: ColorScheme.fromSwatch(
                accentColor: Colours.primaryColour,),
          ),
          onGenerateRoute: generateFunction,
        ),
      ),
    );
  }
}
