import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/generalFunction.dart';
import '../../../../app/loader_helper.dart';
import '../../../../services/BindCitizenWardRepo.dart';
import '../../../../services/BindCommunityHallDateRepo.dart';
import '../../../../services/BindDocumentTypeRepo.dart';
import '../../../../services/BindFinancialYearRepo.dart';
import '../../../../services/BindTadeSubCategoryRepo.dart';
import '../../../../services/BindTradeCategoryRepo.dart';
import '../../../../services/baseurl.dart';
import '../../../../services/bindSubCategoryRepo.dart';
import '../../../../services/postLicenseRequest.dart';
import '../../../circle/circle.dart';
import '../../../resources/app_text_style.dart';
import '../../../resources/values_manager.dart';

class LicenseRequest extends StatefulWidget {

  var name;


  LicenseRequest({super.key, required this.name});

  @override
  State<LicenseRequest> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LicenseRequest>
    with TickerProviderStateMixin {
 // List stateList = [];
  List<dynamic> subCategoryList = [];
  List<Map<String, dynamic>> bindcommunityHallDate = [];
  List<dynamic> premisesWardDropDown = [];
  List<dynamic> finalYearDropDown = [];
  List<dynamic> bindTradeCategory = [];
  List<dynamic> bindTradeSubCategory = [];
  List<dynamic> bindDocumentTypeList = [];
  var result2, msg2;

  bool isFormVisible = true; // Track the visibility of the form
  bool isIconRotated = false;
  bool isFormVisible2 = true; // Track the visibility of the form
  bool isIconRotated2 = false;
  bool isFormVisible3 = true; // Track the visibility of the form
  bool isIconRotated3 = false;
  bool isFormVisible4 = true; // Track the visibility of the form
  bool isIconRotated4 = false;

  bindSubCategory(String subCategoryCode) async {
    subCategoryList = (await BindSubCategoryRepo().bindSubCategory(
      context,
      subCategoryCode,
    ))!;
    setState(() {});
  }

  var msg;
  var result;
  var SectorData;
  var stateblank;
  final stateDropdownFocus = GlobalKey();

  TextEditingController _premisesNameController = TextEditingController();
  TextEditingController _premisesAddressController = TextEditingController();
  TextEditingController _applicationNameController = TextEditingController();
  TextEditingController _applicationMobileController = TextEditingController();
  TextEditingController _applicationAddressController = TextEditingController();

  FocusNode _premisesNamefocus = FocusNode();
  FocusNode _premisesAddressfocus = FocusNode();
  FocusNode _applicationNamefocus = FocusNode();
  FocusNode _applicationMobilefocus = FocusNode();
  FocusNode _applicationAddressfocus = FocusNode();
  var sUploadBuildingPlanPath;
  var sUploadSupportingDocPath;

  int count = 0;
  int selectedIndex = -1;

  var dropDownSubCategory;
  var _dropDownPremisesWard;
  var _dropDownFinalYear;
  var sectorresponse;
  String? sec;
  final distDropdownFocus = GlobalKey();
  final subCategoryFocus = GlobalKey();
  final wardFocus = GlobalKey();

  //var _selectedWardId;
  var _dropDownPremisesWardCode;
  var _dropDownTradeCategoryCode;
  var _dropDownTradeSubCategoryCode;
  var _dropDownTradeSubCategoryFeesCode;
  var _dropDownDocument2;
  var _dropDownDocument2_code;
  var _dropDownTradeCategory;
  var _dropDownTradeSubCategory;
  var _dropDownFinalYearCode;

  File? image;
  var uplodedImage;
 // double? lat, long;
  List<String> selectedDates = []; // List to store selected dates

  bool isSuccess = false;
  bool isLoading = false;
  var iCommunityHallName;
  var firstStatus;
  File? image2;
  var pickFileid;
  //  --

  // Track selected states
  List<bool> selectedStates = [];
  Set<int> selectedIndices = {}; // To track selected items by index
  List<dynamic>? consuambleItemList = [];

  // firstPage secondPage and ThirdPage

  bool isFirstFormVisible = true;
  bool isSecondFormVisible = true;
  bool isThirdFormVisible = true;

  bool isFirstIconRotated = false;
  bool isSecondIconRotated = false;
  bool isThirdIconRotated = false;

  String? dropdownValue;
  final List<File> _imageFiles = []; // To store selected images
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> firstFormCombinedList = [];
  List<Map<String, dynamic>> secondFormCombinedList = [];
  List<Map<String, dynamic>> thirdFormCombinedList = [];
  List<Map<String, dynamic>> _imageFiles2 = [];
  var secondFromjson;
  var thirdFromJsonData;
  get selectedMonthCode => null;

  Widget buildImageWidget(String? imageUrl) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(imageUrl, width: 200, height: 200, fit: BoxFit.cover)
        : const Text(
            'No Image',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          );
  }

  Future<void> uploadImage(String token, File imageFile) async {
    var baseURL = BaseRepo().baseurl;
    var endPoint = "PostImage/PostImage";
    var uploadImageApi = "$baseURL$endPoint";
    try {
      print('-----xx-x----214----');
      showLoader();
      var request = http.MultipartRequest('POST', Uri.parse('$uploadImageApi'));
      request.headers['token'] = token;
      request.headers['sFolder'] = 'CompImage';
      // Add the image file as a part of the request
      request.files.add(
        await http.MultipartFile.fromPath('sFolder', imageFile.path),
      );
      // Send the request
      var streamedResponse = await request.send();
      // Get the response
      var response = await http.Response.fromStream(streamedResponse);
      // Parse the response JSON
      var responseData = json.decode(response.body); // No explicit type casting
      if (responseData is Map<String, dynamic>) {
        // Check for specific keys in the response
        uplodedImage = responseData['Data'][0]['sImagePath'];
        if (uplodedImage != null) {
          setState(() {
            uplodedImage = responseData['Data'][0]['sImagePath'];
          });
          print("-----283-ThirdList--$thirdFormCombinedList");
        }
        print('Uploaded Image Path----222--: $uplodedImage');
      } else {
        print('Unexpected response format: $responseData');
      }

      hideLoader();
    } catch (error) {
      hideLoader();
      print('Error uploading image: $error');
    }
  }

