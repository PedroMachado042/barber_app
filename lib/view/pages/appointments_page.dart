import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/widgets/appointment_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingsBox = Hive.box('bookingsBox');
    bookingsLenght.value = bookingsBox.length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meus Horários'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SizedBox(
          height: 600,
          child: SingleChildScrollView(
            child: Column(
              spacing: 5,
              children: [
                Icon(Icons.calendar_month, color: Colors.amber, size: 40),
                Divider(),
                ValueListenableBuilder<int>(
                  valueListenable: bookingsLenght,
                  builder: (context, value, child) {
                    return Column(
                      children: List.generate(
                        value,
                        (index) => AppointmentsTile(id: (bookingsLenght.value-1)-index),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
