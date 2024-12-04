import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho_final/app/service/firestore_service.dart';
import 'login.dart';
import 'planner.dart';
import 'new_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 1;
  String _nomeUsuario = 'Usuário';

  @override
  void initState() {
    super.initState();
    // Bloquear a tela para orientação vertical
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Buscar os dados do usuário
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _nomeUsuario = userDoc['nome'] ?? 'Usuário';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cria a mudança de tela
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const LoginPage();
        break;
      case 1:
        page = const PlannerPage();
        break;
      default:
        page = const Center(child: Text('Página Não Encontrada'));
    }

    // Verifica se o usuário está autenticado
    User? user = FirebaseAuth.instance.currentUser;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          drawer: Drawer(
            width: 200,
            child: Column(
              children: [
                // Exibe o nome do usuário
                if (user != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Olá, $_nomeUsuario',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xffbf567d),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    leading:
                        const Icon(Icons.exit_to_app, color: Color(0xffd98baf)),
                    title: const Text(
                      'Sair',
                      style: TextStyle(
                        color: Color(0xffbf567d),
                        fontSize: 20,
                      ),
                    ),
                    onTap: () async {
                      await FirestoreService().logout(context);
                      // Depois de login redireciona
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ],
                if (user == null) ...[
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    leading: const Icon(Icons.login, color: Color(0xffd98baf)),
                    title: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xffbf567d),
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  leading: const Icon(Icons.book, color: Color(0xffd98baf)),
                  title: const Text(
                    'Meu Planner',
                    style: TextStyle(
                      color: Color(0xffbf567d),
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/imagens/logo_pixie.png',
                  fit: BoxFit.contain,
                  height: 50,
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: page,
          floatingActionButton: selectedIndex == 1
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const NewPage(),
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
                  backgroundColor: const Color(0xffbf567d),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
