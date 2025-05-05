import 'dart:convert';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/auth_response_model.dart';
import '../models/bus_model.dart';
import '../models/bus_reservation.dart';
import '../models/bus_route.dart';
import '../models/bus_schedule.dart';
import '../models/customer.dart';
import '../models/error_details_model.dart';
import '../models/payment.dart';
import '../models/response_model.dart';

import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'data_source.dart';

class AppDataSource extends DataSource {
  final String baseUrl = 'http://10.0.2.2:8080/api/';
//address for emulator
  Map<String, String> get header =>
      {
        'Content-Type': 'application/json'
      };
  Future<Map<String, String>> get authHeader async =>
      {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${await getToken()}',
      };

  @override
  Future<AuthResponseModel?> login(AppUser user) async {
    final url = '$baseUrl${'auth/login'}';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: header,
        //we transform the user object to json
        body: json.encode(user.toJson()),//this will give a map
      );
      final map = json.decode(response.body);
      //we will get a map from the response which is json
      //from this map we can create the auth response model object
      print(map);
      final authResponseModel = AuthResponseModel.fromJson(map);
      return authResponseModel;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  Future<ResponseModel<Payment>> makePayment({
    required double amount,
    required int customerId,
    required int reservationId,
    required String paymentMethod,
  }) async {
    final url = Uri.parse('${baseUrl}payments');

    final body = {
      'amount': amount,
      'customerId': customerId,
      'reservationId': reservationId,
      'paymentMethod': paymentMethod,
    };

    try {
      print(' Sending payment: $body');

      final response = await http.post(
        url,
        headers: await authHeader,
        body: json.encode(body),
      );

      print('📥 Payment response: "${response.body}"');

      if (response.body.isEmpty) {
        return ResponseModel<Payment>(
          statusCode: response.statusCode,
          message: 'Server returned an empty response',
          responseStatus: ResponseStatus.FAILED,
          data: null,
        );
      }

      final map = json.decode(response.body);

      if (map['response'] != null && map['response'] is Map<String, dynamic>) {
        final payment = Payment.fromJson(map['response']);

        return ResponseModel<Payment>(
          statusCode: map['statusCode'],
          message: map['message'],
          responseStatus: responseStatusFromString(map['responseStatus'] ?? 'SAVED'),
          data: payment,
        );
      } else {
        return ResponseModel<Payment>(
          statusCode: map['statusCode'] ?? 500,
          message: map['message'] ?? 'Payment failed without message',
          responseStatus: ResponseStatus.FAILED,
          data: null,
        );
      }
    } catch (e) {
      print(' Payment error: $e');
      return ResponseModel<Payment>(
        statusCode: 500,
        message: 'Payment failed: $e',
        responseStatus: ResponseStatus.FAILED,
        data: null,
      );
    }
  }
  Future<List<Payment>> getPaymentsByCustomerId(int customerId) async {
    final url = Uri.parse('${baseUrl}payments/customer/$customerId');
    try {
      final response = await http.get(
        url,
        headers: header,
      );

      final map = json.decode(response.body);

      if (map['data'] == null || map['responseStatus'] != 'SUCCESS') {
        throw Exception(map['message'] ?? 'Failed to fetch payments');
      }

      final List<Payment> payments = (map['data'] as List)
          .map((json) => Payment.fromJson(json))
          .toList();

      return payments;
    } catch (e) {
      print('Error fetching payments: $e');
      return [];
    }
  }


  Future<Customer?> fetchCustomerByUserName(String userName) async {
    final url = Uri.parse('${baseUrl}customer/by-username/$userName');

    try {
      final response = await http.get(url, headers: await authHeader);
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        return Customer.fromJson(map);
      } else {
        debugPrint('Failed to fetch customer: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching customer by username: $e');
      return null;
    }
  }


