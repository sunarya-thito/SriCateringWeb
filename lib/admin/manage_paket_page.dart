import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/admin/tile/paket_tile.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';

class ManagePaketPage extends StatefulWidget {
  const ManagePaketPage({Key? key}) : super(key: key);

  @override
  State<ManagePaketPage> createState() => _ManagePaketPageState();
}

class _ManagePaketPageState extends State<ManagePaketPage> {
  late Future<List<Paket>> listPaketFuture;
  late StreamSubscription eventListener;

  @override
  void initState() {
    super.initState();
    listPaketFuture = fetchDaftarPaket();
    eventListener = databaseEventBus.on<PaketListUpdated>().listen((event) {
      setState(() {
        listPaketFuture = Future.value(event.pakets);
      });
    });
  }

  @override
  void dispose() {
    eventListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // push BuatPaketForm
            context.push('/admin/buat_paket');
          },
          label: const Text('Tambah Menu'),
          icon: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: listPaketFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Paket> pakets = snapshot.data as List<Paket>;
              return ListView(
                children: pakets.mapIndexed((index, element) {
                  return PaketTile(paket: element);
                }).toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
