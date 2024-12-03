import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_final/app/view/screens/home.dart';
import 'package:trabalho_final/app/view/screens/login.dart';
import 'package:trabalho_final/app/view/screens/planner.dart';
import 'package:trabalho_final/app/view/state/my_app_state.dart';
import 'package:trabalho_final/app/controller/firebase_options.dart';
import 'app/core/theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Trabalho final',
        theme: appTheme,
        home: const MyHomePage(title: 'PixiePlan'),
      ),
    );

    void checkUserAuth(BuildContext context) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // O usuário está autenticado, redireciona para a página principal ou outra
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PlannerPage()), // Substitua pela página principal
        );
      } else {
        // O usuário não está autenticado, redireciona para a tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginPage()), // Substitua pela página de login
        );
      }
    }
  }
}
