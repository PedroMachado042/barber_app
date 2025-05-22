import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/widgets/calendar_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CalendarDayPage extends StatefulWidget {
  const CalendarDayPage({super.key, required this.date});
  final String date;

  @override
  State<CalendarDayPage> createState() => _CalendarDayPageState();
}

class _CalendarDayPageState extends State<CalendarDayPage> {
  final calendarBox = Hive.box('calendarBox');
  void initState() {
    super.initState();
      ordenarPorHorario(calendarBox.values.toList());
    }

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
            Text(widget.date, style: TextStyle(fontSize: 25)),
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
                        : Column(
                          children: [
                            SizedBox(height: 50),
                            Text(
                              'Ainda não há agendamentos',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        );
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

// Função para ordenar os dados por horário
List<dynamic> ordenarPorHorario(List<dynamic> dados) {
  final calendarBox = Hive.box('calendarBox');
  // Converte o horário para DateTime e ordena
  dados.sort((a, b) {
    DateFormat format = DateFormat("HH:mm");
    DateTime horaA = format.parse(a[4]);
    DateTime horaB = format.parse(b[4]);
    return horaA.compareTo(horaB);
  });
  for (int i = 0; i < dados.length; i++) {
    calendarBox.put(i, dados[i]);
  }
  return dados;
}