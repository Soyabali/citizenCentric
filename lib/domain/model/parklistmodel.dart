
class ParkListModel {
  final int iParkId;
  final String sParkName;
  final int iNoOfWorkers;
  final String sSupervisor;
  final String sAssetDirector;
  final String sDuptyDirector;
  final String sDirector;
  final String sAgencyName;
  final int iAgencyCode;
  final String fArea;

  ParkListModel({
    required this.iParkId,
    required this.sParkName,
    required this.iNoOfWorkers,
    required this.sSupervisor,
    required this.sAssetDirector,
    required this.sDuptyDirector,
    required this.sDirector,
    required this.sAgencyName,
    required this.iAgencyCode,
    required this.fArea,
  });

  /// 🔹 from JSON
  factory ParkListModel.fromJson(Map<String, dynamic> json) {
    return ParkListModel(
      iParkId: json['iParkId'] ?? 0,
      sParkName: json['sParkName'] ?? '',
      iNoOfWorkers: json['iNoOfWorkers'] ?? 0,
      sSupervisor: json['sSupervisor'] ?? '',
      sAssetDirector: json['sAssetDirector'] ?? '',
      sDuptyDirector: json['sDuptyDirector'] ?? '',
      sDirector: json['sDirector'] ?? '',
      sAgencyName: json['sAgencyName'] ?? '',
      iAgencyCode: json['iAgencyCode'] ?? 0,
      fArea: json['fArea'] ?? '',
    );
  }

  /// 🔹 to JSON (optional, but good practice)
  Map<String, dynamic> toJson() {
    return {
      'iParkId': iParkId,
      'sParkName': sParkName,
      'iNoOfWorkers': iNoOfWorkers,
      'sSupervisor': sSupervisor,
      'sAssetDirector': sAssetDirector,
      'sDuptyDirector': sDuptyDirector,
      'sDirector': sDirector,
      'sAgencyName': sAgencyName,
      'iAgencyCode': iAgencyCode,
      'fArea': fArea,
    };
  }
}
