import 'package:barber_app/view/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.isRegistring});
  final bool isRegistring;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.isRegistring ? 'Registrar' : 'Entrar',
                style: TextStyle(fontSize: 30),
              ),
            ),

            SizedBox(height: 40),
            widget.isRegistring
                ? Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text('Nome'),
                    ),
                    TextField(controller: usernameController),
                    SizedBox(height: 20),
                  ],
                )
                : Column(),
            SizedBox(width: double.infinity, child: Text('E-mail')),
            TextField(controller: emailController),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, child: Text('Senha')),
            TextField(controller: passwordController, obscureText: true,),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  widget.isRegistring
                      ? usernameController.text != ''
                          ? await AuthService().signup(
                            username: usernameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          )
                          : AuthService().noUsername()
                      : await AuthService().signin(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                      );
                },
                child: Text(
                  widget.isRegistring ? 'Concluir' : 'Concluir',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}