import 'dart:async';
import 'dart:html';

import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sricatering/main/page/home_page.dart';
import 'package:sricatering/web_layout.dart';
import 'package:sricatering/ui_util.dart';

class StandardPage extends StatefulWidget {
  final Widget child;
  const StandardPage({required Key key, required this.child}) : super(key: key);

  @override
  _StandardPageState createState() => _StandardPageState();
}

class _StandardPageState extends State<StandardPage> {
  late StreamSubscription _userChanges;

  @override
  void initState() {
    super.initState();
    var auth = FirebaseAuth.instance;
    _userChanges = auth.userChanges().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _userChanges.cancel();
    super.dispose();
  }

  String? profilePicture() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user.photoURL;
  }

  String? profileName() {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    String? profileName = this.profileName();
    String? profilePicture = this.profilePicture();
    return Material(
      child: Theme(
        data: ThemeData.light(useMaterial3: true).copyWith(
            textTheme: GoogleFonts.interTextTheme(),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: kHeaderColor,
              selectionColor: kHeaderColor.withOpacity(0.3),
              selectionHandleColor: kHeaderColor,
            )),
        child: Container(
          color: kHeaderColor,
          child: WebLayout(
            builder: (context, width) {
              return WebContainerWidth(
                width: width,
                child: DynMouseScroll(builder: (context, controller, physics) {
                  return CustomScrollView(
                    controller: controller,
                    physics: physics,
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        expandedHeight: 200,
                        collapsedHeight: kToolbarHeight,
                        flexibleSpace:
                            LayoutBuilder(builder: (context, constraints) {
                          double height = constraints.biggest.height;
                          return Stack(
                            clipBehavior: Clip.hardEdge,
                            fit: StackFit.expand,
                            children: [
                              FittedBox(
                                fit: BoxFit.cover,
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  'assets/header.jpg',
                                ),
                              ),
                              Container(
                                color: kHeaderColor.withOpacity(1 -
                                    ((height - kToolbarHeight) / 200)
                                        .clamp(0, 0.5)),
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: width,
                                  child: Row(
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            context.go('/');
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Image.asset(
                                                  'assets/logo_white.png',
                                                  height: 80,
                                                ),
                                              ),
                                              const Text(
                                                'SRI CATERING',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      profilePicture != null
                                          ? TextButton(
                                              onPressed: () {
                                                context.go('/me');
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 0,
                                                  top: 8,
                                                  bottom: 8,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    profileName ?? '',
                                                    softWrap: false,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  CircleAvatar(
                                                    foregroundImage:
                                                        NetworkImage(
                                                            profilePicture),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 8,
                                                  bottom: 8,
                                                ),
                                              ),
                                              onPressed: () {
                                                FirebaseAuth.instance
                                                    .signInWithPopup(
                                                        GoogleAuthProvider()
                                                            .setCustomParameters({
                                                  'prompt': 'select_account',
                                                }))
                                                    .catchError(
                                                  (e) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Error'),
                                                          content: Text(e
                                                                  .message ??
                                                              'Unknown error'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              child: Row(
                                                children: const [
                                                  Text('Login'),
                                                  SizedBox(width: 8),
                                                  Icon(Icons.login),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          alignment: Alignment.center,
                          color: kBackgroundColor,
                          child: SizedBox(
                            width: width,
                            child: widget.child,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: kHeaderColor,
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            height: 200,
                            width: width,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            String url =
                                                'https://www.google.com/maps/search/Kampung+Ciherang+RT.02+RW.10+Banjaran,+Kabupaten+Bandung/@-6.986646,107.643024,12z/data=!3m1!4b1';
                                            window.open(url, 'maps');
                                          },
                                          child: const Text(
                                              'Kampung Ciherang RT.02 RW.10 Banjaran, Kabupaten Bandung'),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            String url =
                                                'https://wa.me/6281223433254?text=Halo%20Sri%20Catering,%20saya%20mau%20pesan%20catering%20untuk%20acara%20pernikahan%20saya.';
                                            window.open(url, 'whatsapp');
                                          },
                                          child: Row(
                                            children: const [
                                              Icon(Icons.phone,
                                                  color: Colors.white),
                                              SizedBox(width: 8),
                                              Text('0812-2343-3254'),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
