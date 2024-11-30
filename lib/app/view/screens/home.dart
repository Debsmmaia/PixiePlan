import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void initState() {
    super.initState();
    // Bloquear a tela para orientação vertical
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    //cria a mudança de tela
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

    return LayoutBuilder(
      //cria widgets de forma dinâmica
      builder: (context, constraints) {
        return Scaffold(
          //fornece estrutura básica
          drawer: Drawer(
            //barra de navegaçaõ sanduiche
            width: 200,
            child: Column(
              children: [
                ListTile(
                  //lista com os ícones
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  leading: const Icon(Icons.person, color: Color(0xffd98baf)),
                  title: const Text(
                    'Perfil',
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
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  leading: const Icon(Icons.book, color: Color(0xffd98baf)),
                  title: const Text(
                    'Meu Planner',
                    style: TextStyle(
                      color: Color(0xffbf567d),
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    //ao clicar muda a página
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
            //barra acima com a logo
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
                          const begin =
                              Offset(0.0, 1.0); // Inicia fora da tela, embaixo
                          const end = Offset.zero; // Fim no centro da tela
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
              : null, // Não exibe o FAB nas outras telas
        );
      },
    );
  }
}
