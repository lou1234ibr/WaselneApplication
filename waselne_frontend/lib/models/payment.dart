enum PaymentStatus {
  PAID,
  FAILED,
  PENDING,
}

enum PaymentMethod {
  WALLET,
  CREDIT_CARD,
  DEBIT_CARD,
  BANK_TRANSFER,
  CASH,
}

class Payment {
  int? paymentId;
  double amount;
  DateTime timestamp;
  int customerId;
  int reservationId;
  PaymentStatus status;
  PaymentMethod paymentMethod;
  String? referenceCode;

  Payment({
    this.paymentId,
    required this.amount,
    required this.timestamp,
    required this.customerId,
    required this.reservationId,
    required this.status,
    required this.paymentMethod,
    this.referenceCode,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'] as int?,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      customerId: json['customer']['customerId'],
      reservationId: json['reservation']['reservationId'],
      status: PaymentStatus.values.firstWhere(
              (e) => e.name == json['status'],
          orElse: () => PaymentStatus.PENDING),
      paymentMethod: PaymentMethod.values.firstWhere(
              (e) => e.name == json['paymentMethod'],
          orElse: () => PaymentMethod.WALLET),
      referenceCode: json['referenceCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'customerId': customerId,
      'reservationId': reservationId,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
    };
  }
}
