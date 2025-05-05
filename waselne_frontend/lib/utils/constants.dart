const String currency = 'Dollars';
const String busTypeNonAc = 'NON-AC';
const String busTypeACEconomy = 'AC-ECONOMY';
const String busTypeACBusiness = 'AC-BUSINESS';
const String reservationConfirmed = 'Confirmed';
const String reservationCancelled = 'Cancelled';
const String reservationActive = 'Active';
const String reservationExpired = 'Expired';
const String emptyFieldErrMessage = 'This field must not be empty';
const String emptyDateErrMessage = 'Please select a Departure Date';
const String accessToken = 'accessToken';
const String loginTime = 'loginTime';
const String expirationDuration = 'expirationDuration';
const String routeNameHome = 'search';
const String routeNameSearchResultPage = 'search_result';
const String routeNameLoginPage = 'login';
const String routeNameSeatPlanPage = 'seat_plan';
const String routeNameBookingConfirmationPage = 'booking_confirmation';
const String routeNameAddBusPage = 'add_bus';
const String routeNameAddRoutePage = 'add_route';
const String routeNameAddSchedulePage = 'add_schedule';
const String routeNameScheduleListPage = 'schedule_list';
const String routeNameReservationPage = 'reservation';

const String busTypeMinibus = 'Minibus';
const String busTypeCoach = 'Coach Bus';
const String busTypeSchool = 'School Bus';
const String busTypePrivateVan = 'Private Van';
const String busTypePublic = 'Public Bus';
const String busTypeServiceVan = 'Service Van';

const busTypes = [
  busTypeMinibus,
  busTypeCoach,
  busTypeSchool,
  busTypePrivateVan,
  busTypePublic,
  busTypeServiceVan,
];

const cities = [
  'Adliyeh',
  'Saida',
  'Tripoli',
  'Byblos',
  'Aley',
  'Nabatieh',
  'Baalbek',
  'Choueifat',
  'Chamsine Bakery, Khaldeh',
  'Ghaziyeh',
];

enum ResponseStatus {
  SAVED,
  FAILED,
  UNAUTHORIZED,
  AUTHORIZED,
  EXPIRED,
  NONE,
}

// Converts a string to a ResponseStatus enum
ResponseStatus responseStatusFromString(String value) {
  return ResponseStatus.values.firstWhere(
        (e) => e.toString().split('.').last == value,
    orElse: () => ResponseStatus.NONE,
  );
}

// Converts a ResponseStatus enum to a string
String responseStatusToString(ResponseStatus status) {
  return status.toString().split('.').last;
}




const seatLabelList = ['A','B','C','D','E','F','G','H','I','J','K','L'];

