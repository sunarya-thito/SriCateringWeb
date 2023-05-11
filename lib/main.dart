import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sricatering/firebase_options.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Flutter Demo',
      // use Material3 theme
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}
