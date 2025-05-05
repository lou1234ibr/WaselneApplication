class BusRoute {
  int? routeId;
  String routeName;
  String cityFrom;
  String cityTo;
  double distanceInKm;
  String? locationLink;

  BusRoute({
    this.routeId,
    required this.routeName,
    required this.cityFrom,
    required this.cityTo,
    required this.distanceInKm,
    this.locationLink,
  });

  BusRoute copyWith({
    int? routeId,
    String? routeName,
    String? cityFrom,
    String? cityTo,
    double? distanceInKm,
    String? locationLink,
  }) {
    return BusRoute(
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      cityFrom: cityFrom ?? this.cityFrom,
      cityTo: cityTo ?? this.cityTo,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      locationLink: locationLink ?? this.locationLink,
    );
  }

  // Convert from JSON
  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      routeId: json['routeId'] as int?,
      routeName: json['routeName'] as String,
      cityFrom: json['cityFrom'] as String,
      cityTo: json['cityTo'] as String,
      distanceInKm: (json['distanceInKm'] as num).toDouble(),
      locationLink: json['locationLink'] as String?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'routeId': routeId,
      'routeName': routeName,
      'cityFrom': cityFrom,
      'cityTo': cityTo,
      'distanceInKm': distanceInKm,
      'locationLink': locationLink,
    };
  }

  @override
  String toString() {
    return 'BusRoute(routeId: $routeId, routeName: $routeName, cityFrom: $cityFrom, cityTo: $cityTo, distanceInKm: $distanceInKm, locationLink: $locationLink)';
  }
}