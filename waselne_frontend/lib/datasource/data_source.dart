import 'package:waselne_frontend/models/customer.dart';

import '../models/app_user.dart';
import '../models/auth_response_model.dart';
import '../models/bus_model.dart';
import '../models/bus_reservation.dart';
import '../models/bus_schedule.dart';
import '../models/bus_route.dart';
import '../models/payment.dart';
import '../models/response_model.dart';


abstract class DataSource {
  Future<AuthResponseModel?> login(AppUser user);
  Future<ResponseModel> addBus(Bus bus);
  Future<List<Bus>> getAllBus();
  Future<ResponseModel> addRoute(BusRoute busRoute);
  Future<List<BusRoute>> getAllRoutes();
  Future<BusRoute?> getRouteByRouteName(String routeName);
  Future<BusRoute?> getRouteByCityFromAndCityTo(String cityFrom, String cityTo);
  Future<ResponseModel> addSchedule(BusSchedule busSchedule);
  Future<List<BusSchedule>> getAllSchedules();
  Future<List<BusSchedule>> getSchedulesByRouteName(String routeName);
  Future<ResponseModel> addReservation(BusReservation reservation);
  Future<List<BusReservation>> getAllReservation();
  Future<List<BusReservation>> getReservationsByMobile(String mobile);
  Future<List<BusReservation>> getReservationsByScheduleAndDepartureDate(int scheduleId, String departureDate);

  Future<bool> signup(AppUser user, Customer customer);

  Future<Customer?> fetchCustomerByUserName(String userName);



  Future<ResponseModel> makePayment({
    required double amount,
    required int customerId,
    required int reservationId,
    required String paymentMethod,

  });
  Future<List<Payment>> getPaymentsByCustomerId(int customerId);
  Future<ResponseModel> cancelReservation(int reservationId);

}