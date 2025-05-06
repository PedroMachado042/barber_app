import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/widgets/services_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final servicesBox = Hive.box('servicesBox');
  @override
  void initState() {
    super.initState;
    print(servicesBox.toMap());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Serviços'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          spacing: 5,
          children: [
            Icon(
              Icons.content_cut_sharp,
              color: Colors.amber,
              size: 40,
            ),
            Divider(),
            ValueListenableBuilder<int>(
              valueListenable: servicesLenght,
              builder: (context, value, child) {
                return Column(
                  spacing: 5,
                  children: List.generate(
                    value,
                    (index) => ServicesTile(id: index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
