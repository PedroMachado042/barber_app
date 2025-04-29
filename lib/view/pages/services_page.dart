import 'package:barber_app/view/widgets/services_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
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
            Icon(Icons.content_cut_sharp, color: Colors.amber,size: 40,),
            Divider(),
            ServicesTile(),ServicesTile(),ServicesTile(),ServicesTile(),ServicesTile(),ServicesTile()
          ],
        ),
      ),
    );
  }
}
