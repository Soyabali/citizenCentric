class ParkModel {
  final int iParkId;
  final String sParkName;
  final String dContactStart;
  final String dContractEnd;
  final double fContractAmt;
  final int iNoOfWorkers;
  final double fAreaOfPart;
  final double fLatitude;
  final double fLongitude;
  final String sDevisionName;
  final String sSectorName;
  final String sAgencyName;
  final String sParkPhoto;
  final String sParkDist;

  ParkModel({
    required this.iParkId,
    required this.sParkName,
    required this.dContactStart,
    required this.dContractEnd,
    required this.fContractAmt,
    required this.iNoOfWorkers,
    required this.fAreaOfPart,
    required this.fLatitude,
    required this.fLongitude,
    required this.sDevisionName,
    required this.sSectorName,
    required this.sAgencyName,
    required this.sParkPhoto,
    required this.sParkDist,
  });

  /// 🔹 Create object from API JSON
  factory ParkModel.fromJson(Map<String, dynamic> json) {
    return ParkModel(
      iParkId: json['iParkId'] ?? 0,
      sParkName: json['sParkName'] ?? '',
      dContactStart: json['dContactStart'] ?? '',
      dContractEnd: json['dContractEnd'] ?? '',
      fContractAmt: (json['fContractAmt'] as num?)?.toDouble() ?? 0.0,
      iNoOfWorkers: json['iNoOfWorkers'] ?? 0,
      fAreaOfPart: (json['fAreaOfPart'] as num?)?.toDouble() ?? 0.0,
      fLatitude: (json['fLatitude'] as num?)?.toDouble() ?? 0.0,
      fLongitude: (json['fLongitude'] as num?)?.toDouble() ?? 0.0,
      sDevisionName: json['sDevisionName'] ?? '',
      sSectorName: json['sSectorName'] ?? '',
      sAgencyName: json['sAgencyName'] ?? '',
      sParkPhoto: json['sParkPhoto'] ?? '',
      sParkDist: json['sParkDist'] ?? '',
    );
  }

  /// 🔹 Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'iParkId': iParkId,
      'sParkName': sParkName,
      'dContactStart': dContactStart,
      'dContractEnd': dContractEnd,
      'fContractAmt': fContractAmt,
      'iNoOfWorkers': iNoOfWorkers,
      'fAreaOfPart': fAreaOfPart,
      'fLatitude': fLatitude,
      'fLongitude': fLongitude,
      'sDevisionName': sDevisionName,
      'sSectorName': sSectorName,
      'sAgencyName': sAgencyName,
      'sParkPhoto': sParkPhoto,
      'sParkDist': sParkDist,
    };
  }

  /// ✅ HUMAN-READABLE DEBUG OUTPUT
  @override
  String toString() {
    return '''
ParkModel {
  iParkId: $iParkId,
  sParkName: $sParkName,
  sAgencyName: $sAgencyName,
  sSectorName: $sSectorName,
  sDevisionName: $sDevisionName,
  fLatitude: $fLatitude,
  fLongitude: $fLongitude,
  fContractAmt: $fContractAmt,
  iNoOfWorkers: $iNoOfWorkers,
  fAreaOfPart: $fAreaOfPart,
  dContactStart: $dContactStart,
  dContractEnd: $dContractEnd,
  sParkDist: $sParkDist
}
''';
  }
}
