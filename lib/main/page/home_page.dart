import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sricatering/main/page/paket_card.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

const Color kHeaderColor = Color(0xFF540405);
const Color kBackgroundColor = Color(0xFFE9DCBC);

class _HomePageState extends State<HomePage> {
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
    return Padding(
      padding: const EdgeInsets.only(top: 48, bottom: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Paket',
            style: TextStyle(
                color: kHeaderColor, fontWeight: FontWeight.bold, fontSize: 32),
          ),
          const Text(
            'Pilih Paket Catering yang cocok untuk acara anda',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          const SizedBox(height: 16),
          FutureBuilder(
            future: listPaketFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                  runSpacing: 24,
                  spacing: 16,
                  children:
                      snapshot.data!.map((e) => PaketCard(paket: e)).toList(),
                );
              }
              return Container(
                height: 200,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: kHeaderColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
