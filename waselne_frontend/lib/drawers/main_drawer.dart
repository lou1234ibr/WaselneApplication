import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for greeting logic

import '../pages/customer_reservation.dart';
import '../utils/constants.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    const adminName = 'Admin';

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green[700],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.directions_bus_filled, size: 32, color: Colors.green),
                ),
                const SizedBox(height: 16),
                Text(
                  '$greeting, $adminName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage your Waselne system',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.bus_alert,
            label: 'Add Bus',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameAddBusPage);
            },
          ),
          _buildDrawerItem(
            icon: Icons.route,
            label: 'Add Route',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameAddRoutePage);
            },
          ),
          _buildDrawerItem(
            icon: Icons.schedule,
            label: 'Add Schedule',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameAddSchedulePage);
            },
          ),
          _buildDrawerItem(
            icon: Icons.book_online,
            label: 'View Reservations',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameReservationPage);
            },
          ),
          _buildDrawerItem(
            icon: Icons.login_outlined,
            label: 'Admin Logout',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, routeNameLoginPage);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
