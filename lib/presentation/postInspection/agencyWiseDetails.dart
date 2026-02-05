import 'package:citizencentric/presentation/postInspection/reportBottomSheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../app/locationservice.dart';
import '../../data/repo/parklistwithagencyrepo.dart';
import '../../domain/model/parklistwithagencymodel.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/fullscreenimage.dart';
import '../fullScreenImage/FullScreenImageDialog.dart';
import '../inspectionList/lunch_Google_Map.dart';
import '../resources/strings_manager.dart';
import 'package:citizencentric/presentation/resources/color_manager.dart';
import '../commponent/CircleWithSpacing.dart';
import '../commponent/CommonShimmer.dart';
import '../commponent/platform_text.dart';
import '../nodatascreen/nodatascreen.dart';
import '../resources/text_type.dart';


class AgencyWiseDetails extends StatefulWidget {
  final iAgencyCode;
  const AgencyWiseDetails({super.key, required this.iAgencyCode});

  @override
  State<AgencyWiseDetails> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<AgencyWiseDetails> {

  List<dynamic> subCategoryList = [];
  List<dynamic> wardList = [];
  List<dynamic> sectorList = [];
  var dropDownSubCategory;
  var dropDownSector;
  var _dropDownWard, _selectedSubCategoryId;
  var selectedDropDownSectorCode;

  List<ParkListWithAgencyModel> pendingInternalComplaintList = [];
  List<ParkListWithAgencyModel> _filteredData = [];
  TextEditingController _searchController = TextEditingController();
  final distDropdownFocus = GlobalKey();
  bool isLoading = true;
  int _listRequestId = 0;
  //var item;
  List<Map<String, dynamic>>? item;
  double? lat,long;
  var agencyCode;

  // list of the color
  final List<Color> cardColors = [
    Color(0xFFCA7598),
    Color(0xFF9BC376),
    Color(0xFF64BAB0),
    Color(0xFFF6D195),
    Color(0xFF7DCCD7),
    Color(0xFFDB957F),
    Color(0xFF7CACDE),
    Color(0xFFC88BE2),
    Color(0xFFEBB072),
    Color(0xFF8BC2D0),
  ];




  // get a location
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
      });

      //lat = 28.60204;
      //long = 77.35637;
      // if(lat!=null && long!=null){
      //
      //  // _loadNearbyParks(lat!,long!);
      // }


    } catch (e) {
      debugPrint('❌ Location Error: $e');
    }
  }

  // ui widget
  Widget _actionItem(String title, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PlatformText(
              title,
              type: AppTextType.caption,
              maxLines: maxLines,      // 👈 allow wrapping
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _iosActionItem({
    double? width,
    required String title,
    required VoidCallback onTap,
    int maxLines = 1,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      splashColor: Colors.grey.withOpacity(0.15), // 👈 iOS-like
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
// divider
  Widget _divider() {
    return Container(
      height: 26,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  // build CardItem
  Widget buildCardItem(BuildContext context,  ParkListWithAgencyModel item, int index) {
    // bg color

    final Color bgColor = cardColors[index % cardColors.length];

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.fromLTRB(4, 4, 4, 4), // 👈 FIX 1
        clipBehavior: Clip.none, // 👈 FIX 2
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.grey, // 👈 YOUR BORDER COLOR
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 60, // 👈 minimum height
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: bgColor, width: 4),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                bottomLeft: Radius.circular(2),
              ),
              child: ListTile(
                dense: true,

                contentPadding: const EdgeInsets.only(
                  left: 12,
                  right: 0,
                ),

                title: PlatformText(
                  item.sParkName ?? '',
                  type: AppTextType.subtitle,
                  maxLines: 2, // 👈 optional safety
                  overflow: TextOverflow.ellipsis,
                ),

                subtitle: PlatformText(
                  "Worker - ${item.iNoOfWorkers ?? ""}",
                  type: AppTextType.caption,
                ),

                trailing: SizedBox(
                  width: 120,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Area : ${item.fArea ?? ""}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
              // SizedBox(height: 5),
              Divider(height: 1,
              color: ColorManager.grey,
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:0, right: 10, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 5),
                              CircleWithSpacing(),
                              PlatformText(
                                "Supervisor", //  AppStrings.powerd_by.tr(),
                                type: AppTextType.subtitle,
                              ),
                              //Text('Supervisor', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: PlatformText(
                              item.sSupervisor ?? "", // "Satish" ,//  AppStrings.powerd_by.tr(),
                              type: AppTextType.caption,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 5),
                              CircleWithSpacing(),
                              PlatformText(
                                "Deputy Director", //  AppStrings.powerd_by.tr(),
                                type: AppTextType.subtitle,
                              ),
                              //Text('Deputy Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: PlatformText(
                              item.sDuptyDirector ?? "",//"R.Singh", //  AppStrings.powerd_by.tr(),
                              type: AppTextType.caption,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      // height: 50,
                      //color: Colors.grey.shade300,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 8, // 90%
                            child: Container(
                              // color: Colors.blue.shade400,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: CircleWithSpacing(),
                                    ),
                                    SizedBox(width: 2),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        PlatformText(
                                          "Assistant Director", //  AppStrings.powerd_by.tr(),
                                          type: AppTextType.subtitle,
                                        ),
                                        PlatformText(
                                          item.sAssetDirector ?? "", //"Mukesh Kumar", //  AppStrings.powerd_by.tr(),
                                          type: AppTextType.caption,
                                        ),
                                      ],
                                    ),

                                    //Text('Assistant Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2, // 10%
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    final images = item.sParkPhoto;

                                    if (images != null && images.isNotEmpty) {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: "Close image preview", // ✅ REQUIRED
                                        barrierColor: Colors.black,
                                        transitionDuration: const Duration(milliseconds: 200),
                                        pageBuilder: (_, __, ___) {
                                          return FullScreenImageDialog(
                                            imageUrl: images,
                                          );
                                        },
                                      );
                                    }
                                  },
                                  // onTap: (){
                                  //   print("------373-----");
                                  //   var images =  "${item.sParkPhoto}";
                                  //   print(images);
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => FullScreenPage(sBeforePhoto: images),
                                  //     ),
                                  //   );
                                  // },
                                  child: Container(
                                    height: 50,
                                    width: 50,

                                    // width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade200,
                                    ),
                                    clipBehavior: Clip.antiAlias, // 👈 important for rounded corners
                                    child: Image.network(
                                      item.sParkPhoto , // 👈 your internet image URL
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(child: CircularProgressIndicator());
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(Icons.broken_image, size: 40),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )

                            // child: GestureDetector(
                            //   onTap: () {
                            //     print('---forward----click---');
                            //     // navigate to markGeotaggingFrom
                            //     //Navigator.pushNamed(context, '/markGeotaggingForm');
                            //     var parkName =  item.sParkName ?? '';
                            //     var parkId =  item.iParkId ?? '';
                            //
                            //     print("--parkname : $parkName");
                            //     print("---parkId--: $parkId");
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute<void>(
                            //         builder: (context) => ParkGeotaggingForm(parkName:parkName,parkId:parkId),
                            //       ),
                            //     );
                            //
                            //   },
                            //   child:ColoredBox(
                            //     color: Colors.white, // color: bgColor,
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(6),
                            //       child: Transform.rotate(
                            //         angle: 90 * 3.1415926535 / 180,
                            //         child: Image.asset(
                            //           'assets/images/forward.jpeg',
                            //           height: 20,
                            //           width: 20,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Director", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.subtitle,
                        ),
                        //Text('Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        item.sDirector ?? "" ,//"Director", //  AppStrings.powerd_by.tr(),
                        type: AppTextType.caption,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Agency Name", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.subtitle,
                          color: ColorManager.primary,
                        ),
                        //Text('Agency Name', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        item.sAgencyName?? "" ,//"M/S Green Star Nursery", //  AppStrings.powerd_by.tr(),
                        type: AppTextType.caption,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Google Location", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.subtitle,
                        ),
                        //Text('Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        (item.sGoogleLocation?.trim().isNotEmpty ?? false)
                            ? item.sGoogleLocation!
                            : 'Not Specified',
                        type: AppTextType.caption,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),

              Card(
                elevation: 0, // 👈 iOS prefers flat surfaces
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: Colors.grey.shade200, // 👈 soft border
                  ),
                ),
                child: Container(
                  height: 52,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06), // 👈 soft shadow
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// Navigation
                      Expanded(
                        child: _iosActionItem(
                          title: "Navigation",
                          onTap: () {
                            print("----xxxxxxxxxxx----navi---");
                           // final double lat = item.fLatitude;
                            //final double long = item.fLongitude;
                          // double lat = 28.60204;
                            //double long = 77.35637;
                            print("---lat---$lat");
                            print("---long---$long");

                            if (lat != 0.0 && long != 0.0) {
                              launchGoogleMaps(lat!, long!);
                            }
                          },
                        ),
                      ),

                      _divider(),

                      /// Post Inspection
                      Expanded(
                        child: _iosActionItem(
                          title: "Post Inspection",
                          onTap: () {
                            var iParkID = item.iParkId ?? "";
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => ReportBottomSheet(iParkID: iParkID),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> pendingInternalComplaintResponse(agencyCode) async {
    final int requestId = ++_listRequestId;

    setState(() => isLoading = true);

    final result = await ParkListWithAgencyRepo().parkListWithAgency(context,agencyCode);

    // 🔒 IGNORE OLD RESPONSE
    if (requestId != _listRequestId) return;

    if (result != null) {
      pendingInternalComplaintList = result;
      _filteredData = List.from(result);
      print("---376---ListData----: $pendingInternalComplaintList");
      print("Total parks count----558--: ${pendingInternalComplaintList.length}");
    } else {
      pendingInternalComplaintList = [];
      _filteredData = [];
    }

    setState(() => isLoading = false);
  }

  // search logic
  void searchPark() {
    final query = _searchController.text.toLowerCase();

    _filteredData = pendingInternalComplaintList.where((park) {
      return park.sParkName.toLowerCase().contains(query) ||
          park.sSupervisor.toLowerCase().contains(query) ||
          park.sAgencyName.toLowerCase().contains(query) ||
          park.sDuptyDirector.toLowerCase().contains(query) ||
          park.sAssetDirector.toLowerCase().contains(query) ||
          park.sDirector.toLowerCase().contains(query);
    }).toList();
    setState(() {});
  }

  // Select Division

  @override
  void initState() {
    // TODO: implement initState
    agencyCode = widget.iAgencyCode;
    pendingInternalComplaintResponse(agencyCode);
    _getUserLocation();
    _searchController.addListener(searchPark);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.removeListener(searchPark);
    _searchController.dispose();
    super.dispose();
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
            title: "Agency Wise Details" ,// title: AppStrings.parkGeotagging.tr(), // title: "Park Geotagging",
            showBack: true,
            onBackPressed: () {
              print("Back pressed");
              Navigator.pop(context);
            },
          ),
          body: Column(
            children: [
              // first of all take a container
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    //color: Colors.green,
                      color: const Color(0xFF6FB7AE),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                // color: ColorManager.primary,
               // color: const Color(0xFF6FB7AE),
                child: Center(
                    child: Text(
                      'Total no of parks : ${pendingInternalComplaintList?.length ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  )
                ),
              // SearchBar
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
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
                            autofocus: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              // hintText: 'Enter Keywords',
                              hintText: AppStrings.enterKeywords.tr(),
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
              // here list item start
              SizedBox(height: 5),
              /// todo heere you bind the list
              // at dynamic list you should remove this card content and uncomment below code to show
              // dynamic data
              Expanded(
                child: isLoading
                    ? CommonShimmerList()
                    : (pendingInternalComplaintList == null ||
                    pendingInternalComplaintList!.isEmpty)
                    ? NoDataScreenPage()
                    : Padding(
                  padding: const EdgeInsets.only(left: 8.0,top: 8.0,bottom: 8.0,right: 4.0),
                  child: ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      // final item = _filteredData[index];
                      final ParkListWithAgencyModel item = _filteredData[index];

                      return buildCardItem(context, item,index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
