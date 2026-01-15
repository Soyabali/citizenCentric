import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import 'changePassword.dart';
import 'gnidaofficers/gnoidadashboard.dart';
import 'gnidaofficers/supervisorDashboard/supervisiorDashboard.dart';
import 'holdComplaints.dart';
import 'homeScreen.dart';
import 'homepagesecod.dart';
import 'loginScreen_2.dart';
import 'mypoint.dart';
import 'notification.dart';

class GeneralFunction {
  void logout(BuildContext context)async {
       /// TODO LOGOUT CODE
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("iUserId");
    prefs.remove("sName");
    prefs.remove("sContactNo");
    prefs.remove("sDesgName");
    prefs.remove("iDesgCode");
    prefs.remove("iDeptCode");
    prefs.remove("iUserTypeCode");
    prefs.remove("sToken");
    prefs.remove("dLastLoginAt");
    //displayToastlogout();
    goNext(context);
  }

  goNext(BuildContext context) {

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen_2()),
          (Route<dynamic> route) => false, // This ensures all previous routes are removed
    );
  }
  // mobile back hale code
  //-----------logoutDialogBox ---------.

  Widget _logoutDialog(BuildContext context) {
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
            height: 160,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0), // Space for the image
                Text(
                    'Logout',
                    style: AppTextStyle.font16OpenSansRegularBlackTextStyle
                ),
                SizedBox(height: 10),
                Text(
                  "Do you want to Logout ?",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                  height: 35,
                  // Reduced height to 35
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  // Adjust padding as needed
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
                           // generalFunction.logout(context);
                            logout(context);
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.openSans(
                              color: Colors.green,
                              // Text color for "Yes"
                              fontSize: 12,
                              // Adjust font size to fit the container
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // Remove default padding
                            minimumSize: Size(0, 0),
                            // Remove minimum size constraints
                            backgroundColor: Colors.white,
                            // Button background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text(
                            'No',
                            style: GoogleFonts.openSans(
                              color: Colors.red,
                              // Text color for "No"
                              fontSize: 12,
                              // Adjust font size to fit the container
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
          Positioned(
            top: -30, // Position the image at the top center
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueAccent,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logoutnew.jpeg',
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



  // drawerFunction
  drawerFunction(BuildContext context, String sName, String sContactNo) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/drawerimage.jpeg'), // Replace with your asset image path
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sName,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.call,
                      size: 18,
                      color: Colors.black,
                    ),

                    SizedBox(width: 5),
                    Text(
                      sContactNo,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // here you get a user id from a sharedPreferece
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                    var  iUserTypeCode = prefs.getString('iUserTypeCode').toString();

                    if(iUserTypeCode=="6"){
                      print('-----ALi---home-------');
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const HomePage(),
                      //   ),
                      // );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GnoidaOfficersHome()),
                      );
                    }else if(iUserTypeCode=="1"){
                      print('-----Yadav ---home-------');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SupervisiorDashBoard()),
                      );

                    }else{
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen_2()),
                      );
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SupervisiorDashBoard()),
                      // );
                    }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/home_nw.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Home',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyPointPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/my_wallet.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'My Points',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HoldComplaint(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/holdicon.jpeg',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Hold Complaints',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassWordHome(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/change_password_nw.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Change Password',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPageHome(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/notification.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Notification',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                     // _showBottomSheet(context);
                     // logout(context);

                      /// todo her you should open DialogBox and take a actio
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _logoutDialog(context);
                        },
                      );

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logout_new.png',
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff3f617d),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.0,left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text('Synergy Telematics Pvt.Ltd.',style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xffF37339),//#F37339
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),),
                    const SizedBox(width: 0),
                    Padding(
                      padding: EdgeInsets.only(right: AppSize.s10),
                      child: Container(
                        margin: EdgeInsets.all(AppSize.s10),
                        child: Image.asset(
                          ImageAssets.favicon,
                          //width: AppSize.s50,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void displayToastlogout(){
    showToast(
      "Someone else has been login with your number.",
      duration: const Duration(seconds: 1),
      position: ToastPosition.center,
      backgroundColor: Colors.red,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
    // Fluttertoast.showToast(
    //     msg: "Someone else has been login with your number.",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
  }

   Future<void> launchGoogleMaps(double laititude,double longitude) async {
     double destinationLatitude= laititude;
     double destinationLongitude = longitude;
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {
          'q': '$destinationLatitude, $destinationLongitude'
        });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }
    //
    appbarFunction(String title){
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
      // Status bar color
      statusBarColor: Colors.blue,
      // Status bar brightness (optional)
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      backgroundColor: Color(0xFF255899),  //   0xFF255899    //    0xFF3A6090
      title: Text(
      '$title',
      style: TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold),
      ),
      );
    }
    //
    appbarback(BuildContext context,String title){
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.blue,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      backgroundColor: Color(0xFF255899),
      leading: GestureDetector(
          onTap: () {
            //Navigator.pop(context);
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const HomePage()));

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
            //Navigator.pop(context);
          },
          child:Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios),
          )),
      title:Text(
        '$title',
        style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      ),
    );

    }

}