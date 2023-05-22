import 'dart:html';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    var cssClassSet = window.document.querySelector('.app-logo')!.classes;
    cssClassSet.add('app-logo-fade-out');
    cssClassSet.remove('app-logo-fade-in');
    cssClassSet = window.document.querySelector('.app-motto')!.classes;
    cssClassSet.add('app-motto-fade-out');
    cssClassSet.remove('app-motto-fade-in');
    cssClassSet =
        window.document.querySelector('.app-loader-container')!.classes;
    cssClassSet.add('app-loader-container-fade-out');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Sri Catering',
      // use Material3 theme
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}
