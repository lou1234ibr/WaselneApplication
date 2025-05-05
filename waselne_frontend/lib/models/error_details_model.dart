class ErrorDetails {
  final int errorCode;
  final String errorMessage;
  final String devErrorMessage;
  final int timestamp;

  // Constructor
  ErrorDetails({
    required this.errorCode,
    required this.errorMessage,
    required this.devErrorMessage,
    required this.timestamp,
  });

  // copyWith method
  ErrorDetails copyWith({
    int? errorCode,
    String? errorMessage,
    String? devErrorMessage,
    int? timestamp,
  }) {
    return ErrorDetails(
      errorCode: errorCode ?? this.errorCode,
      errorMessage: errorMessage ?? this.errorMessage,
      devErrorMessage: devErrorMessage ?? this.devErrorMessage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // fromJson factory
  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    return ErrorDetails(
      errorCode: json['errorCode'] ?? 0,
      errorMessage: json['errorMessage'] ?? '',
      devErrorMessage: json['devErrorMessage'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'devErrorMessage': devErrorMessage,
      'timestamp': timestamp,
    };
  }

  // toString method
  @override
  String toString() {
    return 'ErrorDetails(errorCode: $errorCode, errorMessage: $errorMessage, devErrorMessage: $devErrorMessage, timestamp: $timestamp)';
  }
}