  @override
  Future<ResponseModel> addBus(Bus bus) async {
    final url = '$baseUrl${'bus/add'}';
    try {
      final response = await http.post(
          Uri.parse(url),
          headers: await authHeader,
          body: json.encode(bus.toJson()));
      return await _getResponseModel(response);
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }


 /* @override
  Future<ResponseModel> addReservation(BusReservation reservation) async {
    final url = '$baseUrl${'reservation/add'}';
    try {
      // Print important data before sending
      print("Sending reservation with schedule ID: ${reservation.busSchedule.scheduleId}");
      print("Sending reservation with customer: ${reservation.customer.customerName}, ${reservation.customer.mobile}");

      final jsonBody = json.encode(reservation.toJson());
      print("Sending reservation JSON: $jsonBody");

      final response = await http.post(
          Uri.parse(url),
          headers: header,
          body: jsonBody
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return ResponseModel(
          responseStatus: ResponseStatus.SAVED,
          statusCode: 200,
          message: 'Reservation saved successfully',
        );
      } else {
        return ResponseModel(
          responseStatus: ResponseStatus.FAILED,
          statusCode: response.statusCode,
          message: 'Failed to save reservation: ${response.body}',
        );
      }
    } catch(error) {
      print("Error adding reservation: ${error.toString()}");
      return ResponseModel(
        responseStatus: ResponseStatus.FAILED,
        statusCode: 500,
        message: 'Error: ${error.toString()}',
      );
    }
  }*/

  Future<ResponseModel<BusReservation>> addReservation(BusReservation reservation) async {
    final url = Uri.parse('${baseUrl}reservation/add');

    try {
      print('Sending reservation: ${reservation.toJson()}');

      final response = await http.post(
        url,
        headers: await authHeader,
        body: json.encode(reservation.toJson()),
      );

      final map = json.decode(response.body);
      print(' Reservation response: ${response.body}');

      if (map['response'] != null && map['response'] is Map<String, dynamic>) {
        final busReservation = BusReservation.fromJson(map['response']);

        return ResponseModel<BusReservation>(
          statusCode: map['statusCode'],
          message: map['message'],
          responseStatus: responseStatusFromString(map['responseStatus'] ?? 'SAVED'),
          data: busReservation,
        );
      } else {
        return ResponseModel<BusReservation>(
          statusCode: map['statusCode'] ?? 500,
          message: map['message'] ?? 'Unknown error',
          responseStatus: ResponseStatus.FAILED,
          data: null,
        );
      }
    } catch (e) {
      print(' Error in addReservation(): $e');
      return ResponseModel<BusReservation>(
        statusCode: 500,
        message: 'Failed to add reservation: $e',
        responseStatus: ResponseStatus.FAILED,
        data: null,
      );
    }
  }


  @override
  Future<ResponseModel> addRoute(BusRoute busRoute) async {
    final url = '$baseUrl${'route/add'}';
    try {
      final response = await http.post(
          Uri.parse(url),
          headers: await authHeader,
          body: json.encode(busRoute.toJson()));
      return await _getResponseModel(response);
      //then we will pass the response that we got
      //then we pass it to a function which will eventually
      //return a response model
    } catch (error) {
      print(error.toString());
      rethrow;
    }

    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> addSchedule(BusSchedule busSchedule) async {
    final url = '$baseUrl${'schedule/add'}';
    try {
      final response = await http.post(
          Uri.parse(url),
          headers: await authHeader,
          body: json.encode(busSchedule.toJson()));
      return await _getResponseModel(response);
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  //this function will give a list of busses
  @override
 Future<List<Bus>> getAllBus() async {
    final url = '$baseUrl${'bus/all'}';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final mapList = json.decode(response.body) as List;
        return List.generate(mapList.length, (index) => Bus.fromJson(mapList[index]));
      }
      return [];
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<BusReservation>> getAllReservation() async  {
    final url = '$baseUrl${'reservation/all'}';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final mapList = json.decode(response.body) as List;
        return List.generate(mapList.length, (index) => BusReservation.fromJson(mapList[index]));
      }
      return [];
    } catch (error) {
      rethrow;
    }
  }

 @override
  Future<List<BusRoute>> getAllRoutes() async {
    final url = '$baseUrl${'route/all'}';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final mapList = json.decode(response.body) as List;
        return List.generate(mapList.length, (index) => BusRoute.fromJson(mapList[index]));
      }
      return [];
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<BusSchedule>> getAllSchedules() {
    // TODO: implement getAllSchedules
    throw UnimplementedError();
  }

  @override
  Future<List<BusReservation>> getReservationsByMobile(String mobile) async {
    final url = '$baseUrl${'reservation/all/$mobile'}';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final mapList = json.decode(response.body) as List;
        return List.generate(mapList.length, (index) => BusReservation.fromJson(mapList[index]));
      }
      return [];
    } catch (error) {
      return [];
    }
  }

