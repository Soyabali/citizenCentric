class ServerFormModel {
  String userId;
  String description;
  String address;
  String date;
  String status;

  ServerFormModel({
    required this.userId,
    required this.description,
    required this.address,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "description": description,
      "address": address,
      "date": date,
      "status": status,
    };
  }

  factory ServerFormModel.fromJson(Map<String, dynamic> json) {
    return ServerFormModel(
      userId: json["userId"] ?? "",
      description: json["description"] ?? "",
      address: json["address"] ?? "",
      date: json["date"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
