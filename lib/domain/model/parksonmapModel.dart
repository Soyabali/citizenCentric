class ParksonmapModel {
  final String parkName;
  final String sectorName;
  final double latitude;
  final double longitude;
  final String location;
  final String userImage;
  final String photo;
  final String divisionName;
  final String agencyName;
  final String supervisorName;
  final String asstDirectorName;
  final String deputyDirectorName;
  final String directorName;
  final String contractStart;
  final String contractEnd;
  final double contractAmount;
  final int noOfWorkers;
  final String areaOfPart;

  ParksonmapModel({
    required this.parkName,
    required this.sectorName,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.userImage,
    required this.photo,
    required this.divisionName,
    required this.agencyName,
    required this.supervisorName,
    required this.asstDirectorName,
    required this.deputyDirectorName,
    required this.directorName,
    required this.contractStart,
    required this.contractEnd,
    required this.contractAmount,
    required this.noOfWorkers,
    required this.areaOfPart,
  });

  /// 🔹 FROM JSON
  factory ParksonmapModel.fromJson(Map<String, dynamic> json) {
    return ParksonmapModel(
      parkName: json['sParkName'] ?? '',
      sectorName: json['sSectorName'] ?? '',
      latitude: (json['Latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['Longitude'] as num?)?.toDouble() ?? 0.0,
      location: json['sLocation'] ?? '',
      userImage: json['sUserImage'] ?? '',
      photo: json['sPhoto'] ?? '',
      divisionName: json['sDevisionName'] ?? '',
      agencyName: json['sAgencyName'] ?? '',
      supervisorName: json['sSupervisorName'] ?? '',
      asstDirectorName: json['sAsstDirectorName'] ?? '',
      deputyDirectorName: json['sDuptyDirectorName'] ?? '',
      directorName: json['sDirectorName'] ?? '',
      contractStart: json['dContactStart'] ?? '',
      contractEnd: json['dContractEnd'] ?? '',
      contractAmount: (json['fContractAmt'] as num?)?.toDouble() ?? 0.0,
      noOfWorkers: json['iNoOfWorkers'] ?? 0,
      areaOfPart: json['fAreaOfPart'] ?? '',
    );
  }

  /// 🔹 TO JSON (Optional – useful for POST / cache)
  Map<String, dynamic> toJson() {
    return {
      'sParkName': parkName,
      'sSectorName': sectorName,
      'Latitude': latitude,
      'Longitude': longitude,
      'sLocation': location,
      'sUserImage': userImage,
      'sPhoto': photo,
      'sDevisionName': divisionName,
      'sAgencyName': agencyName,
      'sSupervisorName': supervisorName,
      'sAsstDirectorName': asstDirectorName,
      'sDuptyDirectorName': deputyDirectorName,
      'sDirectorName': directorName,
      'dContactStart': contractStart,
      'dContractEnd': contractEnd,
      'fContractAmt': contractAmount,
      'iNoOfWorkers': noOfWorkers,
      'fAreaOfPart': areaOfPart,
    };
  }
  @override
  String toString() {
    return '''
ParksonmapModel(
  parkName: $parkName,
  sectorName: $sectorName,
  latitude: $latitude,
  longitude: $longitude,
  location: $location,
  divisionName: $divisionName,
  agencyName: $agencyName,
  supervisorName: $supervisorName,
  asstDirectorName: $asstDirectorName,
  deputyDirectorName: $deputyDirectorName,
  directorName: $directorName,
  contractStart: $contractStart,
  contractEnd: $contractEnd,
  contractAmount: $contractAmount,
  noOfWorkers: $noOfWorkers,
  areaOfPart: $areaOfPart
)
''';
  }
}
