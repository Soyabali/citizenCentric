import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart'; // Required for json_serializable


// this a login Api response
// this is a response file i will write this file according to api response
// in this file i am used JsonSerializable and with a command i generate another generated file
//  response.g.dart file

@JsonSerializable()
class AuthenticationResponse {
  @JsonKey(name: "Result")
  String? result;
  @JsonKey(name: "Msg")
  String? msg;
  @JsonKey(name: "sEmpCode")
  String? empCode;
  @JsonKey(name: "sCompEmpCode")
  String? compEmpCode;
  @JsonKey(name: "sFirstName")
  String? firstName;
  @JsonKey(name: "sLastName")
  String? lastName;
  @JsonKey(name: "sContactNo")
  String? contactNo;
  @JsonKey(name: "dDOJ")
  String? dateOfJoining;
  @JsonKey(name: "dDOB")
  String? dateOfBirth;
  @JsonKey(name: "sEmergencyContactPerson")
  String? emergencyContactPerson;
  @JsonKey(name: "sEmergencyContactNo")
  String? emergencyContactNo;
  @JsonKey(name: "sEmergencyContactRelation")
  String? emergencyContactRelation;
  @JsonKey(name: "sBloodGroup")
  String? bloodGroup;
  @JsonKey(name: "sCategory")
  String? category;
  @JsonKey(name: "sDsgCode")
  String? designationCode;
  @JsonKey(name: "sDsgName")
  String? designationName;
  @JsonKey(name: "sDeptCode")
  String? departmentCode;
  @JsonKey(name: "sDeptName")
  String? departmentName;
  @JsonKey(name: "sLocCode")
  String? locationCode;
  @JsonKey(name: "sLocName")
  String? locationName;
  @JsonKey(name: "sLocation")
  String? locationAddress;
  @JsonKey(name: "sBankName")
  String? bankName;
  @JsonKey(name: "sBankAcNo")
  String? bankAccountNumber;
  @JsonKey(name: "sISFCode")
  String? ifscCode;
  @JsonKey(name: "Entitlement")
  String? entitlement;
  @JsonKey(name: "Availed")
  String? availed;
  @JsonKey(name: "Balance")
  String? balance;
  @JsonKey(name: "sToken")
  String? token;
  @JsonKey(name: "sEmpImage")
  String? employeeImage;
  @JsonKey(name: "sCompEmailId")
  String? companyEmailId;
  @JsonKey(name: "sMngrName")
  String? managerName;
  @JsonKey(name: "sMngrDesgName")
  String? managerDesignationName;
  @JsonKey(name: "sMngrContactNo")
  String? managerContactNo;
  @JsonKey(name: "iIsEligibleShLv")
  String? isEligibleShortLeave;
  @JsonKey(name: "iPaymentUpload")
  String? paymentUpload;
  @JsonKey(name: "iPaymentAction")
  String? paymentAction;

  AuthenticationResponse({
    this.result,
    this.msg,
    this.empCode,
    this.compEmpCode,
    this.firstName,
    this.lastName,
    this.contactNo,
    this.dateOfJoining,
    this.dateOfBirth,
    this.emergencyContactPerson,
    this.emergencyContactNo,
    this.emergencyContactRelation,
    this.bloodGroup,
    this.category,
    this.designationCode,
    this.designationName,
    this.departmentCode,
    this.departmentName,
    this.locationCode,
    this.locationName,
    this.locationAddress,
    this.bankName,
    this.bankAccountNumber,
    this.ifscCode,
    this.entitlement,
    this.availed,
    this.balance,
    this.token,
    this.employeeImage,
    this.companyEmailId,
    this.managerName,
    this.managerDesignationName,
    this.managerContactNo,
    this.isEligibleShortLeave,
    this.paymentUpload,
    this.paymentAction,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}