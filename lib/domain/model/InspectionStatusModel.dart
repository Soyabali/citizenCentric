
class InspectionStatusModel {
  final int iTranNo;
  final int iParkId;
  final String sParkName;
  final String sSectorName;
  final String sDevisionName;
  final String sReportType;
  final double fPaneltyCharges;
  final String sDescription;
  final double fLatitude;
  final double fLongitude;
  final String sGoogleLocation;
  final String sPhoto;
  final String sAgencyName;
  final String sInspBy;
  final String dInspAt;
  final String sStatus;

  InspectionStatusModel({
    required this.iTranNo,
    required this.iParkId,
    required this.sParkName,
    required this.sSectorName,
    required this.sDevisionName,
    required this.sReportType,
    required this.fPaneltyCharges,
    required this.sDescription,
    required this.fLatitude,
    required this.fLongitude,
    required this.sGoogleLocation,
    required this.sPhoto,
    required this.sAgencyName,
    required this.sInspBy,
    required this.dInspAt,
    required this.sStatus,
  });

  /// 🔹 FROM JSON
  factory InspectionStatusModel.fromJson(Map<String, dynamic> json) {
    return InspectionStatusModel(
      iTranNo: json['iTranNo'] ?? 0,
      iParkId: json['iParkId'] ?? 0,
      sParkName: json['sParkName'] ?? '',
      sSectorName: json['sSectorName'] ?? '',
      sDevisionName: json['sDevisionName'] ?? '',
      sReportType: json['sReportType'] ?? '',
      fPaneltyCharges: (json['fPaneltyCharges'] ?? 0).toDouble(),
      sDescription: json['sDescription'] ?? '',
      fLatitude: (json['fLatitude'] ?? 0).toDouble(),
      fLongitude: (json['fLongitude'] ?? 0).toDouble(),
      sGoogleLocation: json['sGoogleLocation'] ?? '',
      sPhoto: json['sPhoto'] ?? '',
      sAgencyName: json['sAgencyName'] ?? '',
      sInspBy: json['sInspBy'] ?? '',
      dInspAt: json['dInspAt'] ?? '',
      sStatus: json['sStatus'] ?? '',
    );
  }

  /// 🔹 TO JSON
  Map<String, dynamic> toJson() {
    return {
      'iTranNo': iTranNo,
      'iParkId': iParkId,
      'sParkName': sParkName,
      'sSectorName': sSectorName,
      'sDevisionName': sDevisionName,
      'sReportType': sReportType,
      'fPaneltyCharges': fPaneltyCharges,
      'sDescription': sDescription,
      'fLatitude': fLatitude,
      'fLongitude': fLongitude,
      'sGoogleLocation': sGoogleLocation,
      'sPhoto': sPhoto,
      'sAgencyName': sAgencyName,
      'sInspBy': sInspBy,
      'dInspAt': dInspAt,
      'sStatus': sStatus,
    };
  }
}
