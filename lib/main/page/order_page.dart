import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/flat_button.dart';
import 'package:sricatering/main/page/order_card.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/order.dart' as order;
import 'package:sricatering/main/page/home_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late StreamSubscription _userChanges, _orderListUpdated;
  late Future<Map<String, order.Order>> _orderFuture;
  late Future<bool> _isAdminFuture;
  @override
  void initState() {
    super.initState();
    // listen to user changes
    var auth = FirebaseAuth.instance;
    _orderFuture = auth.currentUser == null
        ? Future.value({})
        : fetchOrders(auth.currentUser?.uid ?? '');
    _userChanges = auth.userChanges().listen((event) {
      setState(() {});
    });
    _orderListUpdated = databaseEventBus.on<OrderListUpdated>().listen((event) {
      setState(() {
        _orderFuture = Future.value(event.orders);
      });
    });
    _isAdminFuture = checkAdmin();
  }

  @override
  void dispose() {
    _userChanges.cancel();
    _orderListUpdated.cancel();
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

  Future<bool> checkAdmin() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc.data()?['admin'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    String? pfp = profilePicture();
    if (pfp == null) {
      return Container(
        height: 800,
        alignment: Alignment.center,
        child: const Text(
          'Anda belum login',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: kHeaderColor),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                foregroundImage: NetworkImage(pfp),
              ),
              const SizedBox(
                width: 24,
              ),
              Expanded(
                child: Text(
                  profileName() ?? '',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kHeaderColor),
                ),
              ),
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        FlatButton(
                          child: const Text('Admin'),
                          onPressed: () {
                            context.go('/admin');
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                },
                future: _isAdminFuture,
              ),
              const SizedBox(
                width: 8,
              ),
              FlatButton(
                child: const Text('Logout'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  context.go('/');
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            color: kHeaderColor,
          ),
          const SizedBox(
            height: 16,
          ),
          // header "Pesanan Saya"
          const Text(
            'Pesanan Saya',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: kHeaderColor),
          ),
          const SizedBox(
            height: 8,
          ),
          // list of orders
          FutureBuilder(
            future: _orderFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Container(
                      height: 800,
                      alignment: Alignment.center,
                      child: Text(
                        'Anda belum pernah memesan',
                        style: TextStyle(
                            fontSize: 16, color: kHeaderColor.withOpacity(0.5)),
                      ));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var order in snapshot.data!.values)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: OrderCard(
                          order: order,
                        ),
                      )
                  ],
                );
              }
              return Container(
                height: 800,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }
}
