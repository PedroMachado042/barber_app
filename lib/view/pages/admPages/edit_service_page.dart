import 'package:barber_app/data/dummy_data.dart';
import 'package:barber_app/data/notifiers.dart';
import 'package:barber_app/view/services/firestore.dart';
import 'package:barber_app/view/widgets/danger_alertbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({super.key, required this.id});
  final int id;

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool isCreating = false;

  @override
  void initState() {
    super.initState();
    if (widget.id == servicesLenght.value) isCreating = true;
  }

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
          spacing: 15,
          children: [
            Icon(Icons.settings, color: Colors.amber, size: 40),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Editar Serviço',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome do Serviço:',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        style: TextStyle(fontSize: 18),
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: isCreating?'Nome': servicesBox.get(widget.id)[1],
                          hintStyle: TextStyle(color: Colors.white54),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.cut, size: 80),
                  onPressed: () {
                    // ação do botão
                  },
                ),
              ],
            ),
            SizedBox(
              width: 255,
              child: Text('Preço:', style: TextStyle(fontSize: 18)),
            ),
            Row(
              children: [
                Icon(Icons.monetization_on),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: priceController,
                    decoration: InputDecoration(
                      hintText: isCreating?'--,--':servicesBox.get(widget.id)[2],
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 255,
              child: Text('Duração:', style: TextStyle(fontSize: 18)),
            ),
            Row(
              children: [
                Icon(Icons.alarm),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 18),
                    controller: timeController,
                    decoration: InputDecoration(
                      hintText: isCreating?'--:--':servicesBox.get(widget.id)[3],
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            !isCreating?
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    165,
                    32,
                    22,
                  ),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder:
                        (context) => DangerAlertbox(
                          function: 2,
                          serviceId: widget.id,
                        ),
                  );
                },
                child: Text(
                  'Deletar Serviço',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ):SizedBox(height: 40,),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    221,
                    148,
                    38,
                  ),
                ),
                onPressed: () async {
                  String name = nameController.text;
                  String price = priceController.text;
                  String time = timeController.text;
                  String errorMessage = '';
                  if (name == '')
                    errorMessage = 'Coloque um nome válido';
                  else if (!isValidEuropeanNumber(price.trim()))
                    errorMessage = 'Coloque um preço válido';
                  else if (!isValidTime(time.trim()))
                    errorMessage = 'Coloque uma duração válida';
                  else {
                    errorMessage = 'Serviço alterado com sucesso!';
                    await FirestoreService().setService(
                      widget.id,
                      59534,
                      name,
                      price,
                      time,
                    );
                    await FirestoreService().loadServices();
                    Navigator.pop(context);
                  }
                  Fluttertoast.showToast(
                    msg: errorMessage,
                    backgroundColor: Colors.black87,
                  );
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isValidEuropeanNumber(String input) {
  final regex = RegExp(r'^\d{1,3},\d{2}$');
  return regex.hasMatch(input);
}

bool isValidTime(String input) {
  final regex = RegExp(r'^\d{1,2}:\d{2}$');
  return regex.hasMatch(input);
}
