import 'package:waselne_frontend/models/reservation_expansion_item.dart';
import 'package:waselne_frontend/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationItemHeaderView extends StatelessWidget {
  final ReservationExpansionHeader header;

  const ReservationItemHeaderView({Key? key, required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final bookingDate = header.timestamp > 0
        ? getFormattedDate(
      DateTime.fromMillisecondsSinceEpoch(header.timestamp),
      pattern: 'EEE, MMM dd yyyy • HH:mm',
    )
        : l10n.notAvailable;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${header.departureDate} • ${header.schedule.departureTime}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${header.schedule.busRoute.routeName} — ${header.schedule.bus.busType}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.bookingTime}: $bookingDate',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

