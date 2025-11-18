
import '../../domain/model/model.dart';
import '../responses/response.dart';

const EMPTY = "";
const ZERO = 0;

extension AuthenticationResponseMapper on AuthenticationResponse {
  // AuthenticationResponse is a response auto generate file
  // Authentication this is a model class
  Authentication toDomain() {
    return Authentication(
      result: result ?? EMPTY,
      msg: msg ?? EMPTY,
      empCode: empCode ?? EMPTY,
      compEmpCode: compEmpCode ?? EMPTY,
      firstName: firstName ?? EMPTY,
      lastName: lastName ?? EMPTY,
      contactNo: contactNo ?? EMPTY,
      dateOfJoining: dateOfJoining ?? EMPTY,
      dateOfBirth: dateOfBirth ?? EMPTY,
      emergencyContactPerson: emergencyContactPerson ?? EMPTY,
      emergencyContactNo: emergencyContactNo ?? EMPTY,
      emergencyContactRelation: emergencyContactRelation ?? EMPTY,
      bloodGroup: bloodGroup ?? EMPTY,
      category: category ?? EMPTY,
      designationCode: designationCode ?? EMPTY,
      designationName: designationName ?? EMPTY,
      departmentCode: departmentCode ?? EMPTY,
      departmentName: departmentName ?? EMPTY,
      locationCode: locationCode ?? EMPTY,
      locationName: locationName ?? EMPTY,
      locationAddress: locationAddress ?? EMPTY,
      bankName: bankName ?? EMPTY,
      bankAccountNumber: bankAccountNumber ?? EMPTY,
      ifscCode: ifscCode ?? EMPTY,
      entitlement: entitlement ?? EMPTY,
      availed: availed ?? EMPTY,
      balance: balance ?? EMPTY,
      token: token ?? EMPTY,
      employeeImage: employeeImage ?? EMPTY,
      companyEmailId: companyEmailId ?? EMPTY,
      managerName: managerName ?? EMPTY,
      managerDesignationName: managerDesignationName ?? EMPTY,
      managerContactNo: managerContactNo ?? EMPTY,
      isEligibleShortLeave: isEligibleShortLeave ?? EMPTY,
      paymentUpload: paymentUpload ?? EMPTY,
      paymentAction: paymentAction ?? EMPTY,

    );
  }
}