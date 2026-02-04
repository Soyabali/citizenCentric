// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freezed_data_classes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginObject {

 String get userMobileNumber; String get password; String get appVersion;
/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginObjectCopyWith<LoginObject> get copyWith => _$LoginObjectCopyWithImpl<LoginObject>(this as LoginObject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginObject&&(identical(other.userMobileNumber, userMobileNumber) || other.userMobileNumber == userMobileNumber)&&(identical(other.password, password) || other.password == password)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}


@override
int get hashCode => Object.hash(runtimeType,userMobileNumber,password,appVersion);

@override
String toString() {
  return 'LoginObject(userMobileNumber: $userMobileNumber, password: $password, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class $LoginObjectCopyWith<$Res>  {
  factory $LoginObjectCopyWith(LoginObject value, $Res Function(LoginObject) _then) = _$LoginObjectCopyWithImpl;
@useResult
$Res call({
 String userMobileNumber, String password, String appVersion
});




}
/// @nodoc
class _$LoginObjectCopyWithImpl<$Res>
    implements $LoginObjectCopyWith<$Res> {
  _$LoginObjectCopyWithImpl(this._self, this._then);

  final LoginObject _self;
  final $Res Function(LoginObject) _then;

/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userMobileNumber = null,Object? password = null,Object? appVersion = null,}) {
  return _then(_self.copyWith(
userMobileNumber: null == userMobileNumber ? _self.userMobileNumber : userMobileNumber // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginObject].
extension LoginObjectPatterns on LoginObject {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginObject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginObject() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginObject value)  $default,){
final _that = this;
switch (_that) {
case _LoginObject():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginObject value)?  $default,){
final _that = this;
switch (_that) {
case _LoginObject() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userMobileNumber,  String password,  String appVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginObject() when $default != null:
return $default(_that.userMobileNumber,_that.password,_that.appVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userMobileNumber,  String password,  String appVersion)  $default,) {final _that = this;
switch (_that) {
case _LoginObject():
return $default(_that.userMobileNumber,_that.password,_that.appVersion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userMobileNumber,  String password,  String appVersion)?  $default,) {final _that = this;
switch (_that) {
case _LoginObject() when $default != null:
return $default(_that.userMobileNumber,_that.password,_that.appVersion);case _:
  return null;

}
}

}

/// @nodoc


class _LoginObject implements LoginObject {
   _LoginObject({required this.userMobileNumber, required this.password, required this.appVersion});
  

@override final  String userMobileNumber;
@override final  String password;
@override final  String appVersion;

/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginObjectCopyWith<_LoginObject> get copyWith => __$LoginObjectCopyWithImpl<_LoginObject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginObject&&(identical(other.userMobileNumber, userMobileNumber) || other.userMobileNumber == userMobileNumber)&&(identical(other.password, password) || other.password == password)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}


@override
int get hashCode => Object.hash(runtimeType,userMobileNumber,password,appVersion);

@override
String toString() {
  return 'LoginObject(userMobileNumber: $userMobileNumber, password: $password, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class _$LoginObjectCopyWith<$Res> implements $LoginObjectCopyWith<$Res> {
  factory _$LoginObjectCopyWith(_LoginObject value, $Res Function(_LoginObject) _then) = __$LoginObjectCopyWithImpl;
@override @useResult
$Res call({
 String userMobileNumber, String password, String appVersion
});




}
/// @nodoc
class __$LoginObjectCopyWithImpl<$Res>
    implements _$LoginObjectCopyWith<$Res> {
  __$LoginObjectCopyWithImpl(this._self, this._then);

  final _LoginObject _self;
  final $Res Function(_LoginObject) _then;

/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userMobileNumber = null,Object? password = null,Object? appVersion = null,}) {
  return _then(_LoginObject(
userMobileNumber: null == userMobileNumber ? _self.userMobileNumber : userMobileNumber // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChangePasswordObject {

 String get sContactNo; String get sOldPassword; String get sNewPassword;
/// Create a copy of ChangePasswordObject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordObjectCopyWith<ChangePasswordObject> get copyWith => _$ChangePasswordObjectCopyWithImpl<ChangePasswordObject>(this as ChangePasswordObject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordObject&&(identical(other.sContactNo, sContactNo) || other.sContactNo == sContactNo)&&(identical(other.sOldPassword, sOldPassword) || other.sOldPassword == sOldPassword)&&(identical(other.sNewPassword, sNewPassword) || other.sNewPassword == sNewPassword));
}


@override
int get hashCode => Object.hash(runtimeType,sContactNo,sOldPassword,sNewPassword);

@override
String toString() {
  return 'ChangePasswordObject(sContactNo: $sContactNo, sOldPassword: $sOldPassword, sNewPassword: $sNewPassword)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordObjectCopyWith<$Res>  {
  factory $ChangePasswordObjectCopyWith(ChangePasswordObject value, $Res Function(ChangePasswordObject) _then) = _$ChangePasswordObjectCopyWithImpl;
@useResult
$Res call({
 String sContactNo, String sOldPassword, String sNewPassword
});




}
/// @nodoc
class _$ChangePasswordObjectCopyWithImpl<$Res>
    implements $ChangePasswordObjectCopyWith<$Res> {
  _$ChangePasswordObjectCopyWithImpl(this._self, this._then);

  final ChangePasswordObject _self;
  final $Res Function(ChangePasswordObject) _then;

/// Create a copy of ChangePasswordObject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sContactNo = null,Object? sOldPassword = null,Object? sNewPassword = null,}) {
  return _then(_self.copyWith(
sContactNo: null == sContactNo ? _self.sContactNo : sContactNo // ignore: cast_nullable_to_non_nullable
as String,sOldPassword: null == sOldPassword ? _self.sOldPassword : sOldPassword // ignore: cast_nullable_to_non_nullable
as String,sNewPassword: null == sNewPassword ? _self.sNewPassword : sNewPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangePasswordObject].
extension ChangePasswordObjectPatterns on ChangePasswordObject {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangePasswordObject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePasswordObject() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangePasswordObject value)  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordObject():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangePasswordObject value)?  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordObject() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sContactNo,  String sOldPassword,  String sNewPassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePasswordObject() when $default != null:
return $default(_that.sContactNo,_that.sOldPassword,_that.sNewPassword);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sContactNo,  String sOldPassword,  String sNewPassword)  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordObject():
return $default(_that.sContactNo,_that.sOldPassword,_that.sNewPassword);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sContactNo,  String sOldPassword,  String sNewPassword)?  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordObject() when $default != null:
return $default(_that.sContactNo,_that.sOldPassword,_that.sNewPassword);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePasswordObject implements ChangePasswordObject {
   _ChangePasswordObject({required this.sContactNo, required this.sOldPassword, required this.sNewPassword});
  

@override final  String sContactNo;
@override final  String sOldPassword;
@override final  String sNewPassword;

/// Create a copy of ChangePasswordObject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePasswordObjectCopyWith<_ChangePasswordObject> get copyWith => __$ChangePasswordObjectCopyWithImpl<_ChangePasswordObject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePasswordObject&&(identical(other.sContactNo, sContactNo) || other.sContactNo == sContactNo)&&(identical(other.sOldPassword, sOldPassword) || other.sOldPassword == sOldPassword)&&(identical(other.sNewPassword, sNewPassword) || other.sNewPassword == sNewPassword));
}


@override
int get hashCode => Object.hash(runtimeType,sContactNo,sOldPassword,sNewPassword);

@override
String toString() {
  return 'ChangePasswordObject(sContactNo: $sContactNo, sOldPassword: $sOldPassword, sNewPassword: $sNewPassword)';
}


}

/// @nodoc
abstract mixin class _$ChangePasswordObjectCopyWith<$Res> implements $ChangePasswordObjectCopyWith<$Res> {
  factory _$ChangePasswordObjectCopyWith(_ChangePasswordObject value, $Res Function(_ChangePasswordObject) _then) = __$ChangePasswordObjectCopyWithImpl;
@override @useResult
$Res call({
 String sContactNo, String sOldPassword, String sNewPassword
});




}
/// @nodoc
class __$ChangePasswordObjectCopyWithImpl<$Res>
    implements _$ChangePasswordObjectCopyWith<$Res> {
  __$ChangePasswordObjectCopyWithImpl(this._self, this._then);

  final _ChangePasswordObject _self;
  final $Res Function(_ChangePasswordObject) _then;

/// Create a copy of ChangePasswordObject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sContactNo = null,Object? sOldPassword = null,Object? sNewPassword = null,}) {
  return _then(_ChangePasswordObject(
sContactNo: null == sContactNo ? _self.sContactNo : sContactNo // ignore: cast_nullable_to_non_nullable
as String,sOldPassword: null == sOldPassword ? _self.sOldPassword : sOldPassword // ignore: cast_nullable_to_non_nullable
as String,sNewPassword: null == sNewPassword ? _self.sNewPassword : sNewPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$StaffListObject {

 String get sEmpCode;
/// Create a copy of StaffListObject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffListObjectCopyWith<StaffListObject> get copyWith => _$StaffListObjectCopyWithImpl<StaffListObject>(this as StaffListObject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffListObject&&(identical(other.sEmpCode, sEmpCode) || other.sEmpCode == sEmpCode));
}


@override
int get hashCode => Object.hash(runtimeType,sEmpCode);

@override
String toString() {
  return 'StaffListObject(sEmpCode: $sEmpCode)';
}


}

/// @nodoc
abstract mixin class $StaffListObjectCopyWith<$Res>  {
  factory $StaffListObjectCopyWith(StaffListObject value, $Res Function(StaffListObject) _then) = _$StaffListObjectCopyWithImpl;
@useResult
$Res call({
 String sEmpCode
});




}
/// @nodoc
class _$StaffListObjectCopyWithImpl<$Res>
    implements $StaffListObjectCopyWith<$Res> {
  _$StaffListObjectCopyWithImpl(this._self, this._then);

  final StaffListObject _self;
  final $Res Function(StaffListObject) _then;

/// Create a copy of StaffListObject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sEmpCode = null,}) {
  return _then(_self.copyWith(
sEmpCode: null == sEmpCode ? _self.sEmpCode : sEmpCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffListObject].
extension StaffListObjectPatterns on StaffListObject {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffListObject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffListObject() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffListObject value)  $default,){
final _that = this;
switch (_that) {
case _StaffListObject():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffListObject value)?  $default,){
final _that = this;
switch (_that) {
case _StaffListObject() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sEmpCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffListObject() when $default != null:
return $default(_that.sEmpCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sEmpCode)  $default,) {final _that = this;
switch (_that) {
case _StaffListObject():
return $default(_that.sEmpCode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sEmpCode)?  $default,) {final _that = this;
switch (_that) {
case _StaffListObject() when $default != null:
return $default(_that.sEmpCode);case _:
  return null;

}
}

}

/// @nodoc


class _StaffListObject implements StaffListObject {
   _StaffListObject({required this.sEmpCode});
  

@override final  String sEmpCode;

/// Create a copy of StaffListObject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffListObjectCopyWith<_StaffListObject> get copyWith => __$StaffListObjectCopyWithImpl<_StaffListObject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffListObject&&(identical(other.sEmpCode, sEmpCode) || other.sEmpCode == sEmpCode));
}


@override
int get hashCode => Object.hash(runtimeType,sEmpCode);

@override
String toString() {
  return 'StaffListObject(sEmpCode: $sEmpCode)';
}


}

/// @nodoc
abstract mixin class _$StaffListObjectCopyWith<$Res> implements $StaffListObjectCopyWith<$Res> {
  factory _$StaffListObjectCopyWith(_StaffListObject value, $Res Function(_StaffListObject) _then) = __$StaffListObjectCopyWithImpl;
@override @useResult
$Res call({
 String sEmpCode
});




}
/// @nodoc
class __$StaffListObjectCopyWithImpl<$Res>
    implements _$StaffListObjectCopyWith<$Res> {
  __$StaffListObjectCopyWithImpl(this._self, this._then);

  final _StaffListObject _self;
  final $Res Function(_StaffListObject) _then;

/// Create a copy of StaffListObject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sEmpCode = null,}) {
  return _then(_StaffListObject(
sEmpCode: null == sEmpCode ? _self.sEmpCode : sEmpCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
