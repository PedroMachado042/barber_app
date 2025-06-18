import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetBreakDaysPage extends StatelessWidget {
  const SetBreakDaysPage({super.key});

  @override
  Widget build(BuildContext context) {
    void showDatePicker() {
      showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 90)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Configurar'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          spacing: 5,
          children: [
            Icon(Icons.settings, color: Colors.amber, size: 40),
            Divider(),
            Column(
              spacing: 5,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: showDatePicker,
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 50,
                      child: Center(child: Icon(Icons.add, size: 35)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
