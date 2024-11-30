import 'package:flutter/material.dart';
import 'package:trabalho_final/app/service/firestore_service.dart';
import 'profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();

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
              controller: _controllerNome,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: "Nome completo",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // Cor da borda padrão
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffbf567d), // Cor da borda ao focar
                    width: 2.0,
                  ),
                ),
              ),
              maxLength: 30,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              controller: _controllerEmail,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: "E-mail",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // Cor da borda padrão
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffbf567d), // Cor da borda ao focar
                    width: 2.0,
                  ),
                ),
              ),
              maxLength: 30,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              controller: _controllerSenha,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: "Senha",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // Cor da borda padrão
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffbf567d), // Cor da borda ao focar
                    width: 2.0,
                  ),
                ),
              ),
              maxLength: 30,
            ),
            ElevatedButton(
              onPressed: () {
                salvarUsuario(_controllerEmail.text, _controllerSenha.text,
                    _controllerNome.text);

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

  salvarUsuario(String email, String senha, String nome) {
    try {
      var fDAO = FirestoreService();
      fDAO.criarUsuario(email, senha, nome);
    } on Exception catch (_, ex) {}
  }
}
