import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/core/theme.dart';
import 'app/presentation/state/my_app_state.dart';
import 'app/presentation/screens/home.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
