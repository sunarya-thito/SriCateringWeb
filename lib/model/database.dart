import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sricatering/model/menu.dart';
import 'package:event_bus_plus/event_bus_plus.dart';

IEventBus databaseEventBus = EventBus();

class PaketListUpdated extends AppEvent {
  final List<Paket> pakets;

  PaketListUpdated(this.pakets);

  @override
  List<Object?> get props => pakets;
}

void initializeDatabase() {
  // listen for database changes
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('paket');
  colRef.snapshots().listen((snapshot) {
    final pakets = snapshot.docs.map((doc) {
      return Paket.fromJson(doc.id, doc.data());
    }).toList();
    databaseEventBus.fire(PaketListUpdated(pakets));
  });
}

Future<Widget> getImageOfPaket(Paket paket) async {
  // dapatkan url gambar dari paket
  final storage = FirebaseStorage.instance;
  final ref = storage.ref().child('paket/${paket.id}.jpg');
  try {
    final downloadUrl = await ref.getDownloadURL();
    return Image(image: NetworkImage(downloadUrl));
  } catch (e) {
    return const Icon(Icons.image);
  }
}

Future<List<Paket>> fetchDaftarPaket() {
  // fetch daftar paket dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('paket');
  return colRef.get().then((snapshot) {
    return snapshot.docs.map((doc) {
      return Paket.fromJson(doc.id, doc.data());
    }).toList();
  });
}

Future<Paket> tambahPaket(Paket paket) {
  // tambah paket ke firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('paket');
  return colRef.add(paket.toJson()).then((docRef) {
    return paket.copyWith(docRef.id);
  });
}

Future<Paket> hapusPaket(Paket paket) {
  // hapus paket dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('paket');
  return colRef.doc(paket.id).delete().then((_) {
    return paket;
  });
}

Future<Paket> updatePaket(Paket paket) {
  // update paket di firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('paket');
  return colRef.doc(paket.id).update(paket.toJson()).then((_) {
    return paket;
  });
}
