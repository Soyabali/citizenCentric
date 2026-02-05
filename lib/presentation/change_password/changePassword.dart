import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repo/changepasswordrepo.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/generalFunction.dart';
import '../resources/app_text_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';


class ChangePassWordHome extends StatefulWidget {
  const ChangePassWordHome({super.key});

  @override
  State<ChangePassWordHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChangePassWordHome> {
  // Controller
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // Focus
  FocusNode oldPasswordfocus = FocusNode();
  FocusNode newPasswordfocus = FocusNode();
  FocusNode confirmPasswordfocus = FocusNode();
  GeneralFunction generalFunction = GeneralFunction();
  // formkey
  final _formKey = GlobalKey<FormState>();

  // bool _isObscured = true;
  bool _isObscuredoldPassword = true;
  bool _isObscuredNewPassword = true;
  bool _isObscuredConfirmPassword = true;
  var msg;
  var result;
  var loginMap;
  var  changePasswordRepo;
  String? sName, sContactNo;


  @override
  void initState() {
    // TODO: implement initState
    getlocalvalue();
    super.initState();
    oldPasswordfocus = FocusNode();
    newPasswordfocus = FocusNode();
    confirmPasswordfocus = FocusNode();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    oldPasswordfocus.dispose();
    newPasswordfocus.dispose();
    confirmPasswordfocus.dispose();
    super.dispose();

  }
  getlocalvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sName = prefs.getString('sName') ?? "";
      sContactNo = prefs.getString('sContactNo') ?? "";
      print("------148---$sName");
      print("------1149---$sContactNo");
    });
  }
   // On WilPopScope
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        content: new Text('Do you want to exit app',style: AppTextStyle
            .font14OpenSansRegularBlackTextStyle,),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
              //  goToHomePage();
              // exit the app
              exit(0);
            }, //Navigator.of(context).pop(true), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppCommonAppBar(
          title: "Change Password" , //title: AppStrings.parkGeotagging.tr(), // title: "Park Geotagging",
          showBack: true,
          onBackPressed: () {
            print("Back pressed");
            Navigator.pop(context);
          },
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Initializing Recovery !',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff3f617d),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Your password is safe with us.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff3f617d),
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 120.0),
                  Container(
                    //color: Colors.white,
                    height: 400,
                    decoration: BoxDecoration(
                      // Set container color
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20), // Set border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Center(
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    // border: Border.all(color: Colors.black),
                                    // Just for visualization
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white
                                            .withOpacity(0.5), // Set shadow color
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/change_password_nw.png'), // Set AssetImage
                                          fit: BoxFit
                                              .cover, // Adjust the image fit as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // form
                            GestureDetector(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                              },
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            autofocus: true,
                                            obscureText: _isObscuredoldPassword,
                                            controller: _oldPasswordController,
                                            focusNode: oldPasswordfocus,
                                            textInputAction: TextInputAction.next,
                                            onEditingComplete: () =>
                                                FocusScope.of(context).nextFocus(),
                                            decoration: InputDecoration(
                                              labelText: 'Old Password',
                                              labelStyle: TextStyle(color: Color(0xFFd97c51)),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(color:Color(0xFF255899))
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10, // Add horizontal padding
                                              ),
                                              prefixIcon:
                                              Icon(Icons.lock,size: 20, color: Color(0xFF255899)),
                                              suffixIcon: IconButton(
                                                icon: Icon(_isObscuredoldPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscuredoldPassword = !_isObscuredoldPassword;
                                                  });
                                                },
                                              ),
                                            ),
                                            autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter Old Password';
                                              }
                                              if (value.length < 1 ) {
                                                return 'Enter Old Password';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            obscureText: _isObscuredNewPassword,
                                            controller: _newPasswordController,
                                            focusNode: newPasswordfocus,
                                            textInputAction: TextInputAction.next,
                                            onEditingComplete: () =>
                                                FocusScope.of(context).nextFocus(),
                                            decoration: InputDecoration(
                                              labelText: 'New Password',
                                              labelStyle: const TextStyle(color: Color(0xFFd97c51)),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(color:Color(0xFF255899))
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10, // Add horizontal padding
                                              ),
                                              prefixIcon:
                                              Icon(Icons.lock,size: 20, color: Color(0xFF255899)),
                                              suffixIcon: IconButton(
                                                icon: Icon(_isObscuredNewPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscuredNewPassword = !_isObscuredNewPassword;
                                                  });
                                                },
                                              ),
                                            ),
                                            autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Enter new Password';
                                              }
                                              if (value.length < 1) {
                                                return 'Enter new Password';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            obscureText: _isObscuredConfirmPassword,
                                            controller: _confirmPasswordController,
                                            focusNode: confirmPasswordfocus,
                                            textInputAction: TextInputAction.next,
                                            onEditingComplete: () =>
                                                FocusScope.of(context).nextFocus(),
                                            decoration: InputDecoration(
                                              labelText: 'Confirm Password',
                                              labelStyle: const TextStyle(color: Color(0xFFd97c51)),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(color:Color(0xFF255899))
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10, // Add horizontal padding
                                              ),
                                              prefixIcon:
                                              Icon(Icons.lock,size: 20, color: Color(0xFF255899)),
                                              suffixIcon: IconButton(
                                                icon: Icon(_isObscuredConfirmPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                                                  });
                                                },
                                              ),
                                            ),
                                            autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Confirm Password';
                                              }
                                              if (value.length < 1 ) {
                                                return 'Confirm Password';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          // login
                                          InkWell(
                                            onTap: ()async {

                                              print('--------------');
                                              var oldpassword = _oldPasswordController.text;
                                              var newpassword = _newPasswordController.text;
                                              var confirmpassword = _confirmPasswordController.text;

                                              if(_formKey.currentState!.validate() &&
                                                  oldpassword.isNotEmpty &&
                                                  newpassword.isNotEmpty &&
                                                  confirmpassword.isNotEmpty ){

                                                if(newpassword!=confirmpassword){
                                                  displayToast("Password does not match");
                                                }
                                                else{
                                                  changePasswordRepo = await ChangePasswordRepo().changePassword(context, oldpassword, newpassword);
                                                    print('----479-----$changePasswordRepo');
                                                  result = "${changePasswordRepo['Result']}";
                                                  msg = "${changePasswordRepo['Msg']}";
                                                  print('----482-----$msg');

                                                }
                                              }else {
                                                if(_oldPasswordController.text.isEmpty){
                                                  oldPasswordfocus.requestFocus();
                                                }else if(_newPasswordController.text.isEmpty){
                                                  newPasswordfocus.requestFocus();
                                                }else if(_confirmPasswordController.text.isEmpty){
                                                  confirmPasswordfocus.requestFocus();
                                                }
                                              }
                                             // print('-----499---Not-Call Api-');
                                              if(result=="1"){
                                                displayToast(msg);
                                                Navigator.pushReplacementNamed(context, Routes.loginRoute);
                                              }else{
                                                displayToast(msg);
                                              }
                                              },
                                            child: Container(
                                              width: double.infinity,
                                              height: 45,
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: ColorManager.primary,
                                                borderRadius: BorderRadius.circular(45), // 👈 Stadium style
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
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
                      ),
                    ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  // dialog
  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER, // ✅ FIX
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