 @override
  Future<List<BusReservation>> getReservationsByScheduleAndDepartureDate(
      int scheduleId, String departureDate) async {
    final url = '$baseUrl${'reservation/query?scheduleId=$scheduleId&departureDate=$departureDate'}';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final mapList = json.decode(response.body) as List;
        return List.generate(mapList.length, (index) => BusReservation.fromJson(mapList[index]));
      }
      return [];
    } catch (error) {
      return [];
    }
  }

 @override
  Future<BusRoute?> getRouteByCityFromAndCityTo(String cityFrom,
      String cityTo) async {
   //here i am passing the city from cito two as parameters
    final url = '$baseUrl${'route/query?cityFrom=$cityFrom&cityTo=$cityTo'}';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final map = json.decode(response.body);
        return BusRoute.fromJson(map);
      }
      return null;
    }catch(error) {
      rethrow;
    }
  }






 @override
  Future<List<BusSchedule>> getSchedulesByRouteName(String routeName) async {
    final url = '$baseUrl${'schedule/$routeName'}';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final mapList = json.decode(response.body) as List;
        return List.generate(mapList.length, (index) => BusSchedule.fromJson(mapList[index]));
      }
      return [];
    } catch(error) {
      return [];
    }
  }

  Future<ResponseModel>_getResponseModel(http.Response response) async {
    ResponseStatus status = ResponseStatus.NONE;
    ResponseModel responseModel = ResponseModel();
    if(response.statusCode == 200) {
      status = ResponseStatus.SAVED;
      responseModel = ResponseModel.fromJson(jsonDecode(response.body));
      responseModel.responseStatus = status;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if(await hasTokenExpired()) {
        status = ResponseStatus.EXPIRED;
      } else {
        status = ResponseStatus.UNAUTHORIZED;
      }
      responseModel = ResponseModel(
        responseStatus: status,
        statusCode: 401,
        message: 'Access denied. Please login as Admin',
      );
    } else if(response.statusCode == 500 || response.statusCode == 400) {
      final json = jsonDecode(response.body);
      final errorDetails = ErrorDetails.fromJson(json);
      status = ResponseStatus.FAILED;
      responseModel = ResponseModel(
        responseStatus: status,
        statusCode: 500,
        message: errorDetails.errorMessage,
      );
    }
    return responseModel;
  }

  @override
  Future<BusRoute?> getRouteByRouteName(String routeName) {
    // TODO: implement getRouteByRouteName
    throw UnimplementedError();
  }

  Future<bool> signup(AppUser user, Customer customer) async {
    final url = Uri.parse('${baseUrl}auth/signup');

    final body = jsonEncode({
      'userName': user.userName,
      'password': user.password,
      'customerName': customer.customerName,
      'mobile': customer.mobile,
      'email': customer.email,
    });

    try {
      final response = await http.post(url, headers: header, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Signup failed: ${response.statusCode}, ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error during signup: $e");
      return false;
    }
  }
  Future<ResponseModel> cancelReservation(int reservationId) async {
    final url = Uri.parse('${baseUrl}reservation/$reservationId/cancel');

    try {
      final response = await http.put(
        url,
        headers: await authHeader,
      );

      if (response.statusCode == 200) {
        return ResponseModel(
          responseStatus: ResponseStatus.SAVED,
          statusCode: 200,
          message: 'Reservation cancelled successfully.',
        );
      } else {
        final body = json.decode(response.body);
        return ResponseModel(
          responseStatus: ResponseStatus.FAILED,
          statusCode: response.statusCode,
          message: body is String ? body : (body['message'] ?? 'Failed to cancel'),
        );
      }
    } catch (e) {
      return ResponseModel(
        responseStatus: ResponseStatus.FAILED,
        statusCode: 500,
        message: 'Error cancelling reservation: $e',
      );
    }
  }




}