import 'package:barber_app/data/dummy_data.dart';
import 'package:flutter/material.dart';

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({super.key, required this.id});
  final int id;
  @override
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
                Icon(DummyData.a[id][0], size: 45),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DummyData.a[id][1],
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DummyData.a[id][2],
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            DummyData.a[id][3],
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children:
                            DummyData.a[id][4]
                                ? [
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
                                ]
                                : [
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
