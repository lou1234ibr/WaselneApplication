class Customer {
  int? customerId;
  String customerName;
  String mobile;
  String email;
  double walletBalance;

  Customer({
    this.customerId,
    required this.customerName,
    required this.mobile,
    required this.email,
    this.walletBalance = 0.0,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customerId'] as int?,
      customerName: json['customerName'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      walletBalance: (json['walletBalance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'mobile': mobile,
      'email': email,
      'walletBalance': walletBalance,
    };
  }
}
