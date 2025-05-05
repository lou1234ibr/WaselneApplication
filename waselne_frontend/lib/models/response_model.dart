import '../utils/constants.dart';

class ResponseModel<T> {
  ResponseStatus responseStatus;
  int statusCode;
  String message;
  T? data;

  ResponseModel({
    this.responseStatus = ResponseStatus.SAVED,
    this.statusCode = 200,
    this.message = 'Saved',
    this.data,
  });

  ResponseModel<T> copyWith({
    ResponseStatus? responseStatus,
    int? statusCode,
    String? message,
    T? data,
  }) {
    return ResponseModel<T>(
      responseStatus: responseStatus ?? this.responseStatus,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  // Important: Let each call handle data parsing externally if needed
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel<T>(
      responseStatus: responseStatusFromString(json['responseStatus'] ?? 'SAVED'),
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? 'Saved',
      // Leave data as raw here, parse it in the calling function
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseStatus': responseStatusToString(responseStatus),
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'ResponseModel(responseStatus: $responseStatus, statusCode: $statusCode, message: $message, data: $data)';
  }
}
