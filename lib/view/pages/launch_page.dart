import 'package:barber_app/view/pages/menu_page.dart';
import 'package:flutter/material.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 160),
        Image.asset('assets/images/logotop.png', height: 300),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              ElevatedButton(
                onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MenuPage(),
                  ),
                );},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(55),
                  backgroundColor: const Color.fromARGB(
                    255,
                    143,
                    98,
                    2,
                  ),
                ),
                child: Text(
                  'Entrar',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(55),
                  backgroundColor: Colors.black54,
                ),
                child: Text(
                  'Registrar',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              Divider(color: Colors.black87, thickness: 3),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: 25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
