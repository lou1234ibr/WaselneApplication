class Bus {
  int? busId;
  String busName;
  String busType;
  int totalSeat;
  String busNumber;
  String driverName;
  int driverPhone;


  Bus({
    this.busId,
    required this.busName,
    required this.busType,
    required this.totalSeat,
    required this.busNumber,
    required this.driverName,
    required this.driverPhone,

  });

  Bus copyWith({
    int? busId,
    String? busName,
    String? busType,
    int? totalSeat,
    String? busNumber,
    String? driverName,
    int? driverPhone,

  }) {
    return Bus(
      busId: busId ?? this.busId,
      busName: busName ?? this.busName,
      busType: busType ?? this.busType,
      totalSeat: totalSeat ?? this.totalSeat,
      busNumber: busNumber ?? this.busNumber,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,

    );
  }

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['busId'] as int?,
      busName: json['busName'] as String,
      busType: json['busType'] as String,
      totalSeat: (json['totalSeat'] as num).toInt(),
      busNumber: json['busNumber'] as String,
      driverName: json['driverName'] as String,
      driverPhone: json['driverPhone'] as int,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'busName': busName,
      'busType': busType,
      'totalSeat': totalSeat,
      'busNumber': busNumber,
      'driverName': driverName,
      'driverPhone': driverPhone,

    };
  }

  @override
  String toString() {
    return 'Bus(busId: $busId, busName: $busName, busType: $busType, totalSeat: $totalSeat, busNumber: $busNumber, driverName: $driverName, driverPhone: $driverPhone)';
  }
}
