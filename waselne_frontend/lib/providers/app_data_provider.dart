import 'package:flutter/material.dart';

import '../datasource/app_data_source.dart';
import '../datasource/data_source.dart';

import '../models/app_user.dart';
import '../models/auth_response_model.dart';
import '../models/bus_model.dart';
import '../models/bus_reservation.dart';
import '../models/bus_route.dart';
import '../models/bus_schedule.dart';

import '../models/customer.dart';
import '../models/payment.dart';
import '../models/reservation_expansion_item.dart';
import '../models/response_model.dart';

import '../utils/helper_functions.dart';

class AppDataProvider extends ChangeNotifier {
  //any function hone i create it and it will call the dummydata source function
  //dummy data source
  List<Bus> _busList = [];
  List<BusRoute> _routeList = [];
  List<BusReservation> _reservationList = [];
  List<BusSchedule> _scheduleList = [];

  List<BusSchedule> get scheduleList => _scheduleList;

  List<Bus> get busList => _busList;

  List<BusRoute> get routeList => _routeList;

  List<BusReservation> get reservationList => _reservationList;

  Customer? _customer;

  Customer? get customer => _customer;

  void setCustomer(Customer customer) {
    _customer = customer;
    notifyListeners();
  }


  final DataSource _dataSource = AppDataSource();


  //
  Future<Customer?> fetchCustomerByUserName(String userName) {
    return _dataSource.fetchCustomerByUserName(userName);
  }

// Add the signup function here
  Future<bool> signup(AppUser user, Customer customer) async {
    final success = await _dataSource.signup(user, customer);
    return success;
  }
  Future<AuthResponseModel?> login(AppUser user) async {
    final response = await _dataSource.login(user);
    if(response == null) return null;
    await saveToken(response.accessToken);
    await saveLoginTime(response.loginTime);
    await saveExpirationDuration(response.expirationDuration);
    return response;


  }
  Future<ResponseModel> addBus(Bus bus) {
    return _dataSource.addBus(bus);
  }

  Future<ResponseModel> makePayment({
    required double amount,
    required int customerId,
    required int reservationId,
    required String paymentMethod,
    String? referenceCode,
  }) {
    return _dataSource.makePayment(
      amount: amount,
      customerId: customerId,
      reservationId: reservationId,
      paymentMethod: paymentMethod,

    );
  }



  Future<ResponseModel> addRoute(BusRoute route) {
    return _dataSource.addRoute(route);
  }

  Future<ResponseModel> addSchedule(BusSchedule busSchedule) {
    return _dataSource.addSchedule(busSchedule);
  }

  Future<ResponseModel> addReservation(BusReservation reservation) {
    return _dataSource.addReservation(reservation);
  }

  Future<List<Payment>> getPaymentsByCustomerId(int customerId) {
    return _dataSource.getPaymentsByCustomerId(customerId);
  }


  Future<void> getAllBus() async { //it will not return anything
    //because all bus will be assigned to the bus list above
    _busList = await _dataSource.getAllBus();
    notifyListeners();// so that any widget that uses this bus list will be notified
  }

  Future<void> getAllBusRoutes() async {//same here it will
    _routeList = await _dataSource.getAllRoutes();
    notifyListeners();
  }

  Future<List<BusReservation>> getAllReservations() async {
    _reservationList = await _dataSource.getAllReservation();
    notifyListeners();
    return _reservationList;
  }

  Future<List<BusReservation>> getReservationsByMobile(String mobile) {
    return _dataSource.getReservationsByMobile(mobile);
  }

  Future<BusRoute?> getRouteByCityFromAndCityTo(
      String cityFrom, String cityTo) {
    return _dataSource.getRouteByCityFromAndCityTo(cityFrom, cityTo);
  }

  Future<List<BusSchedule>> getSchedulesByRouteName(String routeName) async {
    return _dataSource.getSchedulesByRouteName(routeName);
  }

  Future<List<BusReservation>> getReservationsByScheduleAndDepartureDate(
      int scheduleId, String departureDate) {
    return _dataSource.getReservationsByScheduleAndDepartureDate(
        scheduleId, departureDate);
  }

  List<ReservationExpansionItem> getExpansionItems(List<BusReservation> reservationList) {
    return List.generate(reservationList.length, (index) {
      final reservation = reservationList[index];
      return ReservationExpansionItem(
        header: ReservationExpansionHeader(
          reservationId: reservation.reservationId,
          departureDate: reservation.departureDate,
          schedule: reservation.busSchedule,
          timestamp: reservation.timestamp,
          reservationStatus: reservation.reservationStatus,
        ),
        body: ReservationExpansionBody(
          customer: reservation.customer,
          totalSeatsBooked: reservation.totalSeatBooked,
          seatNumbers: reservation.seatNumbers,
          totalPrice: reservation.totalPrice,
        ),
      );
    });
  }
  Future<List<BusSchedule>> getSchedulesByRouteNameAndDepartureDate(String routeName, String departureDate) async {
    final allSchedules = await _dataSource.getSchedulesByRouteName(routeName);
    return allSchedules.where((schedule) => schedule.departureDate == departureDate).toList();
  }






}
