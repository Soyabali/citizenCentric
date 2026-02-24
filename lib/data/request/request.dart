
// this is LoginRequest file in this file i write the login body parameter such as
// sContactNo and sPassword.

class LoginRequest {
  String sContactNo;
  String sPassword;
  String sAppVersion;
  LoginRequest(this.sContactNo, this.sPassword,this.sAppVersion);
}
//  ----changePasswordRequest

class ChangePassWordRequest {
  String sOldPassword;
  String sNewPassword;
  String iUserId;
  ChangePassWordRequest(this.sOldPassword,this.sNewPassword,this.iUserId);
}

// ---------StaffListRequest---------

class StaffListRequest {
  String sEmpCode;
  // constructor
  StaffListRequest(this.sEmpCode);

  Map<String, dynamic> toJson() => {
    "sEmpCode": sEmpCode,
  };
}
//  InspectionListRequest
class InspectionListRequest {
  String iUserId;
  // constructor
  InspectionListRequest(this.iUserId);

  Map<String, dynamic> toJson() => {
    "iUserId": iUserId,
  };
}
// CountDashboardRequest
class CountDashboardRequest {
  String iUserId;
  // constructor
  CountDashboardRequest(this.iUserId);

  Map<String, dynamic> toJson() => {
    "iUserId": iUserId,
  };
}
//    Agency Wise Details---.

class ParkListByAgencyRequest {
  String iAgencyCode;
  // constructor
  ParkListByAgencyRequest(this.iAgencyCode);

  Map<String, dynamic> toJson() => {
    "iAgencyCode": iAgencyCode,
  };
}