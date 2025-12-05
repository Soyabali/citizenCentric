class LoginModel {
  String mobile;
  String password;

  LoginModel({
    required this.mobile,
    required this.password,
  });

  // Convert Model → Map (for Hive or API)
  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile,
      "password": password,
    };
  }

  // Convert Map → Model (for Hive or API)
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      mobile: json["mobile"] ?? "",
      password: json["password"] ?? "",
    );
  }
}
