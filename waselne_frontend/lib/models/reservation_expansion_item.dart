import 'package:waselne_frontend/models/customer.dart';
import '../models/bus_schedule.dart';

class ReservationExpansionItem {
  ReservationExpansionHeader header;
  ReservationExpansionBody body;
  bool isExpanded;

  ReservationExpansionItem({
    required this.header,
    required this.body,
    this.isExpanded = false,
  });

  ReservationExpansionItem copyWith({
    ReservationExpansionHeader? header,
    ReservationExpansionBody? body,
    bool? isExpanded,
  }) {
    return ReservationExpansionItem(
      header: header ?? this.header,
      body: body ?? this.body,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class ReservationExpansionHeader {
  int? reservationId;
  String departureDate;
  BusSchedule schedule;
  int timestamp;
  String reservationStatus;

  ReservationExpansionHeader({
    required this.reservationId,
    required this.departureDate,
    required this.schedule,
    required this.timestamp,
    required this.reservationStatus,
  });

  // ✅ copyWith added
  ReservationExpansionHeader copyWith({
    int? reservationId,
    String? departureDate,
    BusSchedule? schedule,
    int? timestamp,
    String? reservationStatus,
  }) {
    return ReservationExpansionHeader(
      reservationId: reservationId ?? this.reservationId,
      departureDate: departureDate ?? this.departureDate,
      schedule: schedule ?? this.schedule,
      timestamp: timestamp ?? this.timestamp,
      reservationStatus: reservationStatus ?? this.reservationStatus,
    );
  }
}

class ReservationExpansionBody {
  Customer customer;
  int totalSeatsBooked;
  String seatNumbers;
  int totalPrice;

  ReservationExpansionBody({
    required this.customer,
    required this.totalSeatsBooked,
    required this.seatNumbers,
    required this.totalPrice,
  });

  ReservationExpansionBody copyWith({
    Customer? customer,
    int? totalSeatsBooked,
    String? seatNumbers,
    int? totalPrice,
  }) {
    return ReservationExpansionBody(
      customer: customer ?? this.customer,
      totalSeatsBooked: totalSeatsBooked ?? this.totalSeatsBooked,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
