import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_final/app/service/firestore_service.dart';
import 'package:trabalho_final/app/view/screens/home.dart';
import 'package:trabalho_final/app/view/screens/planner.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              onPressed: () async {
                // Chama a função para salvar o usuário
                await salvarUsuario(
                  _controllerEmail.text,
                  _controllerSenha.text,
                  _controllerNome.text,
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                          title:
                              'Página Inicial')), // Navegação para MyHomePage
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  // Função para salvar o usuário
  Future<void> salvarUsuario(String email, String senha, String nome) async {
    try {
      // Criação do usuário no Firebase Authentication
      var userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);

      // Obtenha o ID do usuário criado
      String userId = userCredential.user?.uid ?? '';

      // Salvar as informações do usuário no Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'nome': nome,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Realiza o login imediatamente após a criação
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);

      debugPrint("Usuário registrado e logado com sucesso!");
    } on FirebaseException catch (e) {
      debugPrint("Erro ao registrar usuário: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao criar conta: ${e.message}")),
      );
    }
  }
}
