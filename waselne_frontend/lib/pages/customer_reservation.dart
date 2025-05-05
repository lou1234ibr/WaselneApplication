import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../customwidgets/reservation_item_body_customer_view.dart';
import '../customwidgets/reservation_item_header_view.dart';
import '../models/reservation_expansion_item.dart';
import '../providers/app_data_provider.dart';
import '../utils/helper_functions.dart';

class CustomerReservationPage extends StatefulWidget {
  const CustomerReservationPage({Key? key}) : super(key: key);

  @override
  State<CustomerReservationPage> createState() => _CustomerReservationPageState();
}

class _CustomerReservationPageState extends State<CustomerReservationPage> {
  bool isLoading = true;
  bool hasError = false;
  bool isFirst = true;
  List<ReservationExpansionItem> items = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirst) {
      _loadReservationsForCustomer();
      isFirst = false;
    }
  }

  Future<void> _loadReservationsForCustomer() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final provider = Provider.of<AppDataProvider>(context, listen: false);
      final mobile = provider.customer?.mobile;
      if (mobile == null || mobile.isEmpty) {
        throw Exception(l10n.customerMobileNotAvailable);
      }

      final reservations = await provider.getReservationsByMobile(mobile);
      final expansionItems = provider.getExpansionItems(reservations);


      expansionItems.sort((a, b) {
        final aDateStr = '${a.header.schedule.departureDate} ${a.header.schedule.departureTime}';
        final bDateStr = '${b.header.schedule.departureDate} ${b.header.schedule.departureTime}';
        final aDate = DateFormat('dd/MM/yyyy HH:mm').parse(aDateStr);
        final bDate = DateFormat('dd/MM/yyyy HH:mm').parse(bDateStr);
        return bDate.compareTo(aDate); // descending order
      });

      setState(() {
        items = expansionItems;
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
      showMsg(context, l10n.loadReservationsError);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> cancelReservationOnServer(int reservationId) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/reservation/$reservationId/cancel');

    try {
      final token = await getToken(); // from helper_functions.dart
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Cancel response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        showMsg(context, response.body);
        return false;
      }
    } catch (e) {
      print("Error during cancellation: $e");
      showMsg(context, 'Something went wrong. Try again later.');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.myReservations,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadReservationsForCustomer,
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[700]!, Colors.green[50]!],
            stops: const [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            if (isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.green[700],
                    strokeWidth: 3,
                  ),
                ),
              ),

            if (hasError)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
                      const SizedBox(height: 16),
                      Text(
                        l10n.errorLoadingReservations,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

            if (!isLoading && !hasError)
              Expanded(
                child: items.isEmpty ? _buildEmptyState(l10n) : _buildReservationList(l10n),
              ),

            if (!isLoading && !hasError)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Text(
                        l10n.findBuses,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 70, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              l10n.noReservationsFound,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noReservationsFound,
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.search),
              label: Text(l10n.findBuses),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green[700],
                side: BorderSide(color: Colors.green[700]!),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationList(AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final departureDate = item.header.schedule.departureDate;
        final departureTime = item.header.schedule.departureTime;
        DateTime? departureDateTime;
        try {
          departureDateTime = DateFormat('dd/MM/yyyy HH:mm').parseStrict('$departureDate $departureTime');
        } catch (e) {
          departureDateTime = null;
        }

        final now = DateTime.now();
        final canCancel = item.header.reservationStatus != 'CANCELLED' &&
            departureDateTime != null &&
            departureDateTime.isAfter(now.add(const Duration(hours: 2)));

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              colorScheme: ColorScheme.light(primary: Colors.green[700]!),
            ),
            child: ExpansionTile(
              key: Key('reservation_${item.header.reservationId}'),
              initiallyExpanded: item.isExpanded,
              onExpansionChanged: (isExpanded) {
                setState(() {
                  items[index] = item.copyWith(isExpanded: isExpanded);
                });
              },
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(Icons.confirmation_number_outlined, color: Colors.green[700]),
              ),
              title: ReservationItemHeaderView(header: item.header),
              children: [
                Divider(color: Colors.grey[300]),
                ReservationItemBodyCustomerView(body: item.body),
                const SizedBox(height: 12),
                if (canCancel)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(l10n.confirmCancelTitle),
                            content: Text(l10n.confirmCancelMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(l10n.confirmCancelNo),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                                child: Text(l10n.confirmCancelYes),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          final success = await cancelReservationOnServer(item.header.reservationId!);
                          if (success) {
                            setState(() {
                              items[index] = item.copyWith(
                                header: item.header.copyWith(reservationStatus: 'CANCELLED'),
                              );
                            });
                            showMsg(context, l10n.cancelSuccess);
                          } else {
                            showMsg(context, l10n.cancelFailed);
                          }
                        }
                      },
                      icon: const Icon(Icons.cancel),
                      label: Text(l10n.cancelBooking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                if (item.header.reservationStatus == 'CANCELLED')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      l10n.cancelled,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
