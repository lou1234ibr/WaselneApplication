import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/login_alert_dialog.dart';
import '../models/bus_model.dart';
import '../models/bus_schedule.dart';
import '../models/bus_route.dart';
import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({Key? key}) : super(key: key);

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  BusRoute? busRoute;
  Bus? bus;
  TimeOfDay? timeOfDay;
  DateTime? departureDate;

  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final feeController = TextEditingController();

  @override
  void didChangeDependencies() {
    _getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Schedule',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(Icons.event_available_rounded, size: 48, color: Colors.green[700]),
                    const SizedBox(height: 16),
                    Text(
                      'Create Bus Schedule',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green[800]),
                    ),
                    const SizedBox(height: 24),

                    // Select Bus
                    Consumer<AppDataProvider>(
                      builder: (context, provider, _) => DropdownButtonFormField<Bus>(
                        value: bus,
                        isExpanded: true,
                        decoration: _fieldDecoration('Select Bus', Icons.directions_bus),
                        items: provider.busList.map((b) {
                          return DropdownMenuItem(value: b, child: Text('${b.busName} - ${b.busType}'));
                        }).toList(),
                        onChanged: (value) => setState(() => bus = value),
                        validator: (value) => value == null ? 'Please select a bus' : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Select Route
                    Consumer<AppDataProvider>(
                      builder: (context, provider, _) => DropdownButtonFormField<BusRoute>(
                        value: busRoute,
                        isExpanded: true,
                        decoration: _fieldDecoration('Select Route', Icons.alt_route_rounded),
                        items: provider.routeList.map((r) {
                          return DropdownMenuItem(value: r, child: Text(r.routeName));
                        }).toList(),
                        onChanged: (value) => setState(() => busRoute = value),
                        validator: (value) => value == null ? 'Please select a route' : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Price
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: _fieldDecoration('Ticket Price (\$)', Icons.price_change),
                      validator: _validateField,
                    ),
                    const SizedBox(height: 16),

                    // Discount
                    TextFormField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: _fieldDecoration('Discount (%)', Icons.discount),
                      validator: _validateField,
                    ),
                    const SizedBox(height: 16),

                    // Processing Fee
                    TextFormField(
                      controller: feeController,
                      keyboardType: TextInputType.number,
                      decoration: _fieldDecoration('Processing Fee', Icons.monetization_on_outlined),
                      validator: _validateField,
                    ),
                    const SizedBox(height: 20),

                    // Select Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today, color: Colors.green),
                      title: const Text('Departure Date'),
                      subtitle: Text(
                        departureDate == null ? 'No date selected' : getFormattedDate(departureDate!),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: TextButton(
                        onPressed: _selectDate,
                        child: Text("Choose"),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Select Time
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.schedule, color: Colors.green),
                      title: const Text('Departure Time'),
                      subtitle: Text(
                        timeOfDay == null ? 'No time selected' : getFormattedTime(timeOfDay!),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: TextButton(
                        onPressed: _selectTime,
                        child: Text("Choose"),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: addSchedule,
                        icon: const Icon(Icons.add),
                        label: const Text('ADD SCHEDULE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      prefixIcon: Icon(icon, color: Colors.green[600]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green[600]!),
      ),
    );
  }

  String? _validateField(String? value) {
    return value == null || value.isEmpty ? emptyFieldErrMessage : null;
  }

  void addSchedule() {
    if (departureDate == null || timeOfDay == null) {
      showMsg(context, 'Please select both departure date and time');
      return;
    }
    if (_formKey.currentState!.validate()) {
      final schedule = BusSchedule(
        bus: bus!,
        busRoute: busRoute!,
        departureDate: getFormattedDate(departureDate!),
        departureTime: getFormattedTime(timeOfDay!),
        ticketPrice: int.parse(priceController.text),
        discount: int.parse(discountController.text),
        processingFee: int.parse(feeController.text),
      );
      Provider.of<AppDataProvider>(context, listen: false).addSchedule(schedule).then((response) {
        if (response.responseStatus == ResponseStatus.SAVED) {
          showMsg(context, response.message);
          resetFields();
        } else if (response.responseStatus == ResponseStatus.EXPIRED ||
            response.responseStatus == ResponseStatus.UNAUTHORIZED) {
          showLoginAlertDialog(
            context: context,
            message: response.message,
            callback: () => Navigator.pushNamed(context, routeNameLoginPage),
          );
        }
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (time != null) {
      setState(() => timeOfDay = time);
    }
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => departureDate = date);
    }
  }

  void resetFields() {
    priceController.clear();
    discountController.clear();
    feeController.clear();
    setState(() {
      timeOfDay = null;
      departureDate = null;
      bus = null;
      busRoute = null;
    });
  }

  void _getData() {
    Provider.of<AppDataProvider>(context, listen: false).getAllBus();
    Provider.of<AppDataProvider>(context, listen: false).getAllBusRoutes();
  }
}
