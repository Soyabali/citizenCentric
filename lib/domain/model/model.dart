// here we put a model every api or every response.
// we put a slider model after that we put a login model after that as a need.


// model Dashboard
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

// model LoginScreen
// here Authentication class is a model class of login Api you should give name such as LoginModel

class Authentication {
  final String result;
  final String msg;
  final String empCode;
  final String compEmpCode;
  final String firstName;
  final String lastName;
  final String contactNo;
  final String dateOfJoining;
  final String dateOfBirth;
  final String emergencyContactPerson;
  final String emergencyContactNo;
  final String emergencyContactRelation;
  final String bloodGroup;
  final String category;
  final String designationCode;
  final String designationName;
  final String departmentCode;
  final String departmentName;
  final String locationCode;
  final String locationName;
  final String locationAddress;
  final String bankName;
  final String bankAccountNumber;
  final String ifscCode;
  final String entitlement;
  final String availed;
  final String balance;
  final String token;
  final String employeeImage;
  final String companyEmailId;
  final String managerName;
  final String managerDesignationName;
  final String managerContactNo;
  final String isEligibleShortLeave;
  final String paymentUpload;
  final String paymentAction;

  Authentication({
    required this.result,
    required this.msg,
    required this.empCode,
    required this.compEmpCode,
    required this.firstName,
    required this.lastName,
    required this.contactNo,
    required this.dateOfJoining,
    required this.dateOfBirth,
    required this.emergencyContactPerson,
    required this.emergencyContactNo,
    required this.emergencyContactRelation,
    required this.bloodGroup,
    required this.category,
    required this.designationCode,
    required this.designationName,
    required this.departmentCode,
    required this.departmentName,
    required this.locationCode,
    required this.locationName,
    required this.locationAddress,
    required this.bankName,
    required this.bankAccountNumber,
    required this.ifscCode,
    required this.entitlement,
    required this.availed,
    required this.balance,
    required this.token,
    required this.employeeImage,
    required this.companyEmailId,
    required this.managerName,
    required this.managerDesignationName,
    required this.managerContactNo,
    required this.isEligibleShortLeave,
    required this.paymentUpload,
    required this.paymentAction,
  });
}
// ChangePasswordModel
class ChangePasswordModel {
 final String Result;
 final String Msg;

 ChangePasswordModel(
 {
  required this.Result,
   required this.Msg,

});
}

