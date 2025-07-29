import 'package:barber_app/view/pages/login_page.dart';
import 'package:barber_app/view/pages/menu_page.dart';
import 'package:barber_app/view/services/auth_service.dart';
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
            spacing: 0,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LoginPage(isRegistring: false),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LoginPage(isRegistring: true),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Colors.black54,
                ),
                child: Text(
                  'Registrar',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              SizedBox(height: 15),
              Divider(color: Colors.black87, thickness: 3),
              SizedBox(height: 5,),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MenuPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(30),
                  backgroundColor: const Color.fromARGB(40, 0, 0, 0),
                ),
                child: Text(
                  'Entrar sem uma conta',
                  style: TextStyle(fontSize: 15, color: Colors.white60),
                ),
              ),
              SizedBox(height: 10),
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      AuthService().signInWithGoogle(context);
                    },
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 25,
                    ),
                  ),
                  SizedBox(width: 15,),
                  IconButton(
                    onPressed: () {
                      AuthService().signInWithGoogle(context);
                    },
                    icon: Image.asset(
                      'assets/images/apple_logo.png',
                      height: 25,
                    ),
                  ),
                ],
              ),
              */
            ],
          ),
        ),
      ],
    );
  }
}
