import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/pages/admPages/calendar_page.dart';
import 'package:barber_app/view/pages/admPages/clients_page.dart';
import 'package:barber_app/view/pages/admPages/graphs_page.dart';
import 'package:barber_app/view/pages/admPages/management_page.dart';
import 'package:barber_app/view/pages/appointments_page.dart';
import 'package:barber_app/view/pages/booking_page.dart';
import 'package:barber_app/view/pages/localization_page.dart';
import 'package:barber_app/view/pages/services_page.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [
  BookingPage(),
  AppointmentsPage(),
  ServicesPage(),
  LocalizationPage(),
];
List<Widget> admPages = [
  CalendarPage(),
  ClientsPage(),
  GraphsPage(),
  ManagementPage(),
];

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.text,
    required this.icon,
    required this.id,
  });
  final String text;
  final IconData icon;
  final int id;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isADM,
      builder: (Bcontext, isLogged, child) {
        return IconButton(
          padding: EdgeInsets.symmetric(vertical: 16),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        isADM.value
                            ? admPages.elementAt(id)
                            : pages.elementAt(id),
              ),
            );
          },
          icon: Column(
            children: [
              Icon(icon),
              SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  color: isADM.value ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
          iconSize: 40,
          color: isADM.value ? Colors.black : Colors.white,
          style: IconButton.styleFrom(
            backgroundColor:
                isADM.value
                    ? const Color.fromARGB(255, 221, 148, 38)
                    : Colors.black,
            fixedSize: Size(140, 110),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        );
      },
    );
  }
}
