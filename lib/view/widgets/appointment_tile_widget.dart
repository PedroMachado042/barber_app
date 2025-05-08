import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppointmentsTile extends StatefulWidget {
  const AppointmentsTile({super.key, required this.id});
  final int id;

  @override
  State<AppointmentsTile> createState() => _AppointmentsTileState();
}

class _AppointmentsTileState extends State<AppointmentsTile> {
  final bookingsBox = Hive.box('bookingsBox');
  @override
  void initState() {
    super.initState();
    if (bookingsBox.get(widget.id)[2].isBefore(DateTime.now())) {
      bookingsBox.put(widget.id, [
        bookingsBox.get(widget.id)[0],
        bookingsBox.get(widget.id)[1],
        bookingsBox.get(widget.id)[2],
        true,
      ]);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 0),
      child: Card(
        //color: const Color.fromARGB(255, 71, 49, 1),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  IconData(
                    bookingsBox.get(widget.id)[0],
                    fontFamily: 'MaterialIcons',
                  ),
                  size: 45,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bookingsBox.get(widget.id)[1],
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(bookingsBox.get(widget.id)[2].hour).toString().padLeft(2, '0')}:${(bookingsBox.get(widget.id)[2].minute).toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${bookingsBox.get(widget.id)[2].day}/${bookingsBox.get(widget.id)[2].month}/${bookingsBox.get(widget.id)[2].year}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children:
                            bookingsBox.get(widget.id)[3]
                                ? [
                                  Icon(
                                    Icons.alarm,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    ' Concluido',
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ]
                                : [
                                  Icon(
                                    Icons.alarm,
                                    size: 16,
                                    color: Colors.yellow,
                                  ),
                                  Text(
                                    ' Agendado',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
