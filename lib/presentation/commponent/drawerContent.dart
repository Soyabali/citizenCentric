import 'dart:math' as math;

import 'package:citizencentric/presentation/resources/color_manager.dart';
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/data_source/local_data_source.dart';
import '../change_password/changePassword.dart';
import '../notification/notification.dart';
import '../resources/routes_manager.dart';



class DrawerContent extends ConsumerWidget {
  final String name;
  final String mobileNo;

  DrawerContent({
    super.key,
    required this.name,
    required this.mobileNo,
  });

  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Drawer build called');

    return Drawer(
      child: Column(
        children: [
          // ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: ColorManager.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Version : 1.0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
               Padding(
                 padding: const EdgeInsets.only(left: 10.0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       width: 100,
                       height: 100,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.white, width: 3),
                         image: const DecorationImage(
                           image: AssetImage('assets/images/bg.png'),
                           fit: BoxFit.cover,
                         ),
                       ),
                     ),
                     const SizedBox(height: 12),
                     Text(
                       name,
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 18,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     const SizedBox(height: 4),
                     Row(
                       children: [
                         const Icon(Icons.call, color: Colors.white, size: 16),
                         const SizedBox(width: 10),
                         Text(
                           mobileNo,
                           style: const TextStyle(
                             color: Colors.white,
                             fontSize: 14,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               )
              ],
            ),
          ),

          // ================= MENU ITEMS =================
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  icon: Icons.home_outlined,
                  title: AppStrings.home.tr(),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _divider(),

                _drawerItem(
                  icon: Icons.lock_outline,
                  title: AppStrings.changePassword.tr(),
                  iconColor: const Color(0xFFFBC02D),
                  onTap: () {
                    // navigate to a ChangePasswordPark
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => ChangePassWord()),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChangePassWordHome()),
                    );


                    //Navigator.pop(context);
                  },
                ),
                _divider(),

                _drawerItem(
                  icon: Icons.notifications,
                  title: AppStrings.notifications.tr(),
                  iconColor: const Color(0xFFFBC02D),
                  onTap: () {
                    //   NotificationPageHome
                    //Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationPageHome()),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _divider(),

                // _drawerItem(
                //   icon: Icons.language,
                //   title: AppStrings.changeLanguage.tr(),
                //   iconColor: const Color(0xFFFBC02D),
                //   onTap: () => _changeLanguage(context),
                // ),
                // _divider(),
                // _drawerItem(
                //   icon: Icons.change_circle_outlined,
                //   title: AppStrings.changeLanguage.tr(),
                //   iconColor: ColorManager.primary,
                //   onTap: () {
                //     ref.read(appThemeProvider.notifier).toggleTheme();
                //   }
                // ),
                _divider(),

                _drawerItem(
                  icon: Icons.logout,
                  title: AppStrings.logout.tr(),
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                  onTap: () {
                   // _logout(context);
                   // inputState.add(SuccessState('Login Sucess'));
                    showDialog(
                      context: context,
                      barrierDismissible: false, // Prevent closing by tapping outside
                      builder: (BuildContext context) {
                        return logoutDialogBox(context);
                      },
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DRAWER ITEM =================
  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF2E7D32),
    Color textColor = const Color(0xFF1B5E20),
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      horizontalTitleGap: 8,
      onTap: onTap,
    );
  }

  // ================= DIVIDER =================
  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(thickness: 0.8, height: 1),
    );
  }

  // ================= LANGUAGE =================
  void _changeLanguage(BuildContext context) {
    _appPreferences.setLanguageChanged();
    Phoenix.rebirth(context);
  }

  // ================= LOGOUT =================
  void _logout(BuildContext context) {

    _appPreferences.logout();
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  //   ---logoutDialog----.

  Widget logoutDialogBox(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: ColorManager.primary, width: 2),
      ),
      title: Text('Do you want to logout?'),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // Background color
          ),
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primary, // Background color
          ),
          child: Text('Yes',style: TextStyle(
            color: Colors.white
          ),),
          onPressed: ()async {
            // Add your logout functionality here
            // Navigator.of(context).pop(); // Dismiss the dialog
            //final prefs = await SharedPreferences.getInstance();
            //await prefs.clear(); // This removes all stored data
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(builder: (context) => LoginView()),
            // );
            _logout(context);

          },
        ),
      ],
    );
  }

}


