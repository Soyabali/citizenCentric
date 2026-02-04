
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
  String sContactNo;
  String sOldPassword;
  String sNewPassword;
  ChangePassWordRequest(this.sContactNo, this.sOldPassword,this.sNewPassword);
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