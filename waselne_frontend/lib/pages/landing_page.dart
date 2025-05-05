import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // localization import

import '../providers/app_data_provider.dart';
import '../models/app_user.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> with SingleTickerProviderStateMixin {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final provider = Provider.of<AppDataProvider>(context, listen: false);
    final username = _userName.text.trim();
    final password = _password.text.trim();
    final l10n = AppLocalizations.of(context)!;

    if (username.isEmpty || password.isEmpty) {
      showMsg(context, l10n.fillAllFields);
      return;
    }

    try {
      final response = await provider.login(AppUser(userName: username, password: password));
      final customer = await provider.fetchCustomerByUserName(username);

      if (customer != null) {
        provider.setCustomer(customer);
      }

      if (response != null) {
        showMsg(context, response.message);
        if (response.role == "ROLE_ADMIN") {
          Navigator.pushReplacementNamed(context, routeNameHome);
        } else if (response.role == "ROLE_USER") {
          Navigator.pushNamed(context, '/searchCustomer');
        } else {
          showMsg(context, l10n.unknownRole);
        }
      } else {
        showMsg(context, l10n.loginFailed);
      }
    } catch (e) {
      showMsg(context, '${l10n.errorOccurred}: ${e.toString()}');
    }
  }

  void _navigateToSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.green[50]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.directions_bus_filled, // <-- bus icon
                              size: 40,
                              color: Colors.green[700],
                            ),
                          ),

                          const SizedBox(height: 24),
                          Text(
                            l10n.welcomeBack,
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                          Text(
                            l10n.loginToContinue,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _userName,
                            decoration: InputDecoration(
                              labelText: l10n.usernameLabel,
                              prefixIcon: Icon(Icons.person_outline, color: Colors.green[600]),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.green[600]!, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: l10n.passwordLabel,
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.green[600]),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.green[600]!, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // TODO: forgot password
                              },
                              child: Text(
                                l10n.forgotPassword,
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),


                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              minimumSize: const Size(double.infinity, 55),
                              elevation: 3,
                            ),
                            child: Text(
                              l10n.login,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.noAccount,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              GestureDetector(
                                onTap: _navigateToSignup,
                                child: Text(
                                  l10n.signUp,
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
