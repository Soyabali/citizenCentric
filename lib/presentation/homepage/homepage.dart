
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../app/locationservice.dart';
import '../../data/repo/nearbyparklist.dart';
import '../../domain/model/park_model.dart';
import '../commponent/app_list_card.dart';
import '../commponent/app_list_tile.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/drawerContent.dart';
import '../commponent/generalFunction.dart';
import '../dashboard/DashboardScreen.dart';
import '../inspectionList/inspectionList.dart';
import '../parkGeotagging/parkGeotagging.dart';
import '../postInspection/postInspection.dart';
import '../resources/assets_manager.dart';
import 'appGoogleMap.dart';
import 'homeHeaderStack.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _GnoidaOfficersHomeState();
}

class _GnoidaOfficersHomeState extends State<Homepage> {
  //GeneralFunction generalFunction = GeneralFunction();

  late GoogleMapController mapController;

  final NearByParkListRepo _repo = NearByParkListRepo();
  List<ParkModel> parkList = [];

  var sName, sContactNo;
  List userModuleRightList = [];
  GeneralFunction? generalFunction;
  double? lat,long;
  var userName,userContactNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLocation();
    getLogindata();
  }

  // location code

  Future<void> _getUserLocation() async {
    try {
      Position position = await LocationService.getCurrentLocation();

      debugPrint('📍 Latitude  : ${position.latitude}');
      debugPrint('📍 Longitude : ${position.longitude}');
      /// todo to test on a emulator i put a static latitud and longitude
      /// on a run time you should pass as a dynamic latitude and longitude
      ///
      setState(() {
         lat = position.latitude;
         long = position.longitude;

        //lat = 28.60204;
        //long = 77.35637;
      });

      //lat = 28.60204;
      //long = 77.35637;
      if(lat!=null && long!=null){

        _loadNearbyParks(lat!,long!);
      }


    } catch (e) {
      debugPrint('❌ Location Error: $e');
    }
  }

  Future<void> _loadNearbyParks(double lat, double long) async {
    final parks = await _repo.nearByPark(
      context,
      lat,
      long,
    );
    if (!mounted) return;

    setState(() {
      parkList = parks;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getLogindata() async {
    AppPreferences _appPreferences = instance<AppPreferences>();
    // get a login data
    final userData = await _appPreferences.getLoginUserData();
    setState(() {
      userName = userData!['name'];
      userContactNo = userData['contactNo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor
      backgroundColor: Colors.white,
      // AppBar
      appBar: AppCommonAppBar(title: AppStrings.noidapark.tr()),
      // drawer
      drawer: DrawerContent(name:userName,mobileNo:userContactNo),
      // body
      body: Column(
        children: [
          // header part
          HomeHeaderStack(
            onDashboardTap: () {
              debugPrint('--- Dashboard Clicked ---');
              // Example navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DashboardScreen()),
              );
            },
            onPostInspectionTap: () {
              debugPrint('--- Post Inspection Clicked ---');

              // Example navigation   InspectionList
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PostInspection()),
              );
            },
          ),
          // list part
          // listTile(),
          Center(
            child: AppListCard(
              children: [
                AppListTile(
                  title: AppStrings.parkGeotagging.tr(),
                  assetImage: ImageAssets.parklocation,
                  onTap: () {
                    debugPrint('Park Geotagging clicked');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ParkGeotagging()),
                    );
                    },
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                AppListTile(
                  title: AppStrings.inspectionList.tr(),
                  assetImage: ImageAssets.parkgeo,
                  onTap: () {
                   // debugPrint('Inspection List clicked');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => InspectionList()),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          // heading as a map
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    ImageAssets.three_line,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Text(AppStrings.nearparklocation.tr(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

         if(lat==null && long==null)
           Expanded(
             child: Center(
               child: CircularProgressIndicator(),
             ),
           )
          else
          Expanded(child:  AppGoogleMap(
            parks: parkList,
            currentLocation: LatLng(lat!, long!),
            onMapCreated: (controller) {},
          ))
        ],
      ),
    );
  }
}
