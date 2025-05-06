import 'package:barber_app/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BookingConfirmWidget extends StatelessWidget {
  const BookingConfirmWidget({
    super.key,
    required this.time,
    required this.service,
    required this.hour,
  });
  final DateTime time;
  final int? service;
  final int hour;

  @override
  Widget build(BuildContext context) {
    final bookingsBox = Hive.box('bookingsBox');
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
                    servicesBox.get(service)[0],
                    fontFamily: 'MaterialIcons',
                  ),
                  size: 35,
                ),
                SizedBox(width: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(servicesBox.get(service)[1]),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'R\$ ${servicesBox.get(service)[2]}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 40),
                        Icon(Icons.lock_clock, size: 18),
                        SizedBox(width: 5),
                        Text(
                          '${servicesBox.get(service)[3]} min',
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
                    '${horariosBox.get(hour)} -> 19:45',
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
                          '${DummyData.months[time.month - 1]}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${time.day}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${DummyData.weekdays[time.weekday - 1]}',
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                List<String> parts = horariosBox.get(hour).split(':');
                DateTime preparedTime = DateTime(
                  time.year,
                  time.month,
                  time.day,
                  int.parse(parts[0]), // New hour (e.g., 3:00 PM)
                  int.parse(parts[1]),
                  1,
                  0,
                  0,
                );

                bookingsBox.put(bookingsBox.length, [
                  servicesBox.get(service)[0],
                  servicesBox.get(service)[1],
                  preparedTime,
                  false,
                ]);
                print(bookingsBox.toMap());

                /*
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmedAlertbox();
                  },
                );*/
              },
              child: Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.black,
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
