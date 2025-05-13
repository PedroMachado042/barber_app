import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GraphsPage extends StatelessWidget {
  const GraphsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gráficos'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          spacing: 5,
          children: [
            Icon(
              Icons.auto_graph,
              color: Colors.amber,
              size: 40,
            ),
            Divider(),
            Column(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
