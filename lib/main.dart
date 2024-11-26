import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_final/app/view/screens/home.dart';
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
  }
}
