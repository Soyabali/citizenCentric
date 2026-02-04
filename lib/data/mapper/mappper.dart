
import '../../domain/model/model.dart';
import '../responses/response.dart';

const EMPTY = "";
const ZERO = 0;

//-------User DataResponse Mapper


extension UserDataResponseMapper on UserDataResponse {
  Authentication toDomain() {
    return Authentication(
      userId: userId ?? ZERO,
      name: name ?? EMPTY,
      contactNo: contactNo ?? EMPTY,
      designationName: designationName ?? EMPTY,
      designationCode: designationCode ?? ZERO,
      departmentCode: departmentCode ?? ZERO,
      userTypeCode: userTypeCode ?? ZERO,
      token: token ?? EMPTY,
      lastLoginAt: lastLoginAt ?? EMPTY,
      agencyCode: agencyCode ?? ZERO,
    );
  }
}


// extension UserDataResponseMapper on UserDataResponse {
//   User toDomain() {
//     return User(
//       userId: userId ?? ZERO,
//       name: name ?? EMPTY,
//       contactNo: contactNo ?? EMPTY,
//       designationName: designationName ?? EMPTY,
//       designationCode: designationCode ?? ZERO,
//       departmentCode: departmentCode ?? ZERO,
//       userTypeCode: userTypeCode ?? ZERO,
//       token: token ?? EMPTY,
//       lastLoginAt: lastLoginAt ?? EMPTY,
//       agencyCode: agencyCode ?? ZERO,
//     );
//   }
// }


// --------changePassworMapper-------

extension ChangePasswordResponseMapper on ChangePasswordResponse {
  // AuthenticationResponse is a response auto generate file
  // Authentication this is a model class
  ChangePasswordModel toDomain() {
    return ChangePasswordModel(
      //result: result ?? EMPTY,
      //msg: msg ?? EMPTY,
      Result: Result ?? EMPTY,
      Msg: Msg ?? EMPTY,
    );
  }
}
//--------StaffListMapper---------
extension StaffListResponseMapper on StafListResponse {
  // AuthenticationResponse is a response auto generate file
  // Authentication this is a model class
  StaffListModel toDomain() {
    return StaffListModel(
      sEmpCode: sEmpCode ?? EMPTY,
      sEmpName: sEmpName ?? EMPTY,
      sContactNo: sContactNo ?? EMPTY,
      sLocName: sLocName ?? EMPTY,
      sDsgName: sDsgName ?? EMPTY,
      sEmpImage: sEmpImage ?? EMPTY
    );
  }
}