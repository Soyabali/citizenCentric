
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../data/repo/PostInspectionRepo.dart';
import '../../data/repo/reportType.dart';
import '../commponent/platform_primary_button.dart';
import '../commponent/platform_text.dart';
import '../homepage/homepage.dart';
import '../resources/app_text_style.dart';
import '../resources/color_manager.dart';
import '../resources/platformButtonType.dart';
import '../resources/text_type.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../resources/values_manager.dart';

class ReportBottomSheet extends StatefulWidget {
  final iParkID;
  const ReportBottomSheet({super.key, required this.iParkID});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {

  List<dynamic> subCategoryList = [];
  String? selectedReport;
  final TextEditingController descriptionController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  var uplodedImage;
  File? image;
  double? lat, long;
  var locationAddress;
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> reportTypes = [
    'Short Worker Found',
    'Illegal Parking',
    'Damage Property',
    'Other',
  ];

  var dropDownSubCategory;
  var dropDownSector;
  var _dropDownWard, _selectedSubCategoryId;
  var selectedDropDownSectorCode;

  bindSubCategory() async {
    final result = await ReportTypeRepo().reportType(context);

    if (result != null) {
      subCategoryList = result;
      print("----34----xxxxxxx-----$subCategoryList");

      // call a bindSector Api
    } else {
      subCategoryList = []; // fallback empty list
      debugPrint("ReportType  list is null");
    }

    setState(() {});
  }
  // imagepicker code
  Future pickImage() async {

    // here get a toke
    AppPreferences _appPreferences = instance<AppPreferences>();
    final token = await _appPreferences.getUserToken();


    try {
      final pickFileid = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 65,
      );
      if (pickFileid != null) {
        image = File(pickFileid.path);
        setState(() {});
        print('Image File path Id Proof-------135----->$image');
        // multipartProdecudre();
        /// todo here you open a api and pass a image to api
        uploadImage(token!, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }
  // image Uplodae code
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      var baseURL = Constant.baseUrl;;
      var endPoint = "PostImage/PostImage";
      var postImageApi = "$baseURL$endPoint";
      // Create a multipart request
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('$postImageApi'));
      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(await http.MultipartFile.fromPath(
        'file', imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Parse the response JSON
      var responseData = json.decode(response.body);

      // Print the response data
      print(responseData);
      hideLoader();
      print('---------172---$responseData');
      uplodedImage = "${responseData['Data'][0]['sImagePath']}";
      print('----119---$uplodedImage');
      setState(() {

      });
    } catch (error) {
      showLoader();
      print('Error uploading image: $error');
    }
  }



  // default Camra ui
  Widget _defaultCameraUI() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// 🔹 Left Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                PlatformText(
                  "Click Photo",
                  type: AppTextType.subtitle,
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Expanded(
                      child: PlatformText(
                        "Please click here to take a photo",
                        type: AppTextType.caption,
                        color: Colors.redAccent,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// 🔹 Camera Icon
          GestureDetector(
            onTap: pickImage,
            child: Image.asset(
              'assets/images/ic_camera.PNG',
              height: 42,
              width: 42,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
  // Selected image ui
  Widget _selectedImageUI() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Stack(
        alignment: Alignment.topRight,
        children: [

          /// 📸 Image Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              uplodedImage!,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// ❌ Remove Image Button
          GestureDetector(
            onTap: () {
              setState(() {
                uplodedImage = null; // 👈 Clear image
              });
            },
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }



  // here is dropdown code
  Widget _bindReportType()
  {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: const Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isDense: true,
                isExpanded: true,
                dropdownColor: Colors.white,
                hint: const Text(
                  "Select Report Type",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                value: dropDownSubCategory, // ✅ MUST NOT BE NULL
                onTap: () => FocusScope.of(context).unfocus(),
                onChanged: (newValue) {
                  setState(() {
                    dropDownSubCategory = newValue;

                    // 🔴 CLEAR DEPENDENT STATE
                    // dropDownSector = null;
                    // sectorList.clear();
                    // selectedDropDownSectorCode = null;

                    // 🔴 CLEAR LIST IMMEDIATELY
                    // pendingInternalComplaintList.clear();
                    // _filteredData.clear();
                  //  isLoading = true;

                    for (var element in subCategoryList) {
                      if (element["sReportType"] == newValue) {
                        _selectedSubCategoryId = element['iReportTypeCode'];

                        print("------88---$_selectedSubCategoryId");

                        if (_selectedSubCategoryId != null) {
                        //  bindBindSector(_selectedSubCategoryId);
                        }
                        break;
                      }
                    }
                  });
                },
                items: subCategoryList.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item["sReportType"].toString(),
                    child: Text(
                      item['sReportType'].toString(),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
 // displaytoast

  void displayToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // currentLocation and address
  void getLocation() async {
    //showLoader();
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //  hideLoader();
      displayToast(
          "Location services are disabled. Please enable them in settings.");
      // AppSettings.openLocationSettings(); // Redirect to location settings
      AppSettings.openAppSettings(); // on ios to open a settongs
      return;
    }
    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // hideLoader();
        displayToast("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // hideLoader();
      displayToast(
          "Location permission permanently denied. Please enable it in app settings.");
      AppSettings.openAppSettings(); // Redirect to app settings
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      String address =
          "${place.street}, ${place.subLocality},${place.locality},${place.administrativeArea},${place.postalCode},${place.country}";

      // String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        lat = position.latitude;
        long = position.longitude;
        locationAddress = address;
      });
      if(lat!=null && long!=null){

      }

      print('Address: $locationAddress');
      print('Latitude: $lat');
      print('Longitude: $long');

      if (lat != null && long != null) {
      } else {
        displayToast("Please select your location to proceed.");
      }
    } catch (e) {
      // hideLoader();
      displayToast("Failed to get location: $e");
    } finally {
      //hideLoader();
    }
  }
  // to generate 10 digit Number
  String generateDDHHmmssSS() {
    final now = DateTime.now();

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final dd = twoDigits(now.day);
    final HH = twoDigits(now.hour);
    final mm = twoDigits(now.minute);
    final ss = twoDigits(now.second);
    final SS = twoDigits(now.millisecond ~/ 10); // 2-digit millis

    return '$dd$HH$mm$ss$SS';
  }


  @override
  void initState() {
    // TODO: implement initState
    bindSubCategory();
    getLocation();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus(); // 👈 closes keyboard
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Drag Handle
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                /// 🔹 GIF Header
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/forward_complaint.gif',   // 👈 your gif
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),
                /// 🔹 Report Type
                //_label("Report Type"),
                PlatformText(
                  "Report Type " ,  // AppStrings.selectDivision.tr(), //"Select Division" ,//  AppStrings.powerd_by.tr(),
                  type: AppTextType.subtitle,
                  color: ColorManager.black,
                ),
                SizedBox(height: 5),

                // DropDownButton
                _bindReportType(),
                const SizedBox(height: 16),
                /// 🔹 Description
                //_label("Description"),
                PlatformText(
                  "Description" ,  // AppStrings.selectDivision.tr(), //"Select Division" ,//  AppStrings.powerd_by.tr(),
                  type: AppTextType.subtitle,
                  color: ColorManager.black,
                ),
                SizedBox(height: 5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // 👈 Bottom border color
                            width: 1.2,         // 👈 Visible thickness
                          ),
                        ),
                      ),
                      child: TextFormField(
                        controller: _searchController,
                        autofocus: false,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          hintText: 'Enter Keywords',
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF707d83),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none, // 👈 Important
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                /// 🔹 Upload Photo
               // _label("Upload Photo"),
                PlatformText(
                  "Upload Photo" ,  // AppStrings.selectDivision.tr(), //"Select Division" ,//  AppStrings.powerd_by.tr(),
                  type: AppTextType.subtitle,
                  color: ColorManager.black,
                ),

                SizedBox(height: 5),

                 Card(
                   color: Colors.white,
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // 📸 open camera
                  },
                  child: uplodedImage == null
                      ? _defaultCameraUI()
                      : _selectedImageUI(),

                                ),
                              ),

               const SizedBox(height: 30),
               PlatformPrimaryButton(
               label: "Submit",  //label: AppStrings.login.tr(),
              height: AppSize.s40,
             // color bg
             backgroundColor: ColorManager.primary,
            // buttonType
            buttonType: PlatformButtonType.stadium,
            onPressed: () async {

              AppPreferences _appPreferences = instance<AppPreferences>();
              final userData = await _appPreferences.getLoginUserData();
              var iInspBy = userData?['userId'];

              var descriotion =  _searchController.text.trim();
              print("---57----sDescription--$descriotion");
              print("-----553---iReportTypeCode--$_selectedSubCategoryId");
              print("---sPhoto---$uplodedImage");
              print("-----666---$lat");
              print("-----667---$long");
              print("-----668---$locationAddress");
              print("---ParkID--${widget.iParkID}");
              final iTranNo = generateDDHHmmssSS();
              print("ItrainNo: --$iTranNo");
              print("----UserID----$iInspBy");
             // print("----ParkID---${widget.iParkID}");
             // print("----parkId--${widget.iParkID}");
              var iparkID = widget.iParkID;
              var iReportTypeCode = _selectedSubCategoryId;
              // to apply va validation
              if(_selectedSubCategoryId==null){
                displayToast("Please select Report Type");

              }else if(uplodedImage==null){
                displayToast("Please select Upload Photo");
              }else{
                // Api call
                print("----Call Api---");

                final result = await PostInspectionRepo().postInspection(
                    context,
                    iTranNo,
                    iparkID,
                   _selectedSubCategoryId,
                    descriotion,
                    lat,
                    long,
                    locationAddress,
                    uplodedImage,
                    iInspBy
                );
                print("---result:= $result");
                var res = result![0]['Result'];
                var msg = result![0]['Msg'];
                print("-----722---$res");
                print("-----723---$msg");
                if(res=="1"){
                  displayToast(msg);
                  print('---give a display msg- And go home page-');
                  print(msg);

                  // if (Navigator.canPop(context)) {
                  //   Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );


                  }else{
                    print(msg);
                  }
                }

              }
               )],
            ),
          ),
        );
      },
    );
  }

  /// 🔹 Label Widget
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: PlatformText(
        "Report Type " ,  // AppStrings.selectDivision.tr(), //"Select Division" ,//  AppStrings.powerd_by.tr(),
        type: AppTextType.title,
      ),
    );
  }

  /// 🔹 Common Input Decoration
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
