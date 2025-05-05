import 'package:waselne_frontend/models/bus_schedule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/bus_route.dart';
import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import 'location_page.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final BusRoute route = argList[0];
    final String departureDate = argList[1];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.searchResults,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.showingResultsFor(route.cityFrom, route.cityTo, departureDate),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AppDataProvider>(
                builder: (context, provider, _) => FutureBuilder<List<BusSchedule>>(
                  future: provider.getSchedulesByRouteNameAndDepartureDate(route.routeName, departureDate),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          l10n.failedToFetchData,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      final scheduleList = snapshot.data!;
                      if (scheduleList.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.noTripsAvailable,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: scheduleList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return ScheduleItemView(schedule: scheduleList[index], date: departureDate);
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleItemView extends StatelessWidget {
  final String date;
  final BusSchedule schedule;

  const ScheduleItemView({Key? key, required this.schedule, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isExpired = _isPastTrip(schedule.departureDate, schedule.departureTime);

    return Opacity(
      opacity: isExpired ? 0.5 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (isExpired) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.tripAlreadyDeparted)),
            );
          } else {
            Navigator.pushNamed(context, routeNameSeatPlanPage, arguments: [schedule, date]);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bus name, type and price
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    schedule.bus.busName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    schedule.bus.busType,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    '\$${schedule.actualTicketPrice}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                // Driver details section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 18, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Driver: ${schedule.bus.driverName}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 18, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Phone: ${schedule.bus.driverPhone}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24),
                // Departure info
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.departureDate}: ${schedule.departureDate}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.departureTime}: ${schedule.departureTime}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Seats info
                Row(
                  children: [
                    const Icon(Icons.event_seat_outlined, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '${l10n.totalSeats}: ${schedule.bus.totalSeat}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Location button
                if (schedule.busRoute.locationLink != null && schedule.busRoute.locationLink!.isNotEmpty)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPage(
                              locationLink: schedule.busRoute.locationLink!,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on),
                      label: Text(l10n.showLocation ?? 'Show Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isPastTrip(String departureDate, String departureTime) {
    try {
      DateTime now = DateTime.now().subtract(const Duration(hours: 1));

      final dateParts = departureDate.split('/');
      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      final timeParts = departureTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;

      final tripDateTime = DateTime(year, month, day, hour, minute);
      return now.isAfter(tripDateTime);
    } catch (e) {
      print('Error parsing date/time: $e');
      return false;
    }
  }
}
