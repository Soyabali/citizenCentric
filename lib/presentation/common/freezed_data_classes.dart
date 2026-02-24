import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_data_classes.freezed.dart';


@freezed
abstract class LoginObject with _$LoginObject {
 factory LoginObject({
  required String userMobileNumber,
  required String password,
  required String appVersion,
 }) = _LoginObject;
}
// changePasswordObject
@freezed
abstract class ChangePasswordObject with _$ChangePasswordObject {
 factory ChangePasswordObject({
  required String sOldPassword,
  required String sNewPassword,
  required String iUserId,
 }) = _ChangePasswordObject;
}

// ----StaffListObject----

@freezed
abstract class StaffListObject with _$StaffListObject {
 factory StaffListObject({
  required String sEmpCode,

 }) = _StaffListObject;
}
// InspectionList

@freezed
abstract class InspectionListObject with _$InspectionListObject {
 factory InspectionListObject({
  required String iUserId,

 }) = _InspectionListObject;
}