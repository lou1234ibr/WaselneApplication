import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../datasource/temp_db.dart';
import '../drawers/main_drawer.dart';
import '../providers/app_data_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class SearchPageCustomer extends StatefulWidget {
  const SearchPageCustomer({super.key});

  @override
  State<SearchPageCustomer> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPageCustomer> with SingleTickerProviderStateMixin {
  String? fromCity, toCity;
  DateTime? departureDate;
  final _formkey = GlobalKey<FormState>();

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  OverlayEntry? _historyOverlayEntry;
  OverlayEntry? _faqOverlayEntry;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create animations
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showTooltip(GlobalKey key, String label, VoidCallback onTap) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + renderBox.size.height + 4,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1), () {
      overlayEntry.remove();
      onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(

      appBar: AppBar(
        title: Text(
          l10n.findYourTrip,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, routeNameLoginPage),
        ),
        actions: [
          // My Reservations button in app bar
          Tooltip(
            message: l10n.history,
            waitDuration: Duration(milliseconds: 300),
            showDuration: Duration(seconds: 2),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/customerReservation');
              },
              icon: const Icon(Icons.history),
              tooltip: l10n.viewMyReservations, // For accessibility
            ),
          ),
          // FAQ button
          Tooltip(
            message: l10n.faq,
            waitDuration: Duration(milliseconds: 300),
            showDuration: Duration(seconds: 2),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/faq');
              },
              icon: const Icon(Icons.help_outline),
              tooltip: l10n.faq, // For accessibility
            ),
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
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SafeArea(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  // Top banner with image
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.directions_bus_rounded,
                              size: 50,
                              color: Colors.green[700],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.whereAreYouGoing,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.searchRoutesBookJourney,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Main form
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // From location
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, color: Colors.green[700]),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.departureLocation,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: fromCity,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l10n.emptyFieldError;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: l10n.selectDepartureLocation,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.green[600]!, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down_circle, color: Colors.green[600]),
                                  items: cities
                                      .map((city) => DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      fromCity = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // To location
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.flag_outlined, color: Colors.green[700]),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.destinationLocation,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: toCity,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return l10n.emptyFieldError;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: l10n.selectDestinationLocation,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.green[600]!, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down_circle, color: Colors.green[600]),
                                  items: cities
                                      .map((city) => DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      toCity = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Date selector
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, color: Colors.green[700]),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.travelDate,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: _selectDate,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[100],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          departureDate == null
                                              ? l10n.selectDate
                                              : getFormattedDate(departureDate!, pattern: 'EEE MMM dd, yyyy'),
                                          style: TextStyle(
                                            color: departureDate == null ? Colors.grey[600] : Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Icon(Icons.calendar_month, color: Colors.green[600]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Previous reservations shortcut
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/customerReservation');  // Route to be created
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.history, color: Colors.green[700]),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.viewMyPreviousReservations,
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green[700]),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Search button at bottom
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
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 8),
                          Text(
                            l10n.findBuses,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if(selectedDate != null){
      setState(() {
        departureDate = selectedDate;
      });
    }
  }

  void _search() {
    final l10n = AppLocalizations.of(context)!; // ✅ Fix added here

    if (departureDate == null) {
      showMsg(context, l10n.emptyDateError);
      return;
    }

    if (_formkey.currentState!.validate()) {
      Provider.of<AppDataProvider>(context, listen: false)
          .getRouteByCityFromAndCityTo(fromCity!, toCity!)
          .then((route) {
        if (route != null) {
          Navigator.pushNamed(
            context,
            routeNameSearchResultPage,
            arguments: [route, getFormattedDate(departureDate!)],
          );
        } else {
          showMsg(context, l10n.noRoutesFound);
        }
      });
    }
  }

}