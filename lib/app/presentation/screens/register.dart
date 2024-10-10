import 'package:flutter/material.dart';
import 'profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faça seu cadastro!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _controllerEmail,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: "Nome completo",
                border: OutlineInputBorder(),
              ),
              maxLength: 30,
            ),
            const Padding(padding: EdgeInsets.all(20)),
            TextFormField(
              controller: _controllerEmail,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: "E-mail",
                border: OutlineInputBorder(),
              ),
              maxLength: 30,
            ),
            const Padding(padding: EdgeInsets.all(20)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProfilePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
