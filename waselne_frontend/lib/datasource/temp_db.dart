
import '../models/bus_model.dart';
import '../models/bus_reservation.dart';
import '../models/bus_schedule.dart';
import '../models/bus_route.dart';
import '../utils/constants.dart';

class TempDB {


  static List<BusRoute> tableRoute = [
    BusRoute(routeId: 1, routeName: 'Beirut - Tripoli', cityFrom: 'Beirut, Hamra', cityTo: 'Tripoli', distanceInKm: 85),
    BusRoute(routeId: 2, routeName: 'Tripoli - Saida', cityFrom: 'Tripoli', cityTo: 'Saida', distanceInKm: 120),
    BusRoute(routeId: 3, routeName: 'Saida - Baalbek', cityFrom: 'Saida', cityTo: 'Baalbek', distanceInKm: 140),
    BusRoute(routeId: 4, routeName: 'Byblos - Aley', cityFrom: 'Byblos', cityTo: 'Aley', distanceInKm: 60),
  ];


  static List<BusReservation> tableReservation = [];
}