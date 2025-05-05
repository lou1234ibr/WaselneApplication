import 'package:waselne_frontend/pages/add_bus_page.dart';
import 'package:waselne_frontend/pages/add_route_page.dart';
import 'package:waselne_frontend/pages/add_schedule_page.dart';

import 'package:waselne_frontend/pages/booking_confirmation_page.dart';
import 'package:waselne_frontend/pages/customer_reservation.dart';
import 'package:waselne_frontend/pages/landing_page.dart';
import 'package:waselne_frontend/pages/language_selection_page.dart';

import 'package:waselne_frontend/pages/reservation_page.dart';
import 'package:waselne_frontend/pages/search_page.dart';
import 'package:waselne_frontend/pages/search_page_customer.dart';
import 'package:waselne_frontend/pages/search_result_page.dart';
import 'package:waselne_frontend/pages/search_result_page_admin.dart';
import 'package:waselne_frontend/pages/seat_overview.dart';
import 'package:waselne_frontend/pages/seat_plan_page.dart';
import 'package:waselne_frontend/pages/signup.dart';

import 'package:waselne_frontend/providers/app_data_provider.dart';
import 'package:waselne_frontend/providers/language_provider.dart';
import 'package:waselne_frontend/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'pages/faq_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppDataProvider()),
      ChangeNotifierProvider(create: (context) => LanguageProvider(prefs)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bus Reservation',
          theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            scaffoldBackgroundColor: Colors.white,
          ),
          locale: languageProvider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: languageProvider.locale.languageCode == 'ar' 
                ? TextDirection.rtl 
                : TextDirection.ltr,
              child: child!,
            );
          },
          home: const LanguageSelectionPage(),
          routes: {
            routeNameHome: (context) => const SearchPage(),
            '/searchCustomer': (context) => const SearchPageCustomer(),
            routeNameSearchResultPage: (context) => const SearchResultPage(),
            routeNameSeatPlanPage: (context) => const SeatPlanPage(),
            routeNameBookingConfirmationPage: (context) => const BookingConfirmationPage(),
            routeNameAddBusPage: (context) => const AddBusPage(),
            routeNameAddRoutePage: (context) => const AddRoutePage(),
            routeNameAddSchedulePage: (context) => const AddSchedulePage(),
            routeNameReservationPage: (context) => const ReservationPage(),
            routeNameLoginPage: (context) =>  LoginSignupPage(),

            '/searchResultAdmin': (context) => const SearchResultPageAdmin(),

            '/seatOverview': (context) => const SeatOverviewPage(),
            '/signup': (context) => const SignupScreen(),
            '/customerReservation': (context) => const CustomerReservationPage(),
            '/welcome': (context) => const LanguageSelectionPage(),
            '/faq': (context) => const FAQPage(),
          },
        );
      },
    );
  }
}


