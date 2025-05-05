import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/bus_reservation.dart';
import '../models/bus_schedule.dart';
import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  late BusSchedule schedule;
  late String departureDate;
  late int totalSeatsBooked;
  late String seatNumbers;
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      final argList = ModalRoute.of(context)!.settings.arguments as List;
      departureDate = argList[0];
      schedule = argList[1];
      seatNumbers = argList[2];
      totalSeatsBooked = argList[3];
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customer = Provider.of<AppDataProvider>(context).customer;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.bookingSummaryTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: customer == null
          ? Center(child: Text(l10n.noCustomerData))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(l10n.customerName, customer.customerName),
                    _infoRow(l10n.mobileNumber, customer.mobile),
                    _infoRow(l10n.emailAddress, customer.email),
                    const Divider(),
                    _infoRow(l10n.route, schedule.busRoute.routeName),
                    _infoRow(l10n.departureDate, departureDate),
                    _infoRow(l10n.departureTime, schedule.departureTime),
                    const Divider(),
                    _infoRow(l10n.ticketPrice, '${schedule.ticketPrice}'),
                    _infoRow(l10n.discount, '${schedule.discount}%'),
                    _infoRow(l10n.processingFee, '${schedule.processingFee}'),
                    _infoRow(l10n.totalSeats, '$totalSeatsBooked'),
                    _infoRow(l10n.seatNumbers, seatNumbers),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.grandTotal,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${getGrandTotal(schedule.discount, totalSeatsBooked, schedule.ticketPrice, schedule.processingFee)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _confirmBooking,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l10n.confirmBooking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() async {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    final customer = provider.customer;

    //  Show enhanced confirmation dialog before paying
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Colors.orange[700], size: 28),
            const SizedBox(width: 8),
            Text(l10n.confirmPaymentTitle, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            l10n.confirmPaymentMessage,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.confirmPaymentCancel),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(l10n.confirmPaymentPay),
          ),
        ],
      ),
    );

    if (confirm != true) return; // User cancelled

    final grandTotal = getGrandTotal(
      schedule.discount,
      totalSeatsBooked,
      schedule.ticketPrice,
      schedule.processingFee,
    );
    if (customer == null) {
      showMsg(context, l10n.noCustomerLoggedIn);
      return;
    }
    if (customer.walletBalance! < grandTotal) {
      showMsg(
        context,
        l10n.insufficientBalance(
          grandTotal,
          customer.walletBalance?.toStringAsFixed(0) ?? '0',
        ),
      );
      return;
    }
    final reservation = BusReservation(
      customer: customer,
      busSchedule: schedule,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      departureDate: departureDate,
      totalSeatBooked: totalSeatsBooked,
      seatNumbers: seatNumbers,
      reservationStatus: reservationActive,
      totalPrice: grandTotal,
    );

    try {
      final reservationResponse = await provider.addReservation(reservation);

      if (reservationResponse.responseStatus == ResponseStatus.SAVED &&
          reservationResponse.data != null) {

        final createdReservation = reservationResponse.data as BusReservation;
        final reservationId = createdReservation.reservationId;

        if (reservationId == null) {
          showMsg(context, l10n.noReservationId);
          return;
        }

        final paymentResult = await provider.makePayment(
          amount: grandTotal.toDouble(),
          customerId: customer.customerId!,
          reservationId: reservationId,
          paymentMethod: 'WALLET',
        );

        if (paymentResult.responseStatus == ResponseStatus.SAVED) {
          // Send confirmation email
          final emailSent = await _sendConfirmationEmail(
            customer.email,
            customer.customerName,
            reservationId.toString(),
            schedule.busRoute.routeName,
            departureDate,
            schedule.departureTime,
            seatNumbers,
            totalSeatsBooked,
            grandTotal,
          );

          // 2. Show enhanced thank you dialog
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: 28),
                  const SizedBox(width: 8),
                  Text(l10n.paymentSuccessTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  emailSent 
                    ? l10n.paymentSuccessMessage
                    : l10n.paymentSuccessNoEmail,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.paymentSuccessOK, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );

          // 3. Redirect to search page
          Navigator.of(context).pushNamedAndRemoveUntil('/searchCustomer', (route) => false);
        }
      }
    } catch (e) {
      showMsg(context,';(');
    }
  }

  Future<bool> _sendConfirmationEmail(
      String email,
      String customerName,
      String reservationId,
      String routeName,
      String departureDate,
      String departureTime,
      String seatNumbers,
      int totalSeats,
      num totalPrice
      ) async {
    final l10n = AppLocalizations.of(context)!;
    final smtpServer = gmail('hamzand02@gmail.com', 'zjhn ofzg svdq ughn');

    final message = Message()
      ..from = Address('hamzand02@gmail.com', 'Bus Booking System')
      ..recipients.add(email)
      ..subject = l10n.emailSubject(reservationId)
      ..html = '''
      <h2>${l10n.reservationConfirmation}</h2>
      <p>${l10n.dearCustomer(customerName)}</p>
      <p>${l10n.thankYouForBooking}</p>
      <table border="0" cellpadding="5" style="border-collapse: collapse;">
        <tr><td><strong>${l10n.reservationId}:</strong></td><td>$reservationId</td></tr>
        <tr><td><strong>${l10n.route}:</strong></td><td>$routeName</td></tr>
        <tr><td><strong>${l10n.departureDate}:</strong></td><td>$departureDate</td></tr>
        <tr><td><strong>${l10n.departureTime}:</strong></td><td>$departureTime</td></tr>
        <tr><td><strong>${l10n.seatNumbers}:</strong></td><td>$seatNumbers</td></tr>
        <tr><td><strong>${l10n.totalSeats}:</strong></td><td>$totalSeats</td></tr>
        <tr><td><strong>${l10n.totalAmount}:</strong></td><td>$currency$totalPrice</td></tr>
      </table>
      <p>${l10n.arrivalTime}</p>
      <p>${l10n.contactCustomerService}</p>
      <p>${l10n.thankYouForService}</p>
    ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
