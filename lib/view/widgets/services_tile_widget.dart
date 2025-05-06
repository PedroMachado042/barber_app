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
                Icon(IconData(servicesBox.get(id)[0], fontFamily: 'MaterialIcons'), size: 45),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            servicesBox.get(id)[1],
                            style: TextStyle(fontSize: 19),
                          ),
                          Text(
                            'R\$${servicesBox.get(id)[2]}',
                            style: TextStyle(fontSize: 19),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16),
                          Text(
                            ' ${servicesBox.get(id)[3]}',
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
