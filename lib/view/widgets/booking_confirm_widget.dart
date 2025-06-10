import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:barber_app/view/widgets/confirmed_alertbox.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BookingConfirmWidget extends StatefulWidget {
  const BookingConfirmWidget({
    super.key,
    required this.time,
    required this.service,
    required this.hour,
    required this.prof,
  });
  final DateTime time;
  final int? service;
  final int hour;
  final String prof;

  @override
  State<BookingConfirmWidget> createState() =>
      _BookingConfirmWidgetState();
}

class _BookingConfirmWidgetState extends State<BookingConfirmWidget> {
  bool alreadyConfirmed = false;
  @override
  Widget build(BuildContext context) {
    final bookingsBox = Hive.box('bookingsBox');
    final servicesBox = Hive.box('servicesBox');

    //Calcular a soma das horas
    int tempoDuracao = int.parse(
      (servicesBox.get(widget.service!)[3]).split(":")[0],
    );
    List<String> horaInicial = horariosBox
        .get(widget.hour)
        .split(":");
    int minutosTotais =
        int.parse(horaInicial[0]) * 60 +
        int.parse(horaInicial[1]) +
        tempoDuracao;
    String endTime = '${minutosTotais ~/ 60}:${minutosTotais % 60}';

    return AlertDialog(
      //shape: BeveledRectangleBorder(),
      content: Container(
        height: 245,
        width: 260,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          spacing: 15,
          children: [
            Row(
              children: [
                Icon(
                  IconData(
                    servicesBox.get(widget.service)[0],
                    fontFamily: 'MaterialIcons',
                  ),
                  size: 35,
                ),
                SizedBox(width: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(servicesBox.get(widget.service)[1]),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'R\$ ${servicesBox.get(widget.service)[2]}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 40),
                        Icon(Icons.lock_clock, size: 18),
                        SizedBox(width: 5),
                        Text(
                          '${servicesBox.get(widget.service)[3]} min',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Text(
                    '${horariosBox.get(widget.hour)} -> ${endTime}',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.white10,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${DummyData.months[widget.time.month - 1]}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${widget.time.day}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${DummyData.weekdays[widget.time.weekday - 1]}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 60),
                backgroundColor: const Color.fromARGB(
                  255,
                  196,
                  135,
                  5,
                ),
              ),
              onPressed:
                  alreadyConfirmed
                      ? () {
                        print('inclicavel');
                      }
                      : () async {
                        setState(() {
                          alreadyConfirmed = true;
                        });
                        //bloqueia o botao
                        List<String> parts = horariosBox
                            .get(widget.hour)
                            .split(':');
                        DateTime preparedTime = DateTime(
                          widget.time.year,
                          widget.time.month,
                          widget.time.day,
                          int.parse(
                            parts[0],
                          ), // New hour (e.g., 3:00 PM)
                          int.parse(parts[1]),
                          1,
                          0,
                          0,
                        );
                        bookingsBox.put(bookingsBox.length, [
                          servicesBox.get(widget.service)[0],
                          servicesBox.get(widget.service)[1],
                          preparedTime,
                          false,
                          widget.prof,
                        ]);
                        await FirestoreService().reservarHorario(
                          widget.prof,
                          '${widget.time.day.toString().padLeft(2, '0')}-${widget.time.month.toString().padLeft(2, '0')}-${widget.time.year.toString().padLeft(2, '0')}',
                          horariosBox.get(widget.hour),
                          widget.service!,
                          '$preparedTime',
                        );
                        await FirestoreService().setAppointments(
                          widget.service!,
                          '$preparedTime',
                          widget.prof,
                        );
                        await showDialog(
                          context: context,
                          barrierDismissible: true, // default is true
                          builder: (context) => ConfirmedAlertbox(),
                        );
                        FirestoreService().setUsername();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
              child:
                  alreadyConfirmed
                      ? CircularProgressIndicator(
                        color: Colors.black87,
                      )
                      : Text(
                        'Confirmar',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          inherit: true,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
