import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  User? login;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuth.instance;
    login = auth.currentUser;
  }

  void logout() {
    setState(() {
      var auth = FirebaseAuth.instance;
      auth.signOut();
      login = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (login != null) {
      return AdminAuth(
        data: this,
        child: widget.child,
      );
    }
    return Material(
      child: Container(
        alignment: Alignment.center,
        color: const Color(0xFF171C1E),
        child: Card(
          child: Container(
            width: 600,
            height: 800,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Email'),
                TextField(
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                Text('Password'),
                TextField(
                  controller: _passwordController,
                ),
                Spacer(),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(20),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      var auth = FirebaseAuth.instance;
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      var userCredential =
                          await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      setState(() {
                        login = userCredential.user;
                      });
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        // display a dialog with the error message
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text(e.message ?? ''),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
