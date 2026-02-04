
class AllParkLocationModel {
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
  final double fLatitude;
  final double fLongitude;
  final String sGoogleLocation;
  final String sParkPhoto;

  AllParkLocationModel({
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
    required this.fLatitude,
    required this.fLongitude,
    required this.sGoogleLocation,
    required this.sParkPhoto,
  });

  /// ✅ From JSON
  factory AllParkLocationModel.fromJson(Map<String, dynamic> json) {
    return AllParkLocationModel(
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
      fLatitude: (json['fLatitude'] as num?)?.toDouble() ?? 0.0,
      fLongitude: (json['fLongitude'] as num?)?.toDouble() ?? 0.0,
      sGoogleLocation: json['sGoogleLocation'] ?? '',
      sParkPhoto: json['sParkPhoto'] ?? '',
    );
  }

  /// ✅ To JSON (optional, useful for caching or POST)
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
      'fLatitude': fLatitude,
      'fLongitude': fLongitude,
      'sGoogleLocation': sGoogleLocation,
      'sParkPhoto': sParkPhoto,
    };
  }
}
