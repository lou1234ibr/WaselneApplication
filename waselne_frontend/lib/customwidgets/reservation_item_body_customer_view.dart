import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/reservation_expansion_item.dart';
import '../utils/constants.dart';

class ReservationItemBodyCustomerView extends StatelessWidget {
  final ReservationExpansionBody body;
  const ReservationItemBodyCustomerView({Key? key, required this.body}) : super(key: key);

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(l10n.totalSeats, body.totalSeatsBooked.toString()),
          _row(l10n.seatNumbers, body.seatNumbers),
          _row(l10n.totalPrice, '\$${body.totalPrice}'),

        ],
      ),
    );
  }
}

