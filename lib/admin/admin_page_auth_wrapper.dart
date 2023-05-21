import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/google_button.dart';

class AdminPageAuthWrapper extends StatefulWidget {
  final Widget child;
  const AdminPageAuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _AdminPageAuthWrapperState createState() => _AdminPageAuthWrapperState();
}

class AdminAuth extends InheritedWidget {
  final _AdminPageAuthWrapperState data;

  const AdminAuth({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  static AdminAuth? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdminAuth>();
  }

  @override
  bool updateShouldNotify(covariant AdminAuth oldWidget) {
    return oldWidget.data != data;
  }

  void logout() {
    data.logout();
  }
}

class _AdminPageAuthWrapperState extends State<AdminPageAuthWrapper> {
  late StreamSubscription<User?> _userChanges;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuth.instance;
    _userChanges = auth.userChanges().listen((event) {
      setState(() {});
    });
    if (auth.currentUser == null) {
      auth
          .signInWithPopup(GoogleAuthProvider().setCustomParameters({
            'prompt': 'select_account',
          }))
          .then(_login)
          .catchError((e) {
        if (e is FirebaseAuthException) {
          if (!mounted) return;
          // show error dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(e.message ?? 'Unknown error'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // reload web page
                      window.location.reload();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }
        print(e);
        if (!mounted) return;
        // reload html page
        GoRouter.of(context).go('/admin');
      });
    }
  }

  @override
  void dispose() {
    _userChanges.cancel();
    super.dispose();
  }

  void logout() async {
    var auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  void _login(UserCredential userCredential) async {
    var database = FirebaseFirestore.instance;
    var userDoc = await database.doc('users/${userCredential.user!.uid}').get();
    var data = userDoc.data();
    if (data == null || data['admin'] != true) {
      // show dialog not admin
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Not Admin'),
            content: Text('You are not admin'),
            actions: [
              TextButton(
                onPressed: () {
                  // reload web page
                  window.location.reload();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return AdminAuth(
        data: this,
        child: widget.child,
      );
    }
    return Material(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
