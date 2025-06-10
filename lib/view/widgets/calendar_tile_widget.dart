import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CalendarTile extends StatefulWidget {
  const CalendarTile({super.key, required this.id});
  final int id;

  @override
  State<CalendarTile> createState() => _AppointmentsTileState();
}

class _AppointmentsTileState extends State<CalendarTile> {
  final calendarBox = Hive.box('calendarBox');
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 245,
            child: Card(
              //color: const Color.fromARGB(255, 71, 49, 1),
              elevation: 15,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  print(calendarBox.toMap());
                },
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
                          calendarBox.get(widget.id)[0],
                          fontFamily: 'MaterialIcons',
                        ),
                        size: 35,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      calendarBox.get(widget.id)[1],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  calendarBox.get(widget.id)[2],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
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
          ),
          SizedBox(
            height: 60,
            child: Card(
              //color: const Color.fromARGB(255, 71, 49, 1),
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Center(
                  child: Text(
                    calendarBox.get(widget.id)[4],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
