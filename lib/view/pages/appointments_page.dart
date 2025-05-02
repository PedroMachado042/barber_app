import 'package:barber_app/view/widgets/appointment_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meus Horários'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          spacing: 5,
          children: [
            Icon(Icons.calendar_month, color: Colors.amber,size: 40,),
            Divider(),
            Column(children: List.generate(2, (index) => AppointmentTile(id:index),))
          ],
        ),
      ),
    );
  }
}