// class DrawerContent extends StatefulWidget {
//   final name,mobileNo;
//
//   const DrawerContent({super.key, required this.name, required this.mobileNo});
//
//   @override
//   State<DrawerContent> createState() => _DrawerContentState();
// }
//
// class _DrawerContentState extends State<DrawerContent> {
//
//   // 🔹 Example state variables (future use)
//   bool isLoading = false;
//
//   AppPreferences _appPreferences = instance<AppPreferences>();
//   LocalDataSource _localDataSource = instance<LocalDataSource>();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   // 🔹 Example: Load data from preferences / API
//   void _loadUserData() async {
//
//     debugPrint('Drawer initState called');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           // ================= HEADER =================
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 32),
//             decoration: BoxDecoration(
//              //
//               // backgroundColor: ColorManager.primary,
//               color: ColorManager.primary
//
//               // gradient: LinearGradient(
//               //   colors: [
//               //     Color(0xFF1B5E20),
//               //     Color(0xFF2E7D32),
//               //     Color(0xFF81C784),
//               //   ],
//               //   begin: Alignment.topCenter,
//               //   end: Alignment.bottomCenter,
//               // ),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 3),
//                     image: const DecorationImage(
//                       image: AssetImage('assets/images/bg.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   '${widget.name}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.call, color: Colors.white, size: 16),
//                     const SizedBox(width: 10),
//                     Text(
//                       '${widget.mobileNo}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // ================= MENU ITEMS =================
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _drawerItem(
//                   icon: Icons.home_outlined,
//                   title: AppStrings.home.tr(),
//                   onTap: () {
//                     Navigator.pop(context);
//                     debugPrint('-- Home --');
//                   },
//                 ),
//                 _divider(),
//
//                 _drawerItem(
//                   icon: Icons.lock_outline,
//                   title: AppStrings.changePassword.tr(),
//                   iconColor: const Color(0xFFFBC02D),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 _divider(),
//
//                 _drawerItem(
//                   icon: Icons.notifications,
//                   title: AppStrings.notifications.tr(),
//                   iconColor: const Color(0xFFFBC02D),
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//
//                 const SizedBox(height: 8),
//                 _divider(),
//
//                 //Change Language
//                 _drawerItem(
//                   icon: Icons.language,
//                   title: AppStrings.changeLanguage.tr(),
//                   iconColor: const Color(0xFFFBC02D),
//                   onTap: () {
//                     _changeLanguage();
//                   },
//                 ),
//                 _divider(),
//                 // LOGOUT
//                 _drawerItem(
//                   icon: Icons.logout,
//                   title: AppStrings.logout.tr(),
//                   iconColor: Colors.redAccent,
//                   textColor: Colors.redAccent,
//                   onTap: () {
//                     //Navigator.pop(context);
//                     _logout();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ================= DRAWER ITEM =================
//   Widget _drawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color iconColor = const Color(0xFF2E7D32),
//     Color textColor = const Color(0xFF1B5E20),
//
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: iconColor),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w500,
//           color: textColor,
//         ),
//       ),
//       horizontalTitleGap: 8,
//       onTap: onTap,
//     );
//   }
//
//   // ================= DIVIDER =================
//   Widget _divider() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Divider(
//         thickness: 0.8,
//         height: 1,
//       ),
//     );
//   }
//
//   // ================= LOGOUT HANDLER =================
//   bool isRtl() {
//     return context.locale == ARABIC_LOCAL; // app is in arabic language
//   }
//
//   void _changeLanguage() {
//     // i will apply localisation later
//     _appPreferences.setLanguageChanged();
//     Phoenix.rebirth(context); // restart to apply language changes
//   }
//   // logout
//   void _logout() {
//       _appPreferences.logout(); // clear login flag from app prefs
//       _localDataSource.clearCache();
//       Navigator.pushReplacementNamed(context, Routes.loginRoute);
//   }
// }

