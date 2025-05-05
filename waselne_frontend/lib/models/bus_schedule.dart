import 'bus_model.dart';
import 'bus_route.dart';

class BusSchedule {
  int? scheduleId;
  Bus bus;
  BusRoute busRoute;
  String departureDate;
  String departureTime;
  int ticketPrice;
  int discount;
  int processingFee;

  BusSchedule({
    this.scheduleId,
    required this.bus,
    required this.busRoute,
    required this.departureDate,
    required this.departureTime,
    required this.ticketPrice,
    this.discount = 0,
    this.processingFee = 50,
  });

  // Create a copy of this BusSchedule with the given fields replaced
  BusSchedule copyWith({
    int? scheduleId,
    Bus? bus,
    BusRoute? busRoute,
    String? departureDate,
    String? departureTime,
    int? ticketPrice,
    int? discount,
    int? processingFee,
  }) {
    return BusSchedule(
      scheduleId: scheduleId ?? this.scheduleId,
      bus: bus ?? this.bus,
      busRoute: busRoute ?? this.busRoute,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      discount: discount ?? this.discount,
      processingFee: processingFee ?? this.processingFee,
    );
  }

  // Convert from JSON
  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      scheduleId: json['scheduleId'] as int?,
      bus: Bus.fromJson(json['bus'] as Map<String, dynamic>),
      busRoute: BusRoute.fromJson(json['busRoute'] as Map<String, dynamic>),
      departureDate: json['departureDate'] as String, // <-- NEW
      departureTime: json['departureTime'] as String,
      ticketPrice: json['ticketPrice'] as int,
      discount: json['discount'] as int? ?? 0,
      processingFee: json['processingFee'] as int? ?? 50,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'bus': bus.toJson(),
      'busRoute': busRoute.toJson(),
      'departureDate': departureDate,
      'departureTime': departureTime,
      'ticketPrice': ticketPrice,
      'discount': discount,
      'processingFee': processingFee,
    };
  }

  // Get the final ticket price after discount
  int get actualTicketPrice => ticketPrice - discount;

  // Get the total price including processing fee
  int get totalPrice => actualTicketPrice + processingFee;

  @override
  String toString() {
    return 'BusSchedule(scheduleId: $scheduleId, bus: $bus, busRoute: $busRoute, '
        'departureDate: $departureDate, departureTime: $departureTime, '
        'ticketPrice: $ticketPrice, discount: $discount, processingFee: $processingFee)';
  }
}
