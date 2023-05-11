import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sricatering/firebase_options.dart';
import 'package:sricatering/routes.dart';

void main() {
  // for web, use URLStrategy
  // initialize firebase
  // usePathUrlStrategy();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
