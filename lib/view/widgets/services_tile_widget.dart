import 'package:barber_app/data/dummy_data.dart';
import 'package:flutter/material.dart';

class ServicesTile extends StatelessWidget {
  const ServicesTile({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 0),
      child: Card(
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
                Icon(Icons.content_cut_sharp, size: 45),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DummyData.s[id][1],
                            style: TextStyle(fontSize: 19),
                          ),
                          Text(
                            'R\$${DummyData.s[id][2]}',
                            style: TextStyle(fontSize: 19),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16),
                          Text(
                            ' ${DummyData.s[id][3]}',
                            style: TextStyle(fontSize: 12),
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
