import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_data_classes.freezed.dart';


@freezed
abstract class LoginObject with _$LoginObject {
 factory LoginObject({
  required String userMobileNumber,
  required String password,
 }) = _LoginObject;
}
// changePasswordObject
@freezed
abstract class ChangePasswordObject with _$ChangePasswordObject {
 factory ChangePasswordObject({
  required String sContactNo,
  required String sOldPassword,
  required String sNewPassword,
 }) = _ChangePasswordObject;
}
// ----StaffListObject----
@freezed
abstract class StaffListObject with _$StaffListObject {
 factory StaffListObject({
  required String sEmpCode,

 }) = _StaffListObject;
}