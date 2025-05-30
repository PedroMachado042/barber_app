import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

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
            Icon(
              Icons.settings,
              color: Colors.amber,
              size: 40,
            ),
            Divider(),
            Column(
              children: [SizedBox(height: 250),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.warning, size: 30, color: Colors.red),
                    Text(
                      'to fazendo ainda...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.warning, size: 30, color: Colors.red),
                  ],
                ),],
            ),
          ],
        ),
      ),
    );
  }
}
