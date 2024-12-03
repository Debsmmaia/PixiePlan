import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trabalho_final/app/view/screens/planner.dart'; // Substitua pelo seu arquivo de perfil
import 'package:trabalho_final/app/view/screens/register.dart'; // Tela de cadastro
import 'package:trabalho_final/app/view/screens/home.dart'; // A página inicial, onde o "X" vai redirecionar

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; // Para mostrar o indicador de carregamento
  String _errorMessage = ""; // Mensagem de erro

  // Função para fazer login
  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // Fazendo login com Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerUsername.text,
        password: _controllerPassword.text,
      );

      // Se o login for bem-sucedido, redireciona para a página inicial
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(
                title: 'Página Inicial')), // Navegação para MyHomePage
      );
    } on FirebaseAuthException catch (e) {
      // Se ocorrer algum erro, exibe a mensagem
      setState(() {
        _isLoading = false;
        _errorMessage = e.message ?? 'Erro desconhecido';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xff383636), size: 30),
          onPressed: () {
            // Ao clicar no botão de fechar, retorna para a página inicial
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const MyHomePage(title: 'Pagina inicial'),
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
        ),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Campo de E-mail
                  TextFormField(
                    controller: _controllerUsername,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: "E-mail",
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(height: 20),

                  // Campo de Senha
                  TextFormField(
                    controller: _controllerPassword,
                    style: const TextStyle(fontSize: 20),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Senha",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Se estiver carregando, mostra um indicador
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _loginUser,
                          child: const Text('Login'),
                        ),

                  // Mostrar a mensagem de erro, se houver
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],

                  // Opção para fazer cadastro
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navega para a página de cadastro
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const RegisterPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
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
                          child: const Text('Fazer cadastro'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
