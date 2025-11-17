import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_data_classes.freezed.dart';




@freezed
abstract class LoginObject with _$LoginObject {
 factory LoginObject({
  required String userMobileNumber,
  required String password,
 }) = _LoginObject;
}