import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:citizencentric/presentation/parkGeotagging/parkGeotagging.dart';
import 'package:citizencentric/presentation/resources/color_manager.dart';
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/app_prefs.dart';
import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/loader_helper.dart';
import '../../data/repo/UpdateParkLocationRepo.dart';
import '../../data/repo/nearbyparklist.dart';
import '../../domain/model/park_model.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/platform_primary_button.dart';
import '../resources/app_text_style.dart';
import '../resources/platformButtonType.dart';
import '../resources/values_manager.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'AppCurrentLocationMap.dart';

class ParkGeotaggingForm extends StatefulWidget {

  final parkName, parkId;
  const ParkGeotaggingForm({
    super.key,
    required this.parkName,
    required this.parkId,
  });

  @override
  State<ParkGeotaggingForm> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<ParkGeotaggingForm> {

  bool isFormVisible = true; // Track the visibility of the form
  bool isIconRotated = false;
  bool isFormVisible2 = true; // Track the visibility of the form
  bool isIconRotated2 = false;
  bool isFormVisible3 = true; // Track the visibility of the form
  bool isIconRotated3 = false;
  bool isFormVisible4 = true; // Track the visibility of the form
  bool isIconRotated4 = false;
  bool isFirstFormVisible = true;
  bool isSecondFormVisible = true;
  bool isThirdFormVisible = true;

  bool isFirstIconRotated = false;
  bool isSecondIconRotated = false;
  bool isThirdIconRotated = false;
  late TextEditingController _searchController = TextEditingController(
    text: '${widget.parkName}',
  );
  double? lat, long;
  final NearByParkListRepo _repo = NearByParkListRepo();
  List<ParkModel> parkList = [];
  AppPreferences _appPreferences = instance<AppPreferences>();
  File? image;
  var uplodedImage;
  var locationAddress;
  String? dateText;
  List<dynamic> temperatureList = [];
  bool isLoading = false;
  String tempText = "";
  String description = "";
  final FocusNode _searchFocusNode = FocusNode();


  // get a Current Date  code
  String getCurrentFormattedDate() {
    final DateTime now = DateTime.now();

    final DateFormat formatter = DateFormat("dd/MMM/yyyy (EEE) hh:mm a");

    return formatter.format(now);
  }

  // to send image on a server
  Future<void> uploadImage(String token, File imageFile) async {
    try {
      showLoader();
      var baseURL = Constant.baseUrl;
      ;
      var endPoint = "PostImage/PostImage";
      var postImageApi = "$baseURL$endPoint";
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$postImageApi'));
      // Add headers
      request.headers['token'] = token;

      // Add the image file as a part of the request
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

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
      print('----145---$uplodedImage');
    } catch (error) {
      showLoader();
      print('Error uploading image: $error');
    }
  }

  Future<void> loadTemperature() async {
    var request = http.Request(
      'GET',
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=28.6016564&lon=77.3570279&appid=6956cabe579591ab4aa2869c08169147',
      ),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();

      final Map<String, dynamic> json = jsonDecode(res);

      description = (json['weather'] as List).isNotEmpty
          ? json['weather'][0]['description']
          : 'N/A';

      double tempKelvin = json['main']['temp'];
      double tempCelsius = tempKelvin - 273.15;
      tempText = "${tempCelsius.toStringAsFixed(1)} °C";
      setState(() {});

      print("Weather: $description");

      print("Temp: ${tempCelsius.toStringAsFixed(1)} °C");
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _loadNearbyParks(double? lat, double? long) async {
    print("90----lat : ${lat}");
    print("91-----long : ${long}");
    final parks = await _repo.nearByPark(
      context,
      lat!, // latitude
      long!, // longitude
    );

    setState(() {
      parkList = parks;
    });
    print("102-----parkList : ${parkList}");
  }

  // camra

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
        uploadImage(token, image!);
      } else {
        print('no image selected');
      }
    } catch (e) {}
  }

  // toast code
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

  @override
  void initState() {
    super.initState();
    getLocation();
    loadTemperature();
    dateText = getCurrentFormattedDate();
    print("-----155--$dateText");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus(); // 👈 closes keyboard
    });
  }

  // loccatin code
  void getLocation() async {
    //showLoader();
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //  hideLoader();
      displayToast(
        "Location services are disabled. Please enable them in settings.",
      );
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
        "Location permission permanently denied. Please enable it in app settings.",
      );
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
       // lat = position.latitude;
        //long = position.longitude;
        lat = double.parse(position.latitude.toStringAsFixed(8));
        long = double.parse(position.longitude.toStringAsFixed(8));
        locationAddress = address;
      });
      if (lat != null && long != null) {
        _loadNearbyParks(lat, long);
        // TO SEE A GOOGLE MAP
        AppCurrentLocationMap(
          latitude: lat!,
          longitude: long!,
          address: locationAddress ?? '',
          onLocationChanged: (newLat, newLng, newAddress) {
            setState(() {
              lat = newLat;
              long = newLng;
              locationAddress = newAddress;
            });

            debugPrint("📍 Updated Lat: $newLat");
            debugPrint("📍 Updated Lng: $newLng");
            debugPrint("📍 Address: $newAddress");
          },
        );
      }

      print('Address: $locationAddress');
      print('Latitude: $lat');
      print('Longitude: $long');

      if (lat != null && long != null) {
        // hideLoader();
        print('---------210----$lat');
        print('---------211----$long');
        // call a distance metrics.
        /// TODO HERE YOU SHOULD NOT CALL A ATTENDACE API YOU SHOULD CAL THIS API
        /// ON A SUBMIT BUTTON
        // attendaceapi(lat, long, locationAddress);
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

  @override
  void dispose() {
    // TODO: implement dispose
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isVisible,
    required bool isIconRotated,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        //color: ColorManager.primary,
        color: Color(0xFF96DFE8), // Custom background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
          ),
          IconButton(
            icon: AnimatedRotation(
              turns: isIconRotated ? 0.5 : 0.0, // Rotates the icon
              duration: Duration(milliseconds: 300),
              child: const Icon(Icons.arrow_drop_down, color: Colors.black),
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppCommonAppBar(
            title: AppStrings.parkGeotagging.tr(), // title: "Park Geotagging",
            showBack: true,
            onBackPressed: () {
              print("Back pressed");
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                // first of all take a container
                // Divider(height: 1),
                Container(
                  height: 60,
                  // color: ColorManager.primary,
                  color: const Color(0xFF6FB7AE),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // to apply here a class
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 0,
                              bottom: 5,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: Colors.grey, // Outline border color
                                  width: 0.2, // Outline border width
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _searchController,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF707d83),
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        border: InputBorder.none,
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
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      _buildSectionHeader(
                        title: "1. Geotagging Loacation",
                        isVisible: isFirstFormVisible,
                        isIconRotated: isFirstIconRotated,
                        onToggle: () {
                          setState(() {
                            isFirstFormVisible = !isFirstFormVisible;
                            isFirstIconRotated = !isFirstIconRotated;
                          });
                        },
                      ),
                      // First Form Content
                      if (isFirstFormVisible) _buildFirstForm(),
                      // Second Section Header
                      _buildSectionHeader(
                        title: "2. Upload Photo",
                        isVisible: isSecondFormVisible,
                        isIconRotated: isSecondIconRotated,
                        onToggle: () {
                          setState(() {
                            isSecondFormVisible = !isSecondFormVisible;
                            isSecondIconRotated = !isSecondIconRotated;
                          });
                        },
                      ),
                      // Second Form Content
                      if (isSecondFormVisible) _buildSecondForm(),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 15,
                          left: 15,
                          right: 15,
                        ),
                        child: PlatformPrimaryButton(
                          //label: AppStrings.login.tr(),
                          label: 'Submit',
                          height: AppSize.s40,
                          // buttonType
                          buttonType: PlatformButtonType.stadium,
                          backgroundColor: ColorManager.primary,
                          onPressed: () async {
                            // to pick a iUserId  from a login

                            final userData = await _appPreferences
                                .getLoginUserData();
                            //  "iUserId":"${userData?['userId']}",
                            var useriD = "${userData?['userId']}";
                            // here first of all you collect the required data
                            // _searchController
                            String parkName = _searchController.text.trim();
                            // parkId
                            var parkId = widget.parkId;
                            print("-----443--IparkId : $parkId");
                            print("-----444--fLatitude : $lat");
                            print("-----444--fLongitude : $long");
                            print(
                              "-----444--sGoogleLocation : $locationAddress",
                            );
                            print("-----444--parkPhoto : $uplodedImage");
                            print("-----444--parsLocUpdatedBykPhoto : $useriD");
                            print("-----444--sParkName : $parkName");
                            if (uplodedImage != null && uplodedImage != '') {
                              // Call api
                              print("----Call Api---");
                              final result = await UpdateParkLocationRepo()
                                  .updatePark(
                                    context,
                                    parkId,
                                    lat,
                                    long,
                                    locationAddress,
                                    uplodedImage,
                                    useriD,
                                    parkName,
                                  );
                              print("---result:= $result");
                              var res = result![0]['Result'];
                              var msg = result[0]['Msg'];

                              // to apply again condition
                              if (res == "1") {
                                displayToast(msg);
                                print(
                                  '---give a display msg- And go home page-',
                                );
                                print(msg);
                                if (Navigator.canPop(context)) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ParkGeotagging(),
                                    ),
                                  );
                                }
                              } else {
                              }
                            } else {
                              displayToast("Please select a image");
                            }
                          },
                        ),
                      ),
                      // SearchBar
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// widget
  Widget _buildFirstForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (lat != null && long != null) {
                  return AppCurrentLocationMap(
                    latitude: lat!,
                    longitude: long!,
                    address: locationAddress ?? '',
                    onLocationChanged: (newLat, newLng, newAddress) {
                      setState(() {
                        // lat = newLat;
                        // long = newLng;
                        lat = double.parse(newLat.toStringAsFixed(8));
                        long = double.parse(newLng.toStringAsFixed(8));
                        locationAddress = newAddress;
                      });

                      debugPrint("📍 Updated Lat: $newLat");
                      debugPrint("📍 Updated Lng: $newLng");
                      debugPrint("📍 Address: $newAddress");
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 2, top: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ic_location_good.png',
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                            ),
                            // Icon(Icons.location_disabled_rounded,
                            //     color: Colors.red, size: 30),
                            const SizedBox(width: 4),
                            //  dateText ?? "",
                            Expanded(
                              child: Text(
                                locationAddress ?? "",
                                maxLines: 3,
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Text(
                            "Lat: $lat  Long: $long",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/due_date.png',
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                            ),
                            // Icon(Icons.calendar_month,
                            //     size: 22, color: Colors.red),
                            SizedBox(width: 4),
                            Text(
                              dateText ?? "",
                              softWrap: true,
                              maxLines: null, // allows unlimited lines
                              overflow: TextOverflow.visible,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4B9C91), Color(0xFF6FB8AE)],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         // CircleAvatar(radius: 15, backgroundColor: Colors.red),
                          Image.network(
                            'https://openweathermap.org/img/wn/01d.png',
                            width: 50,
                            height: 50,
                          ),

                          Text(
                            tempText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 10),
      child: GestureDetector(
        onTap: () {
          if (image == null) {
            pickImage();
          }
        },
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: image == null ? _cameraPlaceholder() : _selectedImageView(),
        ),
      ),
    );
  }

  Widget _cameraPlaceholder() {
    return Center(
      child: Image.asset(
        'assets/images/ic_camera.PNG',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _selectedImageView() {
    return Stack(
      children: [
        Positioned.fill(child: Image.file(image!, fit: BoxFit.cover)),

        // ❌ Close Button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                image = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
