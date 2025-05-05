import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customwidgets/login_alert_dialog.dart';
import '../models/bus_route.dart';
import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({Key? key}) : super(key: key);

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  final _formKey = GlobalKey<FormState>();
  String? from, to;
  final distanceController = TextEditingController();
  final locationUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Route',
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
                    Icon(Icons.alt_route_rounded, size: 48, color: Colors.green[700]),
                    const SizedBox(height: 16),
                    Text(
                      'Create New Route',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green[800]),
                    ),
                    const SizedBox(height: 24),

                    // From
                    DropdownButtonFormField<String>(
                      value: from,
                      isExpanded: true,
                      decoration: _fieldDecoration('From City', Icons.location_on_outlined),
                      items: cities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value) => setState(() => from = value),
                      validator: (value) => value == null || value.isEmpty ? 'Please select a city' : null,
                    ),
                    const SizedBox(height: 16),

                    // To
                    DropdownButtonFormField<String>(
                      value: to,
                      isExpanded: true,
                      decoration: _fieldDecoration('To City', Icons.flag_outlined),
                      items: cities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value) => setState(() => to = value),
                      validator: (value) => value == null || value.isEmpty ? 'Please select a city' : null,
                    ),
                    const SizedBox(height: 16),

                    // Distance
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: distanceController,
                      decoration: _fieldDecoration('Distance (km)', Icons.social_distance_outlined),
                      validator: (value) => value == null || value.isEmpty ? emptyFieldErrMessage : null,
                    ),
                    const SizedBox(height: 16),

                    // Location URL
                    TextFormField(
                      controller: locationUrlController,
                      decoration: _fieldDecoration('Location URL (Google Maps)', Icons.map_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a valid Google Maps URL';
                        if (!value.startsWith('https://')) return 'URL must start with https://';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: addRoute,
                        icon: const Icon(Icons.add_location_alt),
                        label: const Text('ADD ROUTE'),
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

  void addRoute() {
    if (_formKey.currentState!.validate()) {
      final route = BusRoute(
        routeName: '$from-$to',
        cityFrom: from!,
        cityTo: to!,
        distanceInKm: double.parse(distanceController.text),
        locationLink: locationUrlController.text,
      );

      Provider.of<AppDataProvider>(context, listen: false).addRoute(route).then((response) {
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

  void resetFields() {
    distanceController.clear();
    locationUrlController.clear();
    setState(() {
      from = null;
      to = null;
    });
  }

  @override
  void dispose() {
    distanceController.dispose();
    locationUrlController.dispose();
    super.dispose();
  }
}
