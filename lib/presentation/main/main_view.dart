import 'package:citizencentric/presentation/main/search_page.dart';
import 'package:citizencentric/presentation/main/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import '../riverpod/main_view_controller..dart';
import 'home/home_page.dart';
import 'notification_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainView extends ConsumerWidget {

  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentIndex = ref.watch(mainViewProvider);
    print("-----------22-----$currentIndex");
    final controller = ref.read(mainViewProvider.notifier);

    List<Widget> pages = [
      HomePage(),
      SearchPage(),
      NotificationPage(),
      SettingPage(),
    ];

    List<String> titles = [
      AppStrings.home.tr(),
      AppStrings.search.tr(),
      AppStrings.notifications.tr(),
      AppStrings.settings.tr(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        actions: [
          GestureDetector(
              onTap: (){
                // her i press a setting icon and send a theme parameter
                ref.read(appThemeProvider.notifier).toggleTheme();
              },
              child: Icon(Icons.settings, color: Colors.white)),
        ],
      ),

      body: pages[currentIndex],
      // bottomNavigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
        boxShadow:
        [
          BoxShadow(
              color: ColorManager.lightGrey,
              spreadRadius: AppSize.s1)
        ]),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: currentIndex,
          onTap: (index) => controller.changeIndex(index),

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppStrings.home.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: AppStrings.search.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: AppStrings.notifications.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppStrings.settings.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
