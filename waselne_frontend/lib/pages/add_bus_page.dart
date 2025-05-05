import 'package:waselne_frontend/customwidgets/login_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/bus_model.dart';
import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class AddBusPage extends StatefulWidget {
  const AddBusPage({Key? key}) : super(key: key);

  @override
  State<AddBusPage> createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  final _formKey = GlobalKey<FormState>();
  String? busType;
  final seatController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final driverNameController = TextEditingController();
  final driverPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Bus',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      Icon(Icons.directions_bus_filled, size: 48, color: Colors.green[700]),
                      const SizedBox(height: 16),
                      Text(
                        'Enter Bus Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green[800]),
                      ),
                      const SizedBox(height: 24),

                      // Bus Type
                      DropdownButtonFormField<String>(
                        onChanged: (value) => setState(() => busType = value),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please select a Bus Type' : null,
                        value: busType,
                        decoration: _fieldDecoration('Select Bus Type', Icons.directions_bus_outlined),
                        items: busTypes
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                      const SizedBox(height: 16),

                      // Bus Name
                      TextFormField(
                        controller: nameController,
                        decoration: _fieldDecoration('Bus Name', Icons.bus_alert),
                        validator: _validateField,
                      ),
                      const SizedBox(height: 16),

                      // Bus Number
                      TextFormField(
                        controller: numberController,
                        decoration: _fieldDecoration('Bus Number', Icons.confirmation_number),
                        validator: _validateField,
                      ),
                      const SizedBox(height: 16),

                      // Total Seats
                      TextFormField(
                        controller: seatController,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration('Total Seats', Icons.event_seat),
                        validator: _validateField,
                      ),
                      const SizedBox(height: 16),

                      // Driver Name
                      TextFormField(
                        controller: driverNameController,
                        decoration: _fieldDecoration('Driver Name', Icons.person),
                        validator: _validateField,
                      ),
                      const SizedBox(height: 16),

                      // Driver Phone
                      TextFormField(
                        controller: driverPhoneController,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration('Driver Phone', Icons.phone),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return emptyFieldErrMessage;
                          } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Phone must be numeric';
                          } else if (value.length > 8) {
                            return 'Phone must not exceed 8 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Add Bus Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: addBus,
                          icon: const Icon(Icons.add),
                          label: const Text('ADD BUS'),
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
        borderSide: BorderSide(color: Colors.green[600]!, width: 2),
      ),
    );
  }

  String? _validateField(String? value) {
    return (value == null || value.isEmpty) ? emptyFieldErrMessage : null;
  }

  void addBus() {
    if (_formKey.currentState!.validate()) {
      final bus = Bus(
        busName: nameController.text,
        busNumber: numberController.text,
        busType: busType!,
        totalSeat: int.parse(seatController.text),
        driverName: driverNameController.text,
        driverPhone: int.parse(driverPhoneController.text),
      );
      Provider.of<AppDataProvider>(context, listen: false)
          .addBus(bus)
          .then((response) {
        if (response.responseStatus == ResponseStatus.SAVED) {
          showMsg(context, response.message);
          resetFields();
        } else if (response.responseStatus == ResponseStatus.EXPIRED ||
            response.responseStatus == ResponseStatus.UNAUTHORIZED) {
          showLoginAlertDialog(
            context: context,
            message: response.message,
            callback: () {
              Navigator.pushNamed(context, routeNameLoginPage);
            },
          );
        }
      });
    }
  }

  void resetFields() {
    nameController.clear();
    numberController.clear();
    seatController.clear();
    driverNameController.clear();
    driverPhoneController.clear();
    setState(() => busType = null);
  }

  @override
  void dispose() {
    seatController.dispose();
    nameController.dispose();
    numberController.dispose();
    driverNameController.dispose();
    driverPhoneController.dispose();
    super.dispose();
  }
}
