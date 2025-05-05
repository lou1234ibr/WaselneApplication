import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../customwidgets/reservation_item_body_view.dart';
import '../customwidgets/reservation_item_header_view.dart';
import '../customwidgets/search_box.dart';
import '../models/reservation_expansion_item.dart';
import '../providers/app_data_provider.dart';
import '../utils/helper_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  bool isLoading = true;
  bool isFirst = true;
  bool hasError = false;
  List<ReservationExpansionItem> items = [];

  @override
  void didChangeDependencies() {
    if (isFirst) {
      _loadReservations();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _loadReservations() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final provider = Provider.of<AppDataProvider>(context, listen: false);
      final reservations = await provider.getAllReservations();
      
      // Sort reservations from latest to oldest
      reservations.sort((a, b) {
        final aDateStr = '${a.busSchedule.departureDate} ${a.busSchedule.departureTime}';
        final bDateStr = '${b.busSchedule.departureDate} ${b.busSchedule.departureTime}';
        final aDate = DateFormat('dd/MM/yyyy HH:mm').parse(aDateStr);
        final bDate = DateFormat('dd/MM/yyyy HH:mm').parse(bDateStr);
        return bDate.compareTo(aDate); // descending order
      });
      
      setState(() {
        items = provider.getExpansionItems(reservations);
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
      showMsg(context, 'Failed to load reservations: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _search(String value) async {
    if (value.isEmpty) {
      await _loadReservations();
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final provider = Provider.of<AppDataProvider>(context, listen: false);
      final results = await provider.getReservationsByMobile(value);
      
      // Sorting search results from latest to oldest
      results.sort((a, b) {
        final aDateStr = '${a.busSchedule.departureDate} ${a.busSchedule.departureTime}';
        final bDateStr = '${b.busSchedule.departureDate} ${b.busSchedule.departureTime}';
        final aDate = DateFormat('dd/MM/yyyy HH:mm').parse(aDateStr);
        final bDate = DateFormat('dd/MM/yyyy HH:mm').parse(bDateStr);
        return bDate.compareTo(aDate); // descending order
      });
      
      setState(() {
        items = provider.getExpansionItems(results);
        if (results.isEmpty) {
          showMsg(context, 'No reservations found');
        }
      });
    } catch (e) {
      showMsg(context, 'Search failed: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation List',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: SearchBox(onSubmit: _search),
            ),
          ),

          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),

          if (hasError)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    const Text(
                      'Failed to load data',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _loadReservations,
                      icon: const Icon(Icons.refresh),
                      label: Text("Try again"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (!isLoading && !hasError && items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Total Reservations: ${items.length}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green[700]),
                ),
              ),
            ),

          if (!isLoading && !hasError)
            Expanded(
              child: items.isEmpty
                  ? const Center(
                child: Text(
                  'No reservations available',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadReservations,
                child: _buildReservationList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReservationList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 3,
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
              leading: CircleAvatar(
                backgroundColor: item.header.reservationStatus == 'CANCELLED' 
                  ? Colors.red[100] 
                  : Colors.green[100],
                child: Icon(
                  item.header.reservationStatus == 'CANCELLED' 
                    ? Icons.block 
                    : Icons.check_circle,
                  color: item.header.reservationStatus == 'CANCELLED' 
                    ? Colors.red[700] 
                    : Colors.green[700],
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: ReservationItemHeaderView(header: item.header),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.header.reservationStatus == 'CANCELLED' 
                        ? Colors.red[100] 
                        : Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.header.reservationStatus == 'CANCELLED' 
                            ? Icons.block 
                            : Icons.check_circle,
                          size: 16,
                          color: item.header.reservationStatus == 'CANCELLED' 
                            ? Colors.red[700] 
                            : Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.header.reservationStatus,
                          style: TextStyle(
                            color: item.header.reservationStatus == 'CANCELLED' 
                              ? Colors.red[700] 
                              : Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                const Divider(height: 1),
                ReservationItemBodyView(body: item.body),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
