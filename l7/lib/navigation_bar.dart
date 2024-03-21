import 'package:flutter/material.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: Column(
        children: [
          _navigationItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            selected: true,
          ),
          _navigationItem(
            icon: Icons.person,
            label: 'Profile',
            selected: false,
          ),
          _navigationItem(
            icon: Icons.sports_gymnastics,
            label: 'Exercise',
            selected: false,
          ),
          _navigationItem(
            icon: Icons.settings,
            label: 'Settings',
            selected: false,
          ),
          _navigationItem(
            icon: Icons.history,
            label: 'History',
            selected: false,
          ),
          _navigationItem(
            icon: Icons.logout_outlined,
            label: 'Sign Out',
            selected: false,
          ),
        ],
      ),
    );
  }

  Widget _navigationItem(
      {required IconData icon, required String label, required bool selected}) {
    if (!selected) {
      return _getNavigationItemRow(icon: icon, label: label);
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 32.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: Colors.greenAccent,
          ),
          child: _getNavigationItemRow(
              icon: icon, label: label, selected: selected),
        ),
      );
    }
  }

  Widget _getNavigationItemRow(
      {required IconData icon, required String label, bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: (selected ? Colors.black : Colors.white),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            label,
            /*   style: TextStyle(
              color: (selected ? Colors.black : Colors.white),
            ),*/
          ),
        ],
      ),
    );
  }
}
