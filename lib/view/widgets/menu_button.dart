import 'package:barber_app/view/pages/appointments_page.dart';
import 'package:barber_app/view/pages/booking_page.dart';
import 'package:barber_app/view/pages/services_page.dart';
import 'package:flutter/material.dart';

List<Widget> pages = [BookingPage(), AppointmentsPage(), ServicesPage(), ServicesPage()];

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
    return IconButton(
      padding: EdgeInsets.symmetric(vertical: 16),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pages.elementAt(id)),
        );
      },
      icon: Column(
        children: [
          Icon(icon),
          SizedBox(height: 8),
          Text(text, style: TextStyle(fontSize: 20,color: Colors.white)),
        ],
      ),
      iconSize: 40,
      color: Colors.white,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black,
        fixedSize: Size(140, 110),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
