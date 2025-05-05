import 'bus_schedule.dart';
import 'customer.dart';

class BusReservation {
  int? reservationId;
  Customer customer;
  BusSchedule busSchedule;
  int timestamp;
  String departureDate;
  int totalSeatBooked;
  String seatNumbers;
  String reservationStatus;
  int totalPrice;



  BusReservation({
    this.reservationId,
    required this.customer,
    required this.busSchedule,
    required this.timestamp,
    required this.departureDate,
    required this.totalSeatBooked,
    required this.seatNumbers,
    required this.reservationStatus,
    required this.totalPrice,
  });

  // Create a copy of this BusReservation with the given fields replaced
  BusReservation copyWith({
    int? reservationId,
    Customer? customer,
    BusSchedule? busSchedule,
    int? timestamp,
    String? departureDate,
    int? totalSeatBooked,
    String? seatNumbers,
    String? reservationStatus,
    int? totalPrice,
  }) {
    return BusReservation(
      reservationId: reservationId ?? this.reservationId,
      customer: customer ?? this.customer,
      busSchedule: busSchedule ?? this.busSchedule,
      timestamp: timestamp ?? this.timestamp,
      departureDate: departureDate ?? this.departureDate,
      totalSeatBooked: totalSeatBooked ?? this.totalSeatBooked,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      reservationStatus: reservationStatus ?? this.reservationStatus,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  // Convert from JSON
  factory BusReservation.fromJson(Map<String, dynamic> json) {
    return BusReservation(
      reservationId: json['reservationId'] as int?,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      busSchedule: BusSchedule.fromJson(json['busSchedule'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as int,
      departureDate: json['departureDate'] as String,
      totalSeatBooked: json['totalSeatBooked'] as int,
      seatNumbers: json['seatNumbers'] as String,
      reservationStatus: json['reservationStatus'] as String,
      totalPrice: json['totalPrice'] as int,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'reservationId': reservationId,
      'customer': customer.toJson(),
      'busSchedule': busSchedule.toJson(),
      'timestamp': timestamp,
      'departureDate': departureDate,
      'totalSeatBooked': totalSeatBooked,
      'seatNumbers': seatNumbers,
      'reservationStatus': reservationStatus,
      'totalPrice': totalPrice,
    };
  }

  // Get the price per seat
  int get pricePerSeat => totalSeatBooked > 0 ? (totalPrice ~/ totalSeatBooked) : 0;

  @override
  String toString() {
    return 'BusReservation(reservationId: $reservationId, customer: $customer, '
        'busSchedule: $busSchedule, timestamp: $timestamp, '
        'departureDate: $departureDate, totalSeatBooked: $totalSeatBooked, '
        'seatNumbers: $seatNumbers, reservationStatus: $reservationStatus, '
        'totalPrice: $totalPrice)';
  }
}