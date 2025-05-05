import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/reservation_expansion_item.dart';
import '../utils/constants.dart';

class ReservationItemBodyView extends StatelessWidget {
  final ReservationExpansionBody body;
  const ReservationItemBodyView({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${l10n.customerName}: ${body.customer.customerName}'),
          Text('${l10n.customerMobile}: ${body.customer.mobile}'),
          Text('${l10n.customerEmail}: ${body.customer.email}'),
          Text('${l10n.totalSeats}: ${body.totalSeatsBooked}'),
          Text('${l10n.seatNumbers}: ${body.seatNumbers}'),
          Text('${l10n.totalPrice}: $currency ${body.totalPrice}'),
        ],
      ),
    );
  }
}
