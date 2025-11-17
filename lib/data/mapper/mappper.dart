
import '../../domain/model/model.dart';
import '../responses/response.dart';

const EMPTY = "";
const ZERO = 0;

extension AuthenticationResponseMapper on AuthenticationResponse {
  Authentication toDomain() {
    return Authentication(
      result: result ?? "",
      msg: msg ?? "",
      empCode: empCode ?? "",
      compEmpCode: compEmpCode ?? "",
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      contactNo: contactNo ?? "",
      dateOfJoining: dateOfJoining ?? "",
      dateOfBirth: dateOfBirth ?? "",
      emergencyContactPerson: emergencyContactPerson ?? "",
      emergencyContactNo: emergencyContactNo ?? "",
      emergencyContactRelation: emergencyContactRelation ?? "",
      bloodGroup: bloodGroup ?? "",
      category: category ?? "",
      designationCode: designationCode ?? "",
      designationName: designationName ?? "",
      departmentCode: departmentCode ?? "",
      departmentName: departmentName ?? "",
      locationCode: locationCode ?? "",
      locationName: locationName ?? "",
      locationAddress: locationAddress ?? "",

      bankName: bankName ?? "",
      bankAccountNumber: bankAccountNumber ?? "",
      ifscCode: ifscCode ?? "",
      entitlement: entitlement ?? "",
      availed: availed ?? "",
      balance: balance ?? "",
      token: token ?? "",
      employeeImage: employeeImage ?? "",
      companyEmailId: companyEmailId ?? "",
      managerName: managerName ?? "",
      managerDesignationName: managerDesignationName ?? "",
      managerContactNo: managerContactNo ?? "",
      isEligibleShortLeave: isEligibleShortLeave ?? "",
      paymentUpload: paymentUpload ?? "",
      paymentAction: paymentAction ?? "",

    );
  }
}