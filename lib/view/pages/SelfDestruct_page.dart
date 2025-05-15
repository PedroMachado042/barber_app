import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelfdestructPage extends StatelessWidget {
  const SelfdestructPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Error 404'),
        backgroundColor: CupertinoColors.placeholderText,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.amber,
                    size: 40,
                  ),
                  Text(
                    '  Aplicativo Desativado  ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.orange,
                    ),
                  ),
                  Icon(
                    Icons.warning,
                    color: Colors.amber,
                    size: 40,
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
                'O aplicativo foi temporariamente desativado pelo desenvolvedor em função de atualizações ou reparos no banco de dados, obrigado pela compreensão.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 50),
              Image.asset('assets/images/caveira.png', height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
