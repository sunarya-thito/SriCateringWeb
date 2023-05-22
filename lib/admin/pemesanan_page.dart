import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sricatering/admin/pemesanan_tile.dart';
import 'package:sricatering/model/order.dart' as order;

import '../model/database.dart';

class PemesananPage extends StatefulWidget {
  const PemesananPage({Key? key}) : super(key: key);

  @override
  _PemesananPageState createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  late Future<Map<String, order.Order>> _orderFuture;
  late StreamSubscription _orderListUpdated;

  @override
  void initState() {
    super.initState();
    _orderFuture = fetchAllOrders();
    // listen for order updates
    _orderListUpdated = databaseEventBus.on<OrderListUpdated>().listen((event) {
      setState(() {
        _orderFuture = Future.value(event.orders);
      });
    });
  }

  @override
  void dispose() {
    _orderListUpdated.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: snapshot.data!.entries.map((e) {
              return PemesananTile(id: e.key, order: e.value);
            }).toList(),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: _orderFuture,
    );
  }
}
