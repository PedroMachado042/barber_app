import 'package:flutter/material.dart';

class ServiceDropdownitem extends StatelessWidget {
  const ServiceDropdownitem({
    super.key,
    required this.name,
    required this.icon,
    required this.price,
    required this.time,
  });
  final String name;
  final IconData icon;
  final String price;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
      child: Row(
        children: [
          Icon(icon, size: 35),
          SizedBox(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 40),
                  Icon(Icons.access_time, size: 18),
                  SizedBox(width: 5,),
                  Text(
                    time,
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
    );
  }
}
