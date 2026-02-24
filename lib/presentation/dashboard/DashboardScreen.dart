import 'package:citizencentric/presentation/dashboard/parksonMap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../app/di.dart';
import '../../app/locationservice.dart';
import '../../data/repo/ParksonmapRepo.dart';
import '../../data/repo/bindAllDivisionRepo.dart';
import '../../domain/model/model.dart';
import '../../domain/model/parksonmapModel.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/platform_text.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/text_type.dart';
import 'CountDashboardViewModel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late CountDashboardViewModel _viewModel;

  List<dynamic> subCategoryList = [];
  List<dynamic> countDashBoradList = [];
  List<dynamic> wardList = [];
  List<dynamic> sectorList = [];
  var dropDownSubCategory;
  var dropDownSector;
  var _selectedSubCategoryId;
  var selectedDropDownSectorCode;
  TextEditingController _searchController = TextEditingController();

  String totalParks_2 = '';
  String totalGeotagged_2 = '';
  String totalInspection_2 = '';
  String totalResolvedInspection_2 = '';
  String iTotalReceviedAmt_2 = '';
  // iTotalInspectionAmt
  String iTotalInspectionAmt_2 = '';
  ParksonmapModel? _selectedSearchPark;
  ParkSonMapRepo repo = ParkSonMapRepo();

  List<ParksonmapModel> parksonList = [];
  List<ParksonmapModel> _filteredData = [];
  double? lat, long;
  final FocusNode _searchFocusNode = FocusNode();

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
      if (lat != null && long != null) {
        // _loadNearbyParks(lat!,long!);
      }
    } catch (e) {
      debugPrint('❌ Location Error: $e');
    }
  }

  Widget _dashboardItem({
    required Color bgColor,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // ✅ KEY
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // google Map api call
  Future<void> _loadNearbyParks(selectedSubCategoryId) async {
    final parks = await repo.parksonPark(context, selectedSubCategoryId);

    if (!mounted) return;

    setState(() {
       parksonList = parks;
      _filteredData = List.from(parks);
    });
    print("---136----parksonMap ---xxxxx---$parksonList");

    for (int i = 0; i < parksonList.length; i++) {
      debugPrint('--- Park [$i] ---');
      print("----:  141 : ${parksonList.length}");
      debugPrint(parksonList[i].toString());
    }
  }
  // searchFunction
  void searchPark() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredData = List.from(parksonList);
        _selectedSearchPark = null;
      });
      return;
    }

    final results = parksonList.where((park) {
      return park.parkName.toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredData = results;
      _selectedSearchPark = results.isNotEmpty ? results.first : null;
    });
  }

  //api call All Division
  bindSubCategory() async {
    final result = await SelectAllDivisionRepo().bindAllDivision(context);

    if (result != null) {
      subCategoryList = result;
      dropDownSubCategory = subCategoryList[0]['sDevisionName'];
      _selectedSubCategoryId = subCategoryList[0]['iDivisionCode'];
      print("----DivisonCODE----147--$_selectedSubCategoryId");
      if (_selectedSubCategoryId != null) {
        // call a api
        _loadNearbyParks(_selectedSubCategoryId);
      }
      setState(() {});
      print("----29--$subCategoryList");
    }
  }

  /// division divider
  Widget _bindSubCategory() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFf2f3f5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isDense: true,
                isExpanded: true,
                dropdownColor: Colors.white,
                value: dropDownSubCategory, // ✅ default selected
                onTap: () => FocusScope.of(context).unfocus(),
                onChanged: (newValue) {
                  if (newValue == null) return;

                  setState(() {
                    dropDownSubCategory = newValue;
                    // 🔴 Clear dependent dropdown
                    dropDownSector = null;
                    sectorList.clear();
                    selectedDropDownSectorCode = null;

                    final selectedItem = subCategoryList.firstWhere(
                      (e) => e['sDevisionName'] == newValue,
                    );
                    _selectedSubCategoryId = selectedItem['iDivisionCode'];
                    if (_selectedSubCategoryId != null) {
                      print("-----xxxxxxxxxxxxxxxxxxxx----xxxxxxx");
                      // here clear data in a list as aprove
                       parksonList.clear();
                      _filteredData.clear();
                      _loadNearbyParks(_selectedSubCategoryId);
                    }
                    // ✅ Print Division Code
                    // debugPrint("Selected Division Code: $_selectedSubCategoryId");
                  });
                },
                items: subCategoryList.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['sDevisionName'].toString(),
                    child: Text(
                      item['sDevisionName'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
  // streamBuilder function

  Widget _buildDashboard() {
    return StreamBuilder<CountDashboardModel>(
      stream: _viewModel.outputDashboard,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        totalParks_2 = data.iTotalParks.toString();
        // totalGeotagged_2
        totalGeotagged_2 = data.iTotalGeotagged.toString();
        // totalInspection_2
        totalInspection_2 = data.iTotalInspection.toString();
        // totalResolvedInspection_2
        totalResolvedInspection_2 = data.totalResolvedInspection.toString();
        iTotalReceviedAmt_2 = data.iTotalReceviedAmt.toString();
        iTotalInspectionAmt_2 = data.iTotalInspectionAmt.toString();
        //totalReceivedAmt
        // iTotalReceviedAmt
        return Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _viewModel = instance<CountDashboardViewModel>();
    _viewModel.start();
    bindSubCategory();
    _getUserLocation();
    _searchController.addListener(searchPark);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus(); // 👈 closes keyboard
    });

  }
  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.removeListener(searchPark);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonAppBar(
         title: AppStrings.dashboard.tr(), // title: "DashBoard",
        showBack: true,
        onBackPressed: () {
          print("Back pressed");
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDashboard(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Icon(Icons.star, size: 30, color: Colors.green),
                Image.asset(
                  'assets/images/ic_dashboard.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
                // PlatformText(
                //   "Penalty Received",
                //   type: AppTextType.title,
                //   color: Colors.black54,
                // ),
                SizedBox(width: 8),
                Text(
                  "Penalty Received",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14, // 👈 Better readability
                    fontWeight: FontWeight.w500, // 👈 iOS-friendly
                    height: 1.3, // 👈 Improves line spacing
                  ),
                ),
                Spacer(),
                Text(
                  "(₹ $iTotalReceviedAmt_2 / ₹ $iTotalInspectionAmt_2)",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14, // 👈 Better readability
                    fontWeight: FontWeight.w500, // 👈 iOS-friendly
                    height: 1.3, // 👈 Improves line spacing
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200, // ✅ TOTAL HEIGHT
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,

                // 🔥 CONTROLS EACH ITEM HEIGHT
                mainAxisExtent: 84,
              ),
              itemBuilder: (context, index) {
                final items = [
                  _dashboardItem(
                    bgColor: const Color(0xFFE3F2FD),
                    title: "Registered Park",
                    value: "$totalParks_2",
                  ),
                  _dashboardItem(
                    bgColor: const Color(0xFFF3E5F5),
                    title: "Geotagged Park",
                    value: "$totalGeotagged_2",
                  ),
                  _dashboardItem(
                    bgColor: const Color(0xFFFBE9E7),
                    title: "Inspection",
                    value: "$totalInspection_2",
                  ),
                  _dashboardItem(
                    bgColor: const Color(0xFFBCEAEB),
                    title: "Resolved Inspection",
                    value: "$totalResolvedInspection_2",
                  ),
                ];

                return items[index];
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
              top: 0.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Division", //AppStrings.selectDivision.tr(),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14, // 👈 Better readability
                    fontWeight: FontWeight.w500, // 👈 iOS-friendly
                    height: 1.3, // 👈 Improves line spacing
                  ),
                ),
                // take a container with rounded corner bg white
                SizedBox(height: 10),
                _bindSubCategory(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    ImageAssets.three_line,
                    height: 15,
                    width: 15,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  AppStrings.nearparklocation.tr(),
                  maxLines: 1, // ✅ prevents overflow
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600, // ✅ semi-bold for better readability
                  ),
                )
                // PlatformText(
                //   AppStrings.nearparklocation.tr(),
                //   type: AppTextType.subtitle,
                //   // color: ColorManager.primary,
                // ),
              ],
            ),
          ),
          // searchBar
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: TextFormField(
                  controller: _searchController,
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Search by Park Name", // hintText: AppStrings.enterKeywords.tr(),
                    hintStyle: const TextStyle(
                      color: Color(0xFF707D83),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    // 🚫 REMOVE ALL DEFAULT BORDERS
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Row Division from a GoogleMap.
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/park_yellow.png",
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                      // Icon(Icons.location_on_sharp,color: Colors.green,size: 30),
                      // Text("Division-1",style: TextStyle(
                      //     color: Colors.green,
                      //     fontSize: 14
                      // ),),
                      PlatformText(
                        "Division-1",
                        type: AppTextType.subtitle,
                        color: const Color(0xFFFFA000),
                        // color: ColorManager.primary,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Icon(Icons.location_on_sharp,color: Colors.red,size: 30),
                      Image.asset(
                        "assets/images/park_purpel.png",
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                      // Text("Division-1",style: TextStyle(
                      //     color: Colors.red,
                      //     fontSize: 14
                      // ),),
                      PlatformText(
                        "Division-2",
                        type: AppTextType.subtitle,
                        color: const Color(0xFFd93124),
                        // color: ColorManager.primary,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Icon(Icons.location_on_sharp,color: Colors.yellowAccent,size: 30),
                      Image.asset(
                        "assets/images/park_blue.png",
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                      PlatformText(
                        "Division-3",
                        type: AppTextType.subtitle,
                        color: const Color(0xFF3E5AFC),
                        // color: ColorManager.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // GoogleMap
          if (lat == null && long == null)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: ParkSonMap(
                parks: parksonList,
                selectedPark: _selectedSearchPark,
                onMapCreated: (controller) {},
              ),
            ),

        ],
      ),
    );
  }
}
