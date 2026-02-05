import 'package:citizencentric/presentation/resources/color_manager.dart';
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repo/parkListForLocationUpdationRepo.dart';
import '../../data/repo/sector_repo.dart';
import '../../data/repo/selectdivision_repo.dart';
import '../../domain/model/parklistmodel.dart';
import '../commponent/CircleWithSpacing.dart';
import '../commponent/CommonShimmer.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/platform_text.dart';
import '../nodatascreen/nodatascreen.dart';
import '../resources/app_text_style.dart';
import '../resources/text_type.dart';

class ParkInspectionList extends StatefulWidget {
  const ParkInspectionList({super.key});

  @override
  State<ParkInspectionList> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<ParkInspectionList> {

  List<dynamic> subCategoryList = [];
  List<dynamic> wardList = [];
  List<dynamic> sectorList = [];
  var dropDownSubCategory;
  var dropDownSector;
  var _selectedSubCategoryId;
  var selectedDropDownSectorCode;

  List<ParkListModel> pendingInternalComplaintList = [];
  List<ParkListModel> _filteredData = [];
  TextEditingController _searchController = TextEditingController();
  final distDropdownFocus = GlobalKey();
  bool isLoading = true;
  int _listRequestId = 0;
  //var item;
  List<Map<String, dynamic>>? item;

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


  // build CardItem
  Widget buildCardItem(BuildContext context,  ParkListModel item, int index) {
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
                  height: 60,
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
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    child: ListTile(
                      dense: true,

                      // 🔥 MOST IMPORTANT LINE
                      contentPadding: const EdgeInsets.only(
                        left: 12,
                        right: 0, // 👈 removes right gap completely
                      ),

                      title: PlatformText(
                        item.sParkName,
                        type: AppTextType.subtitle,
                      ),

                      subtitle: PlatformText(
                        "Worker - ${item.iNoOfWorkers}",
                        type: AppTextType.caption,
                      ),

                      trailing: SizedBox(
                        width: 120,
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Area : ${item.fArea}',
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
              SizedBox(height: 5),
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
                        item.sSupervisor, // "Satish" ,//  AppStrings.powerd_by.tr(),
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
                        item.sDuptyDirector,//"R.Singh", //  AppStrings.powerd_by.tr(),
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
                      flex: 9, // 90%
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
                                    item.sAssetDirector, //"Mukesh Kumar", //  AppStrings.powerd_by.tr(),
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
                      flex: 1, // 10%
                      child: GestureDetector(
                        onTap: () {

                          },
                        child:ColoredBox(
                          color: Colors.white, // color: bgColor,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Transform.rotate(
                              angle: 90 * 3.1415926535 / 180,
                              child: Image.asset(
                                'assets/images/forward.jpeg',
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: PlatformText(
                  item.sDirector,  //"Director", //  AppStrings.powerd_by.tr(),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: PlatformText(
                  item.sAgencyName,//"M/S Green Star Nursery", //  AppStrings.powerd_by.tr(),
                  type: AppTextType.caption,
                  color: ColorManager.primary,
                ),
              ),
              SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pendingInternalComplaintResponse(
      selectedSubCategoryId,
      selectedDropDownSectorCode,
      ) async {
    final int requestId = ++_listRequestId;

    setState(() => isLoading = true);

    final result = await ParkListForLocationUpdationRepo().parklistupdate(
      context,
      selectedSubCategoryId,
      selectedDropDownSectorCode,
    );
    // 🔒 IGNORE OLD RESPONSE
    if (requestId != _listRequestId) return;

    if (result != null) {
      pendingInternalComplaintList = result;
      _filteredData = List.from(result);
    } else {
      pendingInternalComplaintList = [];
      _filteredData = [];
    }

    setState(() => isLoading = false);
  }

  bindSubCategory() async {
    final result = await SelectDivisionRepo().bindSubCategory(context);

    if (result != null) {
      subCategoryList = result;
      if (subCategoryList.isNotEmpty && dropDownSubCategory == null) {
        dropDownSubCategory = subCategoryList[0]["sDevisionName"];
        // here you get a division Code and hit sector api
        // iDivisionCode
        _selectedSubCategoryId = subCategoryList[0]["iDivisionCode"];
        if (_selectedSubCategoryId != null) {
          bindBindSector(_selectedSubCategoryId);
          // if need a then call a list api
          pendingInternalComplaintResponse(
            _selectedSubCategoryId,
            selectedDropDownSectorCode,
          );
          setState(() {

          });
        }
      }
      // call a bindSector Api
    } else {
      subCategoryList = []; // fallback empty list
      debugPrint("SubCategory list is null");
    }

    setState(() {});
  }

  bindBindSector(selectedSubCategoryId) async {
    final result = await SelectSectorRepo().bindSector(
      context,
      selectedSubCategoryId,
    );

    if (result != null && result.isNotEmpty) {
      sectorList = result;

      setState(() {
        // ✅ AUTO PICK FIRST VALUE
        dropDownSector = sectorList[0]["sSectorName"];
        selectedDropDownSectorCode = sectorList[0]["iSectorCode"];
      });

      // bind a list data behafe of both above dropdwon code
      if (_selectedSubCategoryId != null &&
          selectedDropDownSectorCode != null) {
        print("-----91--subCategoryId :sxxx----- ${_selectedSubCategoryId}");
        print(
          "-----92--sector   code  xxxxxx-- : ${selectedDropDownSectorCode}",
        );
        // clear a list
        // 🔴 CLEAR OLD LIST FIRST
        pendingInternalComplaintList.clear();
        _filteredData.clear();
        isLoading = true;

        // call a ListApi here
        pendingInternalComplaintResponse(
          _selectedSubCategoryId,
          selectedDropDownSectorCode,
        );
      }

      print("========86----$result");
    } else {
      setState(() {
        sectorList = [];
        dropDownSector = null;
        selectedDropDownSectorCode = null;
      });

      debugPrint("Sector list is null or empty");
    }
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
  Widget _bindSubCategory() {
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
                value: dropDownSubCategory, // ✅ MUST NOT BE NULL
                onTap: () => FocusScope.of(context).unfocus(),
                onChanged: (newValue) {
                  setState(() {
                    dropDownSubCategory = newValue;

                    // 🔴 CLEAR DEPENDENT STATE
                    dropDownSector = null;
                    sectorList.clear();
                    selectedDropDownSectorCode = null;

                    // 🔴 CLEAR LIST IMMEDIATELY
                    pendingInternalComplaintList.clear();
                    _filteredData.clear();
                    isLoading = true;

                    for (var element in subCategoryList) {
                      if (element["sDevisionName"] == newValue) {
                        _selectedSubCategoryId = element['iDivisionCode'];

                        if (_selectedSubCategoryId != null) {
                          bindBindSector(_selectedSubCategoryId);
                        }
                        break;
                      }
                    }
                  });
                },

                items: subCategoryList.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item["sDevisionName"].toString(),
                    child: Text(
                      item['sDevisionName'].toString(),
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

  Widget _bindSector() {
    return Material(
      //color: Colors.white,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true,
                // Helps to control the vertical size of the button
                isExpanded: true,
                dropdownColor: Colors.white,
                value: sectorList.isNotEmpty ? dropDownSector : null,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },

                //key: subCategoryFocus,
                onChanged: (newValue) {
                  setState(() {
                    dropDownSector = newValue;

                    // 🔴 CLEAR OLD LIST IMMEDIATELY
                    pendingInternalComplaintList.clear();
                    _filteredData.clear();
                    isLoading = true;

                    for (var element in sectorList) {
                      if (element["sSectorName"] == newValue) {
                        selectedDropDownSectorCode = element['iSectorCode'];

                        // ✅ CALL LIST API ONLY WHEN BOTH VALUES EXIST
                        if (_selectedSubCategoryId != null &&
                            selectedDropDownSectorCode != null) {
                          pendingInternalComplaintResponse(
                            _selectedSubCategoryId,
                            selectedDropDownSectorCode,
                          );
                        }
                        break;
                      }
                    }
                  });
                },

                items: sectorList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sSectorName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sSectorName'].toString(),
                            maxLines: 2, // allow text to go to next line
                            softWrap: true, // enable wrapping
                            overflow: TextOverflow.visible, // do NOT cut text
                            style: AppTextStyle
                                .font14OpenSansRegularBlack45TextStyle,
                          ),
                        ),
                      ],
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

  @override
  void initState() {
    // TODO: implement initState
    bindSubCategory();
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
            title: AppStrings.parkGeotagging.tr(), // title: "Park Geotagging",
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
                height: 218,
                // color: ColorManager.primary,
                color: const Color(0xFF6FB7AE),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // to apply here a class
                      PlatformText(
                        AppStrings.selectDivision
                            .tr(), //"Select Division" ,//  AppStrings.powerd_by.tr(),
                        type: AppTextType.title,
                      ),
                      // take a container with rounded corner bg white
                      SizedBox(height: 10),
                      _bindSubCategory(),
                      SizedBox(height: 10),
                      PlatformText(
                        AppStrings.selectSector
                            .tr(), // "Select Sector" ,//  AppStrings.powerd_by.tr(),
                        type: AppTextType.title,
                      ),
                      SizedBox(height: 10),
                      _bindSector(),
                    ],
                  ),
                ),
              ),
              Divider(height: 1),
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
              SizedBox(height: 10),
              /// todo heere you bind the list
              // at dynamic list you should remove this card content and uncomment below code to show
              // dynamic data
              Expanded(
                child: isLoading
                    ? CommonShimmerList()
                    : (pendingInternalComplaintList.isNotEmpty ||
                      pendingInternalComplaintList.isEmpty)
                    ? NoDataScreenPage()
                    : Padding(
                  padding: const EdgeInsets.only(left: 8.0,top: 8.0,bottom: 8.0,right: 4.0),
                  child: ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final ParkListModel item = _filteredData[index];
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
