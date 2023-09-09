import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/authentication/data/models/user_model.dart';
import 'package:education_app/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:education_app/src/dashboard/presentation/utils/dashboard_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const route = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
      DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<UserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (_,snapshot){
        if(snapshot.hasData){
          context.read<UserProvider>().user = snapshot.data;
        }
        return Consumer<DashBoardController>(
        builder: (_,controller,__){
          return Scaffold(
            body: IndexedStack(
              index: controller.currentIndex,
              children: controller.screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              elevation: 8,
              currentIndex: controller.currentIndex,
              onTap: controller.changeIndex,
              items: [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                  icon: Icon(
                      (controller.currentIndex == 0)?
                          IconlyBold.home:IconlyLight.home,
                    color: (controller.currentIndex == 0)?
                    Colours.primaryColour:Colors.grey,
                  ),label: 'Home',),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                        (controller.currentIndex == 1)?
                        IconlyBold.document:IconlyLight.document
                        ,color: (controller.currentIndex == 1)?
                        Colours.primaryColour:Colors.grey,
                    ),label: 'Materials',),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                        (controller.currentIndex == 2)?
                        IconlyBold.chat:IconlyLight.chat,
                      color: (controller.currentIndex == 2)?
                      Colours.primaryColour:Colors.grey,
                    ),label: 'Chat',),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                      (controller.currentIndex == 3)?
                      IconlyBold.profile:IconlyLight.profile,
                      color: (controller.currentIndex == 3)?
                      Colours.primaryColour:Colors.grey,
                    ),label: 'Profile',),
              ],
            ),
          );
        },);
      },
    );
  }
}
