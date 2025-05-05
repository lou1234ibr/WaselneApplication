import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../customwidgets/seat_plan_view.dart';
import '../models/bus_schedule.dart';
import '../providers/app_data_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class SeatOverviewPage extends StatefulWidget {
  const SeatOverviewPage({Key? key}) : super(key: key);

  @override
  State<SeatOverviewPage> createState() => _SeatOverviewPageState();
}

class _SeatOverviewPageState extends State<SeatOverviewPage> {
  late BusSchedule schedule;
  late String departureDate;
  int totalSeatBooked = 0;
  String bookedSeatNumbers = '';
  List<String> selectedSeats = [];
  bool isFirst = true;
  bool isDataLoading = true;
  ValueNotifier<String> selectedSeatStringNotifier = ValueNotifier('');

  @override
  void didChangeDependencies() {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    schedule = argList[0];
    departureDate = argList[1];
    _getData();
    super.didChangeDependencies();
  }

  Future<void> _getData() async {
    final resList = await Provider.of<AppDataProvider>(context, listen: false)
        .getReservationsByScheduleAndDepartureDate(schedule.scheduleId!, departureDate);

    List<String> seats = [];
    totalSeatBooked = 0;

    for (final res in resList) {
      if (res.reservationStatus.toLowerCase() != 'cancelled') {
        totalSeatBooked += res.totalSeatBooked;
        seats.add(res.seatNumbers);
      }
    }

    bookedSeatNumbers = seats.join(',');

    setState(() {
      isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.seatPlan,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendBox(seatBookedColor, l10n.booked),
                  const SizedBox(width: 20),
                  _buildLegendBox(seatAvailableColor, l10n.available),
                ],
              ),
              const SizedBox(height: 16),

              // Selected seat display
              ValueListenableBuilder(
                valueListenable: selectedSeatStringNotifier,
                builder: (context, value, _) => Text(
                  '${l10n.selected}: $value',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),

              // Seat layout
              if (!isDataLoading)
                Expanded(
                  child: SingleChildScrollView(
                    child: SeatPlanView(
                      onSeatSelected: (value, seat) {
                        if (value) {
                          selectedSeats.add(seat);
                        } else {
                          selectedSeats.remove(seat);
                        }
                        selectedSeatStringNotifier.value = selectedSeats.join(',');
                      },
                      totalSeatBooked: totalSeatBooked,
                      bookedSeatNumbers: bookedSeatNumbers,
                      totalSeat: schedule.bus.totalSeat,
                      isBusinessClass: schedule.bus.busType == busTypeACBusiness,
                    ),
                  ),
                )
              else
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendBox(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
