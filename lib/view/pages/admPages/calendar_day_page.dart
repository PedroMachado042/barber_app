import 'package:barber_app/view/widgets/calendar_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDayPage extends StatelessWidget {
  const CalendarDayPage({super.key, required this.date});
  final String date;

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
            Icon(Icons.calendar_month, color: Colors.amber, size: 40),
            Divider(),
            Text(date, style: TextStyle(fontSize: 25)),
            Divider(),
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    2,
                    (index) => CalendarTile(id: 2,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
