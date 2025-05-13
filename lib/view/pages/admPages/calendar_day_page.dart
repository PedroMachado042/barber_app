import 'package:barber_app/data/notifiers.dart';
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
                child: ValueListenableBuilder(
                  valueListenable: calendarLenght,
                  builder: (context, calendarLenght, child) {
                    return calendarLenght > 0
                        ? Column(
                          children: List.generate(
                            calendarLenght,
                            (index) => CalendarTile(id: index),
                          ),
                        )
                        : Column(children: [SizedBox(height: 50,),Text('Ainda não há agendamentos', style: TextStyle(fontSize: 22,color: Colors.white38),)],);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
