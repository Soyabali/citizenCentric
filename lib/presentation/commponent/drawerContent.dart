
import 'package:citizencentric/presentation/resources/color_manager.dart';
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../data/data_source/local_data_source.dart';
import '../../data/repo/deleteaccountrepo.dart';
import '../change_password/changePassword.dart';
import '../login/login.dart';
import '../notification/notification.dart';
import '../resources/app_text_style.dart';
import '../resources/routes_manager.dart';
import '../riverpod/main_view_controller..dart';
import 'generalFunction.dart';

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
                // delete ACCOUNT
                _drawerItem(
                    icon: Icons.delete_forever,
                    title: "Delete Account",
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildDialogSucces(context);
                        },
                      );

                    },
                    // onTap: () {
                    //   // _logout(context);
                    //   // inputState.add(SuccessState('Login Sucess'));
                    //   showDialog(
                    //     context: context,
                    //     barrierDismissible: false, // Prevent closing by tapping outside
                    //     builder: (BuildContext context) {
                    //       return logoutDialogBox(context);
                    //     },
                    //   );
                    // }
                ),
                // GestureDetector(
                //   onTap: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return _buildDialogSucces(context);
                //       },
                //     );
                //
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: <Widget>[
                //       Image.asset(
                //         'assets/images/deleteaccount.png',
                //         width: 25,
                //         height: 25,
                //       ),
                //       const SizedBox(width: 10),
                //       Text(
                //         'Delete Account',
                //         style:
                //         AppTextStyle.font16penSansExtraboldBlackTextStyle,
                //       ),
                //     ],
                //   ),
                // ),

                // _drawerItem(
                //   icon: Icons.delete_forever,
                //   title: AppStrings.notifications.tr(),
                //   iconColor: const Color(0xFFFBC02D),
                //   onTap: () {
                //     //   NotificationPageHome
                //     //Navigator.pop(context);
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (_) => NotificationPageHome()),
                //     );
                //   },
                // ),

                // _drawerItem(
                //   icon: Icons.language,
                //   title: "Change Language",
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


Widget _buildDialogSucces(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 170,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Space for the image
              const Row(
                children: [
                  Icon(
                    Icons.error_outline, // Exclamation icon
                    color: Colors.red, // Color of the icon
                    size: 22, // Size of the icon
                  ),
                  SizedBox(width: 8), // Spacing between the icon and text
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 16, // Adjust font size
                      fontWeight: FontWeight.bold, // Make the text bold
                      color: Colors.black, // Text color
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded( // Wrap the text in Expanded to allow it to take available space and wrap
                child: Text(
                  "Are you sure you want to Delete Account?",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.left, // Align the text to the left
                  softWrap: true, // Allow text to wrap
                  maxLines: 2, // Set the maximum number of lines the text can take
                  overflow: TextOverflow.ellipsis, // Add ellipsis if the text exceeds the available space
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 35, // Reduced height to 35
                padding: EdgeInsets.symmetric(horizontal: 5), // Adjust padding as needed
                decoration: BoxDecoration(
                  color: Colors.white, // Container background color
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                  border: Border.all(color: Colors.grey), // Border color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          //generalFunction.logout(context);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          minimumSize: Size(0, 0), // Remove minimum size constraints
                          backgroundColor: Colors.white, // Button background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Button border radius
                          ),
                        ),
                        child: Text(
                          'No',
                          style: GoogleFonts.openSans(
                            color: Colors.red, // Text color for "Yes"
                            fontSize: 12, // Adjust font size to fit the container
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.grey, // Divider color
                      width: 20, // Space between buttons
                      thickness: 1, // Thickness of the divider
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: ()async {
                          // getLocation();
                          Navigator.pop(context);
                          print("----Call api delete the Account---");

                          var  deleteAccount = await DeleteAccountRepo().deleteAccount(context,"");
                          print("-----DeleteAccount------467--$deleteAccount");

                          var  result = "${deleteAccount['Result']}";
                          var msg = "${deleteAccount['Msg']}";


                          if(result=="1"){
                            // show dialog Account is deleted
                            // _buildDialogSucces2
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildDialogSucces2(context,msg);
                              },
                            );
                          }else{
                            displayToast(msg);
                            // show a msg api msg
                          }
                          // Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove default padding
                          minimumSize: Size(0, 0), // Remove minimum size constraints
                          backgroundColor: Colors.white, // Button background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Button border radius
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: GoogleFonts.openSans(
                            color: Colors.green, // Text color for "No"
                            fontSize: 12, // Adjust font size to fit the container
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ],
    ),
  );
}
// build Dialog sucess
Widget _buildDialogSucces2(BuildContext context,String msg) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 190,
          padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 0), // Space for the image
              Text(
                  'Success',
                  style: AppTextStyle.font16OpenSansRegularBlackTextStyle
              ),
              SizedBox(height: 10),
              Text(
                msg,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // navigate to LoginScreen

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginView()),
                            (Route<
                            dynamic> route) => false, // Condition to retain routes
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // Set the background color to white
                      foregroundColor: Colors
                          .black, // Set the text color to black
                    ),
                    child: Text('Ok', style: AppTextStyle
                        .font16OpenSansRegularBlackTextStyle),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: -30, // Position the image at the top center
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: ClipOval(
              child: Image.asset(
                'assets/images/sussess.jpeg',
                // Replace with your asset image path
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}