  // permises Ward Api call
  premisesWard() async {
    /// todo remove the comment and call Community Hall
    premisesWardDropDown = await BindCitizenWardRepo().bindCityZenWard(context);
    setState(() {});
  }

  // Financial Year Api call
  finalYearApi() async {
    /// todo remove the comment and call Community Hall
    finalYearDropDown = await BindFinalYearRepo().bindFinalYearWard(context);
    setState(() {});
  }

  // Bind Trade Category Item Api call
  bindTradeCategoryApi() async {
    /// todo remove the comment and call Community Hall
    bindTradeCategory = await BindTradeCategoryRepo().bindTradeCategory();
    setState(() {});
  }

  // Bind Sub Category Itrem Api call
  bindTradeSubCategoryApi(dropDownTradeCategoryCode) async {
    /// todo remove the comment and call Community Hall
    bindTradeSubCategory = [];
    bindTradeSubCategory = await BindTradeSubCategoryRepo()
        .bindTradeSubCategory(dropDownTradeCategoryCode);
    setState(() {});
  }

  // Bind Supporting Documents
  bindSupportingDocumentApi() async {
    /// todo remove the comment and call Community Hall
    bindDocumentTypeList = await BindDocumentTypeRepo().bindDocumentyType();
    setState(() {});
  }
  // DropdownButton Ward
  Widget _bindPremisesWard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 42,
          color: Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true,
                // Reduces the vertical size of the button
                isExpanded: true,
                // Allows the DropdownButton to take full width
                dropdownColor: Colors.white,
                // Set dropdown list background color
                onTap: () {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
                hint: RichText(
                  text: TextSpan(
                    text: "Select Premises Ward",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownPremisesWard,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownPremisesWard = newValue;
                    premisesWardDropDown.forEach((element) {
                      if (element["sWardName"] == _dropDownPremisesWard) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownPremisesWardCode = element['sWardCode'];
                      }
                    });
                    if (_dropDownPremisesWardCode != null) {
                      /// remove the comment
                      setState(() {
                      });
                    } else {
                      //toast
                    }
                    print("------157---hallId--$_dropDownPremisesWardCode");
                  });
                },

                items: premisesWardDropDown.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sWardName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sWardName'].toString(),
                            overflow: TextOverflow.ellipsis,
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

  // DropDownFinancial Year
  Widget _bindFinacialYear() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 42,
          color: Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true,
                // Reduces the vertical size of the button
                isExpanded: true,
                // Allows the DropdownButton to take full width
                dropdownColor: Colors.white,
                // Set dropdown list background color
                onTap: () {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
                hint: RichText(
                  text: TextSpan(
                    text: "Select Financial Year",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownFinalYear,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownFinalYear = newValue;
                    finalYearDropDown.forEach((element) {
                      if (element["sYearName"] == _dropDownFinalYear) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownFinalYearCode = element['iYear'];
                      }
                    });
                    if (_dropDownFinalYearCode != null) {
                      /// remove the comment
                      setState(() {
                        // call a api if needs

                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                    }
                    print("------293-----$_dropDownFinalYearCode");
                  });
                },

                items: finalYearDropDown.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sYearName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sYearName'].toString(),
                            overflow: TextOverflow.ellipsis,
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

  // bind TradeCategory Item
  Widget _bindTradeCategory() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 42,
          color: Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true,
                // Reduces the vertical size of the button
                isExpanded: true,
                // Allows the DropdownButton to take full width
                dropdownColor: Colors.white,
                // Set dropdown list background color
                onTap: () {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
                hint: RichText(
                  text: TextSpan(
                    text: "Select Trade Category",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownTradeCategory,
                onChanged: (newValue) {
                  bindTradeSubCategory = [];
                  _dropDownTradeSubCategory = null;
                  setState(() {
                    _dropDownTradeCategory = newValue;
                    bindTradeCategory.forEach((element) {
                      if (element["sTradeCategoryName"] ==
                          _dropDownTradeCategory) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        _dropDownTradeCategoryCode =
                            element['sTradeCategoryCode'];
                      }
                    });
                    if (_dropDownTradeCategoryCode != null) {
                      /// remove the comment
                      print("-----523----$_dropDownTradeCategoryCode");
                      setState(() {
                        // call a api if needs
                        bindTradeSubCategoryApi(_dropDownTradeCategoryCode);

                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                      print("Invalid Trade Category Code");
                    }
                    print(
                      "------373--DropDownnCategory Code----$_dropDownTradeCategoryCode",
                    );
                  });
                },

                items: bindTradeCategory.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sTradeCategoryName"].toString(),
                    child: SizedBox(
                      width: double.infinity, // important for wrapping
                      child: Text(
                        item['sTradeCategoryName'].toString(),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: AppTextStyle
                            .font14OpenSansRegularBlack45TextStyle,
                      ),
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

  // bind TradeSubcategory Item
  Widget _bindTradeSubCategory() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 42,
          color: Color(0xFFf2f3f5),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true,
                // Reduces the vertical size of the button
                isExpanded: true,
                // Allows the DropdownButton to take full width
                dropdownColor: Colors.white,
                // Set dropdown list background color
                onTap: () {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard
                },
                hint: RichText(
                  text: TextSpan(
                    text: "Select Trade Sub Category",
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ),
                value: _dropDownTradeSubCategory,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownTradeSubCategory = newValue;
                    bindTradeSubCategory.forEach((element) {
                      if (element["sTradeName"] == _dropDownTradeSubCategory) {
                        // RatePerDay
                        //_selectedWardId = element['iCommunityHallId'];
                        // iTradeCode   fLicenceFees
                        _dropDownTradeSubCategoryCode = element['iTradeCode'];
                        _dropDownTradeSubCategoryFeesCode =
                            element['fLicenceFees'];
                      }
                    });
                    print("---465--Fees----$_dropDownTradeSubCategoryFeesCode");
                    print("---466-code---$_dropDownTradeSubCategoryCode");
                    if (_dropDownTradeCategoryCode != null) {
                      /// remove the comment
                      setState(() {
                        // call a api if needs

                        // bindCommunityHallDate(_dropDownPremisesWardCode);
                      });
                    } else {
                      //toast
                    }
                    print(
                      "------373--DropDownnCategory Code----$_dropDownTradeCategoryCode",
                    );
                  });
                },

                items: bindTradeSubCategory.map((dynamic item) {
                  return DropdownMenuItem<String>(
                    value: item["sTradeName"].toString(),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        item['sTradeName'].toString(),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                      ),
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

  Future<void> bindCommunityHallDate(var hallId) async {
    setState(() {
      isLoading = true; // Start the progress bar
    });

    try {
      bindcommunityHallDate = await BindCommunityHallDateRepo()
          .bindCommunityHallDate(context, hallId, selectedMonthCode);
      print('-----232---->>>>---$bindcommunityHallDate');
      if (bindcommunityHallDate.isNotEmpty) {
        setState(() {
          isSuccess = true; // API call was successful
          isLoading = false; // Stop the progress bar
        });
      } else {
        setState(() {
          isSuccess = false; // No data found
          isLoading = false; // Stop the progress bar
        });
      }
    } catch (e) {
      setState(() {
        isSuccess = false; // If error occurs, mark as failed
        isLoading = false; // Stop the progress bar
      });
      // Handle error (you can show a toast or a Snackbar if needed)
      print('Error: $e');
    }
  }

  Widget buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Show progress bar while loading
      );
    }

    if (isSuccess) {
      // Show the list if the data is fetched successfully
      return AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Visibility(
          visible: true, // Change as per your conditions
          child: Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (bindcommunityHallDate.length / 2).ceil(),
              itemBuilder: (context, index) {
                int firstIndex = index * 2;
                int secondIndex = firstIndex + 1;

                if (firstIndex >= bindcommunityHallDate.length)
                  return SizedBox.shrink(); // No item for firstIndex
                Map<String, dynamic> firstItem =
                    bindcommunityHallDate[firstIndex];

                // Determine color for the first date
                int firstStatus = firstItem['iStatus'];
                Color firstColor;
                if (firstStatus == 0) {
                  firstColor = Colors.blue;
                } else if (firstStatus == 1) {
                  firstColor = Colors.green;
                } else if (firstStatus == 2) {
                  firstColor = Colors.red;
                } else {
                  firstColor = Colors.grey;
                }
                Map<String, dynamic>? secondItem;
                Color? secondColor;
                if (secondIndex < bindcommunityHallDate.length) {
                  secondItem = bindcommunityHallDate[secondIndex];
                  int secondStatus = secondItem['iStatus'];
                  secondColor = (secondStatus == 0)
                      ? Colors.blue
                      : (secondStatus == 1)
                      ? Colors.green
                      : (secondStatus == 2)
                      ? Colors.red
                      : Colors.grey;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateTile(
                      firstItem['dDate'],
                      selectedStates[firstIndex],
                      firstColor,
                      () {
                        setState(() {
                          var status = firstItem['iStatus'];
                          if (status == 0 || status == 1) {
                            selectedStates[firstIndex] =
                                !selectedStates[firstIndex];
                            if (selectedStates[firstIndex]) {
                              selectedDates.add(firstItem['dDate']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Selected: ${firstItem['dDate']}",
                                  ),
                                ),
                              );
                            } else {
                              selectedDates.remove(firstItem['dDate']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Deselected: ${firstItem['dDate']}",
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Booked already")),
                            );
                          }
                        });
                      },
                    ),
                    if (secondItem != null)
                      _buildDateTile(
                        secondItem['dDate'],
                        selectedStates[secondIndex],
                        secondColor!,
                        () {
                          setState(() {
                            var status = secondItem?['iStatus'];
                            if (status == 0 || status == 1) {
                              selectedStates[secondIndex] =
                                  !selectedStates[secondIndex];
                              if (selectedStates[secondIndex]) {
                                selectedDates.add(secondItem?['dDate']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Selected: ${secondItem?['dDate']}",
                                    ),
                                  ),
                                );
                              } else {
                                selectedDates.remove(secondItem?['dDate']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Deselected: ${secondItem?['dDate']}",
                                    ),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Booked already")),
                              );
                            }
                          });
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text(
          "No Data Available ",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }
  }

  //
  void openPdf(BuildContext context, String pdfUrl) async {
    if (await canLaunchUrl(Uri.parse(pdfUrl))) {
      await launchUrl(Uri.parse(pdfUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cannot open PDF")));
    }
  }

  @override
  void initState() {
    premisesWard();
    finalYearApi();
    bindTradeCategoryApi();
    bindSupportingDocumentApi();
    super.initState();
    _premisesNamefocus = FocusNode();
    _premisesAddressfocus = FocusNode();
    _applicationNamefocus = FocusNode();
    _applicationMobilefocus = FocusNode();
    _applicationAddressfocus = FocusNode();
    if (bindcommunityHallDate.isNotEmpty) {
      selectedStates = List.generate(
        bindcommunityHallDate.length,
        (index) => false,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _premisesNamefocus.dispose();
    _premisesAddressfocus.dispose();
    _applicationNamefocus.dispose();
    _applicationMobilefocus.dispose();
    _applicationAddressfocus.dispose();
    FocusScope.of(context).unfocus();
  }

  // Api call Function
  void validateAndCallApi() async {
    firstFormCombinedList = [];
    DateTime now = DateTime.now();
    // Format the date as yyyyMMddHHmmssSS
    String formattedDate = DateFormat('yyyyMMddHHmmssSS').format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sCreatedBy = prefs.getString('sContactNo');
    // TextFormField values
    var premisesName = _premisesNameController.text.trim();
    var premisesAddress = _premisesAddressController.text.trim();
    var applicationName = _applicationNameController.text.trim();
    var applicationMobileNo = _applicationMobileController.text.trim();
    var applicationAddress = _applicationAddressController.text.trim();

    print("----987---$secondFormCombinedList");

    if (_dropDownPremisesWardCode != null &&
        _dropDownFinalYearCode != null &&
        premisesName.isNotEmpty &&
        premisesAddress.isNotEmpty &&
        applicationName.isNotEmpty &&
        applicationMobileNo.isNotEmpty &&
        applicationAddress.isNotEmpty &&
        secondFormCombinedList != null &&
        secondFormCombinedList.isNotEmpty &&
        secondFormCombinedList != []) {
      // All conditions met; call the API
      print('---Call API---');

      /// put these value into the list
      firstFormCombinedList.add({
        "sLicenseRequestCode": "$formattedDate",
        "iWardCode": "$_dropDownPremisesWardCode",
        "sFinYear": "$_dropDownFinalYearCode",
        "sPremisesName": premisesName,
        "sPremisesAddress": premisesAddress,
        "sApplicantName": applicationName,
        "sMobileNo": applicationMobileNo,
        "sAddress": applicationAddress,
        "sCreatedBy": sCreatedBy,
        "LicenseTradeList": secondFormCombinedList,
        "DocumentUploadList": thirdFormCombinedList,
      });
      // lIST to convert json string
      String allThreeFormJson = jsonEncode(firstFormCombinedList);
      print(
        "----1011--->>>>>Xxxxx-----FINAL LIST jsson response---$allThreeFormJson",
      );
      // Call your API logic here
      var onlineComplaintResponse = await PostlicenseRequestRepo()
          .postLicenseRequest(context, allThreeFormJson);

      print('----1020---$onlineComplaintResponse');
      result2 = onlineComplaintResponse['Result'];
      msg2 = onlineComplaintResponse['Msg'];
      if (result2 == "1") {
        displayToast(msg2);
        Navigator.pop(context);
      } else {
        displayToast(msg2);
      }
      // Call your API here
    } else {
      // If conditions fail, display appropriate error messages
      print('--Not Call API--');

      if (_dropDownPremisesWard == null) {
        displayToast('Please Select Premises Ward');
        return;
      }
      if (_dropDownFinalYear == null) {
        displayToast('Please Select Final Year');
        return;
      }

      if (premisesName.isEmpty) {
        displayToast('Please Enter Premises Name');
        return;
      }
      if (premisesAddress.isEmpty) {
        displayToast('Please Enter Premises Address');
        return;
      }
      if (applicationName.isEmpty) {
        displayToast('Please Enter Application Name');
        return;
      }
      if (applicationMobileNo.isEmpty) {
        displayToast('Please Enter Mobile No');
        return;
      }
      if (applicationAddress.isEmpty) {
        displayToast('Please Enter Application Address');
      }
      if (secondFormCombinedList.isEmpty) {
        displayToast('Uplode Trade Category Item');
        return;
      }
    }
  }

  Widget _buildDateTile(
    String dDate,
    bool isSelected,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          height: 40.0, // Fixed height
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20.0),
              right: Radius.circular(20.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show a check symbol if selected
              if (isSelected)
                Container(
                  width: 24.0, // Circle size
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.5,
                    ), // Background color for circle
                    shape: BoxShape.circle, // Ensures the container is circular
                  ),
                  child: const Icon(
                    Icons.check, // Check symbol icon
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),
              if (isSelected)
                SizedBox(width: 8.0), // Space between icon and text
              // Always show the date text
              Text(
                dDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: getAppBarBack(context,"Online Complaint"),
          appBar: AppBar(
            // statusBarColore
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xFF12375e),
              statusBarIconBrightness: Brightness.dark,
              // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            // backgroundColor: Colors.blu
            centerTitle: true,
            backgroundColor: Color(0xFF255898),
            leading: GestureDetector(
              onTap: () {
                print("------back---");
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "${widget.name}",
                style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            //centerTitle: true,
            elevation: 0, // Removes shadow under the AppBar
          ),
          body: Stack(
            children: [
              // Scrollable ListView
              ListView(
                padding: EdgeInsets.only(bottom: 80),
                // Prevent overlap with button
                children: [
                  // First Section Header
                  _buildSectionHeader(
                    title: "1. Premises Details",
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
                    title: "2. Trade Category Detail",
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

                  // Third Section Header
                  _buildSectionHeader(
                    title: "3. Upload Photos",
                    isVisible: isThirdFormVisible,
                    isIconRotated: isThirdIconRotated,
                    onToggle: () {
                      setState(() {
                        isThirdFormVisible = !isThirdFormVisible;
                        isThirdIconRotated = !isThirdIconRotated;
                      });
                    },
                  ),
                  // Third Form Content
                  if (isThirdFormVisible)
                    // _buildThirdForm(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Card(
                              elevation: 4, // Adjust the shadow level
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ), // Rounded corners for the card
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                // Inner padding for the container
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // Background color for the container
                                  borderRadius: BorderRadius.circular(5),
                                  // Rounded corners for the container
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border width
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // Auto height based on children
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // Align children to the start
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print("--pick a image--");
                                        // thirdFormCombinedList = [];
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    10,
                                                  ), // Rounded corners
                                            ),
                                            child: StatefulBuilder(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    void Function(
                                                      void Function(),
                                                    )
                                                    setState,
                                                  ) {
                                                    return Stack(
                                                      clipBehavior: Clip.none,
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 50,
                                                                left: 10,
                                                                right: 10,
                                                                bottom: 20,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      left: 10,
                                                                    ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    CircleWithSpacing(),
                                                                    // Space between the circle and text
                                                                    Text(
                                                                      "Required Document Type",
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlack45TextStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              // Document DropDown
                                                              Material(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10.0,
                                                                    ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                      ),
                                                                  child: Container(
                                                                    width:
                                                                        MediaQuery.of(
                                                                          context,
                                                                        ).size.width -
                                                                        50,
                                                                    height: 42,
                                                                    color: Color(
                                                                      0xFFf2f3f5,
                                                                    ),
                                                                    child: DropdownButtonHideUnderline(
                                                                      child: ButtonTheme(
                                                                        alignedDropdown:
                                                                            true,
                                                                        child: DropdownButton(
                                                                          isDense:
                                                                              true,
                                                                          // Reduces the vertical size of the button
                                                                          isExpanded:
                                                                              true,
                                                                          // Allows the DropdownButton to take full width
                                                                          dropdownColor:
                                                                              Colors.white,
                                                                          // Set dropdown list background color
                                                                          onTap: () {
                                                                            FocusScope.of(
                                                                              context,
                                                                            ).unfocus(); // Dismiss keyboard
                                                                          },
                                                                          hint: RichText(
                                                                            text: TextSpan(
                                                                              text: "Select Document Type",
                                                                              style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                                                            ),
                                                                          ),
                                                                          value:
                                                                              _dropDownDocument2,
                                                                          onChanged:
                                                                              (
                                                                                newValue,
                                                                              ) {
                                                                                setState(
                                                                                  () {
                                                                                    _dropDownDocument2 = newValue;
                                                                                    bindDocumentTypeList.forEach(
                                                                                      (
                                                                                        element,
                                                                                      ) {
                                                                                        if (element["sDocumentTypeName"] ==
                                                                                            _dropDownDocument2) {
                                                                                          // RatePerDay
                                                                                          //_selectedWardId = element['iCommunityHallId'];
                                                                                          // iTradeCode   fLicenceFees
                                                                                          _dropDownDocument2_code = element['iDocumentTypeCode'];
                                                                                          // _dropDownTradeSubCategoryFeesCode = element['fLicenceFees'];
                                                                                        }
                                                                                      },
                                                                                    );

                                                                                    if (_dropDownDocument2_code !=
                                                                                        null) {
                                                                                      /// remove the comment
                                                                                      setState(
                                                                                        () {
                                                                                          // call a api if needs
                                                                                          print(
                                                                                            "---585--Fees----$_dropDownDocument2_code",
                                                                                          );
                                                                                          //  _dropDownDocument2
                                                                                          print(
                                                                                            "---587------$_dropDownDocument2",
                                                                                          );
                                                                                          // bindCommunityHallDate(_dropDownPremisesWardCode);
                                                                                        },
                                                                                      );
                                                                                    } else {
                                                                                      //toast
                                                                                    }
                                                                                    print(
                                                                                      "------373--DropDownnCategory Code----$_dropDownTradeCategoryCode",
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },

                                                                          items: bindDocumentTypeList.map((
                                                                            dynamic
                                                                            item,
                                                                          ) {
                                                                            return DropdownMenuItem(
                                                                              value: item["sDocumentTypeName"].toString(),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      item['sDocumentTypeName'].toString(),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
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
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      left: 10,
                                                                    ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    CircleWithSpacing(),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    // Space between the circle and text
                                                                    Text(
                                                                      'Supporting Document',
                                                                      style: AppTextStyle
                                                                          .font14OpenSansRegularBlack45TextStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),

                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (uplodedImage!
                                                                      .toLowerCase()
                                                                      .endsWith(
                                                                        '.pdf',
                                                                      )) {
                                                                    print(
                                                                      "PDF tapped: $uplodedImage",
                                                                    );
                                                                    // Open PDF in browser or PDF viewer
                                                                    openPdf(
                                                                      context,
                                                                      uplodedImage!,
                                                                    );
                                                                  } else {
                                                                    print(
                                                                      "Image tapped: $uplodedImage",
                                                                    );
                                                                    // Open image in full screen
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (_) => Scaffold(
                                                                          appBar: AppBar(
                                                                            title: const Text(
                                                                              "Image Preview",
                                                                            ),
                                                                          ),
                                                                          body: Center(
                                                                            child: Image.network(
                                                                              uplodedImage!,
                                                                              width: double.infinity, // take full width
                                                                              fit: BoxFit.cover, // cover the available space
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: Container(
                                                                  height: 150,
                                                                  width: 200,
                                                                  decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                  ),
                                                                  child:
                                                                      image !=
                                                                          null
                                                                      ? ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                          child:
                                                                              image!.path.toLowerCase().endsWith(
                                                                                '.pdf',
                                                                              )
                                                                              ? Container(
                                                                                  color: Colors.grey[200],
                                                                                  child: const Center(
                                                                                    child: Icon(
                                                                                      Icons.picture_as_pdf,
                                                                                      color: Colors.red,
                                                                                      size: 60,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Image.file(
                                                                                  image!,
                                                                                  width: 200,
                                                                                  height: 150,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                        )
                                                                      : const Center(
                                                                          child: Text(
                                                                            'No File Available',
                                                                            style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ),
                                                              ),

                                                              const SizedBox(
                                                                height: 10,
                                                              ),

                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  // First Container
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      //_pickImageCamra();
                                                                      SharedPreferences
                                                                      prefs =
                                                                          await SharedPreferences.getInstance();
                                                                      String?
                                                                      sToken = prefs
                                                                          .getString(
                                                                            'sToken',
                                                                          );

                                                                      final pickFileid = await _picker.pickImage(
                                                                        source:
                                                                            ImageSource.camera,
                                                                        imageQuality:
                                                                            65,
                                                                      );

                                                                      setState(() {
                                                                        image = File(
                                                                          pickFileid!
                                                                              .path,
                                                                        );
                                                                      });
                                                                      print(
                                                                        "----171----pic path : ---$image",
                                                                      );
                                                                      if (pickFileid !=
                                                                          null) {
                                                                        setState(() {
                                                                          _imageFiles.add(
                                                                            File(
                                                                              pickFileid.path,
                                                                            ),
                                                                          ); // Add selected image to list
                                                                          uploadImage(
                                                                            sToken!,
                                                                            image!,
                                                                          );
                                                                        });
                                                                        print(
                                                                          "---173--ImageFile--List----$_imageFiles",
                                                                        );
                                                                      }

                                                                      },
                                                                    child: Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            8.0,
                                                                          ),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .black12,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            'assets/images/ic_camera.PNG',
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          const Text(
                                                                            "Photo",
                                                                            style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // Second Container
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      // _pickImageGallry();
                                                                      File?
                                                                      selectedFile;
                                                                      SharedPreferences
                                                                      prefs =
                                                                          await SharedPreferences.getInstance();
                                                                      String?
                                                                      sToken = prefs
                                                                          .getString(
                                                                            'sToken',
                                                                          );

                                                                      try {
                                                                        // Open gallery or file picker
                                                                        FilePickerResult?
                                                                        result = await FilePicker.platform.pickFiles(
                                                                          type:
                                                                              FileType.custom,
                                                                          allowedExtensions: [
                                                                            'jpg',
                                                                            'jpeg',
                                                                            'png',
                                                                            'pdf',
                                                                          ],
                                                                        );

                                                                        if (result !=
                                                                                null &&
                                                                            result.files.single.path !=
                                                                                null) {
                                                                          image = File(
                                                                            result.files.single.path!,
                                                                          );
                                                                          String
                                                                          filePath =
                                                                              image!.path;
                                                                          print(
                                                                            'cted File Path: Sele$filePath',
                                                                          );

                                                                          if (filePath.toLowerCase().endsWith(
                                                                            '.pdf',
                                                                          )) {
                                                                            print(
                                                                              "✅ PDF file selected",
                                                                            );
                                                                            displayToast(
                                                                              'Pdf file is selected',
                                                                            );
                                                                            setState(() {
                                                                              _imageFiles.add(
                                                                                File(
                                                                                  image!.path,
                                                                                ),
                                                                              ); // Add selected image to list
                                                                              uploadImage(
                                                                                sToken!,
                                                                                image!,
                                                                              );
                                                                            });
                                                                            // Optionally, show PDF icon or preview
                                                                          } else {
                                                                            print(
                                                                              "✅ Image file selected",
                                                                            );
                                                                            setState(() {
                                                                              _imageFiles.add(
                                                                                File(
                                                                                  image!.path,
                                                                                ),
                                                                              ); // Add selected image to list
                                                                              uploadImage(
                                                                                sToken!,
                                                                                image!,
                                                                              );
                                                                            });
                                                                            // Optionally, show image preview in UI
                                                                          }

                                                                          // ✅ Upload File
                                                                          if (sToken !=
                                                                              null) {
                                                                            print(
                                                                              "-----------581---------",
                                                                            );
                                                                            print(
                                                                              "-----------selectedPath---------$image",
                                                                            );

                                                                            uploadImage(
                                                                              sToken,
                                                                              image!,
                                                                            );
                                                                          } else {
                                                                            print(
                                                                              "❌ Token not found",
                                                                            );
                                                                          }
                                                                        } else {
                                                                          print(
                                                                            '❌ No file selected',
                                                                          );
                                                                        }
                                                                      } catch (
                                                                        e
                                                                      ) {
                                                                        print(
                                                                          "❌ Error picking file: $e",
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            8.0,
                                                                          ),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .black12,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Image.asset(
                                                                            'assets/images/ic_camera.PNG',
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          const Text(
                                                                            "Gallery",
                                                                            style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  print(
                                                                    "-----2463--Doc---$_dropDownDocument2_code",
                                                                  );
                                                                  print(
                                                                    "-----2463--Doc---$_dropDownDocument2",
                                                                  );
                                                                  print(
                                                                    "-----2463--images---$uplodedImage",
                                                                  );

                                                                  if (_dropDownDocument2_code ==
                                                                      null) {
                                                                    displayToast(
                                                                      "Please Select Document",
                                                                    );
                                                                  } else if (uplodedImage ==
                                                                      null) {
                                                                    displayToast(
                                                                      "Please pick a Document",
                                                                    );
                                                                  } else {
                                                                    // Add this item into the list

                                                                    thirdFormCombinedList.add({
                                                                      'iDocumentTypeId':
                                                                          "${_dropDownDocument2_code}",
                                                                      'sDocumentName':
                                                                          "$_dropDownDocument2",
                                                                      'sDocumentUrl':
                                                                          uplodedImage,
                                                                    });
                                                                    // clear
                                                                    // add data another list
                                                                    _imageFiles2.add({
                                                                      'sDocumentName':
                                                                          "$_dropDownDocument2",
                                                                      'sDocumentUrl':
                                                                          image,
                                                                    });
                                                                    print("----1977---$thirdFormCombinedList");
                                                                    // clear all fields
                                                                    image = null;
                                                                    uplodedImage = null;
                                                                    _dropDownDocument2_code = null;
                                                                    _dropDownDocument2 = null;
                                                                    // to store list data here

                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();

                                                                  }
                                                                  // Navigator.of(context).pop(); // Close dialog
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                  ),
                                                                ),
                                                                child: const Text(
                                                                  "Save",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Positioned(
                                                          top: -40,
                                                          child: CircleAvatar(
                                                            radius: 40,
                                                            backgroundImage: AssetImage(
                                                              'assets/images/licenseRequestuplode.jpeg',
                                                            ), // Replace with your image
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                            ),
                                          ),
                                        );
                                      },
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                            ),
                                            height: 35,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF96DFE8),
                                              // Background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    10,
                                                  ), // Rounded corners
                                            ),
                                            //padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Plus icon
                                                //SizedBox(width: 8), // Spacing between icon and text
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 10,
                                                      ),
                                                  child: Text(
                                                    "Add Photo",
                                                    style: AppTextStyle
                                                        .font14OpenSansRegularBlackTextStyle,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    _imageFiles.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: SizedBox(
                                              height: 120,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: _imageFiles.length,
                                                itemBuilder: (context, index) {
                                                  String filePath =
                                                      _imageFiles[index].path;
                                                  bool isPdf = filePath
                                                      .toLowerCase()
                                                      .endsWith('.pdf');

                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          right: 10.0,
                                                        ),
                                                    width: 140,
                                                    height: 140,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.blue,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10.0,
                                                          ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.0,
                                                          ),
                                                      child: isPdf
                                                          ? Container(
                                                              color: Colors
                                                                  .grey[200],
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .picture_as_pdf,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 50,
                                                                ),
                                                              ),
                                                            )
                                                          : Image.file(
                                                              _imageFiles[index],
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : const Center(
                                            child: Text('No files selected.'),
                                          ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              // Fixed Bottom Button
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    validateAndCallApi();
                  },
                  child: Container(
                    width: double.infinity,
                    // Make container fill the width of its parent
                    height: AppSize.s45,
                    padding: EdgeInsets.all(AppPadding.p5),
                    decoration: BoxDecoration(
                      color: Color(0xFF255898),
                      // Background color using HEX value
                      borderRadius: BorderRadius.circular(
                        AppMargin.m10,
                      ), // Rounded corners
                    ),
                    //  #00b3c7
                    child: Center(
                      child: Text(
                        "Submit",
                        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Header Widget
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

  // FIRST FORM
  Widget _buildFirstForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // Align items vertically
            children: <Widget>[
              CircleWithSpacing(),
              // Space between the circle and text
              RichText(
                text: TextSpan(
                  text: 'Premises Ward', // The normal text
                  style: AppTextStyle
                      .font14OpenSansRegularBlack45TextStyle, // Default style
                  children: const [
                    TextSpan(
                      text: ' *', // The asterisk
                      style: TextStyle(
                        color: Colors.red, // Red color for the asterisk
                        fontWeight:
                            FontWeight.bold, // Optional: Make the asterisk bold
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          // Premises Ward dropDown
          _bindPremisesWard(),
          SizedBox(height: 5),
          // Financial Ward
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Financial Year',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),

          /// todo apply DropDown
          _bindFinacialYear(),
          // _bindWard(),
          // Premises Name
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Premises Name',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _premisesNamefocus,
                        controller: _premisesNameController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          filled: true, // Enable background color
                          fillColor: Color(
                            0xFFf2f3f5,
                          ), // Set your desired background color
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Permises Address
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Premises Address',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _premisesAddressfocus,
                        controller: _premisesAddressController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                            0xFFf2f3f5,
                          ), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // application name
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Applicant Name',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _applicationNamefocus,
                        controller: _applicationNameController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                            0xFFf2f3f5,
                          ), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Applicant Mobile No',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: 65,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _applicationMobilefocus,
                        controller: _applicationMobileController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          filled: true,
                          fillColor: Color(0xFFf2f3f5),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        // 🔹 Validation logic
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (value.length < 10) {
                            return 'length is less than 10 digit';
                          }
                          return null; // valid
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),

                      // child: TextFormField(
                      //   focusNode: _applicationMobilefocus,
                      //   controller: _applicationMobileController,
                      //   keyboardType: TextInputType.number,
                      //   textInputAction: TextInputAction.next,
                      //   onEditingComplete: () =>
                      //       FocusScope.of(context).nextFocus(),
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     contentPadding: EdgeInsets.symmetric(
                      //       vertical: 10.0,
                      //       horizontal: 10.0,
                      //     ),
                      //     filled: true,
                      //     // Enable background color
                      //     fillColor: Color(
                      //       0xFFf2f3f5,
                      //     ), // Set your desired background color here
                      //   ),
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     // Allow only digits
                      //     LengthLimitingTextInputFormatter(10),
                      //     // Restrict input to a maximum of 10 digits
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align items vertically
              children: <Widget>[
                CircleWithSpacing(),
                // Space between the circle and text
                RichText(
                  text: TextSpan(
                    text: 'Applicant Address',
                    // The normal text
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                    // Default style
                    children: const [
                      TextSpan(
                        text: ' *', // The asterisk
                        style: TextStyle(
                          color: Colors.red, // Red color for the asterisk
                          fontWeight: FontWeight
                              .bold, // Optional: Make the asterisk bold
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Container(
              height: 70,
              // Increased height to accommodate error message without resizing
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _applicationAddressfocus,
                        controller: _applicationAddressController,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          filled: true,
                          // Enable background color
                          fillColor: Color(
                            0xFFf2f3f5,
                          ), // Set your desired background color here
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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

  // Second Form
  Widget _buildSecondForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Add a list to added item on a Add Item
          // if (consuambleItemList!.isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/uplodeTrade.jpeg',
                    height: 25,
                    width: 25,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Trade Category List',
                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                // Makes ListView take up only the needed height
                physics: NeverScrollableScrollPhysics(),
                // Disable ListView scrolling if the outer widget scrolls
                itemCount: consuambleItemList?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = consuambleItemList![index];
                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        // iTranId = notificationData.iTranId;
                      });
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return _deleteItemDialog(context);
                      //   },
                      // );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 1.0,
                        horizontal: 1.0,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                child: Image.asset(
                                  'assets/images/uplodeTrade.jpeg',
                                  fit: BoxFit.fill,
                                  errorBuilder:
                                      (
                                        BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace,
                                      ) {
                                        return Icon(Icons.error, size: 25);
                                      },
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['sTradeCategory'],
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle,
                                  ),
                                  Text(
                                    'Category Name',
                                    style: AppTextStyle
                                        .font12OpenSansRegularBlack45TextStyle,
                                  ),
                                ],
                              ),
                              // Spacer(),
                              // Text(
                              //     'Quantity: ${item['SrNo']}',
                              //     style: AppTextStyle
                              //         .font14OpenSansRegularBlack45TextStyle),
                            ],
                          ),
                          Divider(),
                          Container(
                            height: 45,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 14,
                                            width: 14,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            item['sTradeSubCategory'],
                                            style: AppTextStyle
                                                .font14OpenSansRegularBlackTextStyle,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                        ),
                                        child: Text(
                                          'Trade Name',
                                          style: AppTextStyle
                                              .font12OpenSansRegularBlack45TextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  color: Color(0xFF0098a6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    '₹ ${item['feesCode']}',
                                    style: AppTextStyle
                                        .font14OpenSansRegularWhiteTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  elevation: 4, // Adjust the shadow level
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Rounded corners for the card
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    // Inner padding for the container
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Background color for the container
                      borderRadius: BorderRadius.circular(5),
                      // Rounded corners for the container
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Auto height based on children
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align children to the start
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/uplodeTrade.jpeg',
                                  ),
                                  // Use AssetImage here
                                  fit: BoxFit
                                      .cover, // Adjusts how the image is fitted
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            const Text(
                              "Upload Trade Category Item",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: AnimatedRotation(
                                turns: isIconRotated4 ? 0.5 : 0.0,
                                // Rotates the icon
                                duration: Duration(milliseconds: 300),
                                child: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  // Toggle form visibility and icon rotation
                                  isFormVisible4 = !isFormVisible4;
                                  isIconRotated4 = !isIconRotated4;
                                });
                              },
                            ),
                          ],
                        ),
                        if (isFormVisible4)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // Align items vertically
                                children: <Widget>[
                                  CircleWithSpacing(),
                                  // Space between the circle and text
                                  Text(
                                    'Trade Category',
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle,
                                  ),
                                ],
                              ),
                              _bindTradeCategory(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // Align items vertically
                                children: <Widget>[
                                  CircleWithSpacing(),
                                  // Space between the circle and text
                                  Text(
                                    'Trade Sub Category',
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle,
                                  ),
                                ],
                              ),
                              _bindTradeSubCategory(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // Align items vertically
                                children: <Widget>[
                                  CircleWithSpacing(),
                                  // Space between the circle and text
                                  Text(
                                    'Licence Fee',
                                    style: AppTextStyle
                                        .font14OpenSansRegularBlack45TextStyle,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 0,
                                ),
                                child: Container(
                                  height: 70,
                                  // Increased height to accommodate error message without resizing
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${_dropDownTradeSubCategoryFeesCode ?? 0}",
                                            style: AppTextStyle
                                                .font14penSansBlack45TextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  count++;
                                  // Registration
                                  // consuambleItemList=[];
                                  print('-----1354---');
                                  print(
                                    "--------1535--fees--$_dropDownTradeSubCategoryFeesCode",
                                  );
                                  print(
                                    "-----DropDown Trade Category-----$_dropDownTradeCategory",
                                  );
                                  print(
                                    "-----DropDown Sub Trade Category-----$_dropDownTradeSubCategory",
                                  );

                                  if (_dropDownTradeCategoryCode == null) {
                                    displayToast("Pick a Trade Category");
                                    return;
                                  }
                                  if (_dropDownTradeSubCategory == null) {
                                    displayToast("Pick a Trade Sub Category");
                                    return;
                                  }
                                  setState(() {
                                    consuambleItemList ??=
                                        []; // Initialize the list if it's null
                                    consuambleItemList!.add({
                                      'SrNo': count,
                                      'sTradeCategory': _dropDownTradeCategory,
                                      'sTradeSubCategory':
                                          _dropDownTradeSubCategory,
                                      'feesCode':
                                          _dropDownTradeSubCategoryFeesCode,
                                    });
                                  });
                                  displayToast("Item Added");
                                  // Added Item into secondFormList
                                  secondFormCombinedList.add({
                                    "TradeCategoryId":
                                        "$_dropDownTradeCategoryCode",
                                    "TradeId": "$_dropDownTradeSubCategoryCode",
                                    "NoOfRoom": "",
                                    "LicenceFee":
                                        "$_dropDownTradeSubCategoryFeesCode",
                                  });
                                  firstFormCombinedList.addAll(
                                    secondFormCombinedList,
                                  );
                                  print(
                                    "----2045---com first + second list---$firstFormCombinedList",
                                  );
                                  setState(() {
                                    secondFromjson = jsonEncode(
                                      secondFormCombinedList,
                                    );
                                  });
                                  print(
                                    "-----2067---secondFormData--...---: $secondFromjson",
                                  );

                                  //  _dropDownTradeSubCategory
                                },
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    // 10dp padding around the text
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF255899),
                                      ),
                                      // Gray border color
                                      borderRadius: BorderRadius.circular(
                                        8.0,
                                      ), // Rounded corners for the border
                                    ),
                                    child: Text(
                                      "Add Item",
                                      style: AppTextStyle
                                          .font14penSansBlackTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
