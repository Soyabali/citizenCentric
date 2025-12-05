class RegistrationModel {
  String name;
  String email;
  String city;

  RegistrationModel({
    required this.name,
    required this.email,
    required this.city,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "city": city,
    };
  }

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      city: json["city"] ?? "",
    );
  }
}
