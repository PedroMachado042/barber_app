import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/pages/admPages/edit_service_page.dart';
import 'package:barber_app/view/widgets/services_tile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditServicesPage extends StatefulWidget {
  const EditServicesPage({super.key});

  @override
  State<EditServicesPage> createState() => _EditServicesPageState();
}

class _EditServicesPageState extends State<EditServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Configurar'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          spacing: 5,
          children: [
            Icon(Icons.settings, color: Colors.amber, size: 40),
            Divider(),
            SizedBox(
              height: 580,
              child: SingleChildScrollView(
                child: ValueListenableBuilder<int>(
                  valueListenable: servicesLenght,
                  builder: (context, value, child) {
                    return Column(
                      spacing: 5,
                      children: [
                        Row(
                          children: [
                            Column(
                              spacing: 5,
                              children: List.generate(
                                value,
                                (index) => ServicesTile(id: index),
                              ),
                            ),
                            Column(
                              spacing: 5,
                              children: List.generate(
                                value,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                    left: 11,
                                    bottom: 20,
                                    top: 19,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black54,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        print(index);
                                        print(servicesBox.toMap());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    EditServicePage(
                                                      id: index,
                                                    ),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EditServicePage(id: value),
                                ),
                              );

                              print(value);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              height: 70,
                              child: Center(
                                child: Icon(Icons.add, size: 35),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
