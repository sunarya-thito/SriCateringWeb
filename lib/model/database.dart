import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sricatering/model/menu.dart';
import 'package:sricatering/model/order.dart' as order;
import 'package:event_bus_plus/event_bus_plus.dart';

IEventBus databaseEventBus = EventBus();

class PaketListUpdated extends AppEvent {
  final List<Paket> pakets;

  PaketListUpdated(this.pakets);

  @override
  List<Object?> get props => pakets;
}

class OrderListUpdated extends AppEvent {
  final Map<String, order.Order> orders;

  OrderListUpdated(this.orders);

  @override
  List<Object?> get props => [orders];
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
  final colRef2 = db.collectionGroup('orders');
  colRef2.snapshots().listen((snapshot) {
    Map<String, order.Order> orders = Map.fromEntries(snapshot.docs.map((doc) {
      return MapEntry(doc.id, order.Order.fromJson(doc.data()));
    }));
    databaseEventBus.fire(OrderListUpdated(orders));
  });
}

Map<Paket, Widget> _cachedImage = {};
Future<Widget> getImageOfPaket(Paket paket) async {
  Widget? cached = _cachedImage[paket];
  if (cached != null) {
    return cached;
  }
  // dapatkan url gambar dari paket
  final storage = FirebaseStorage.instance;
  final ref = storage.ref().child('paket/${paket.id}.jpg');
  try {
    final downloadUrl = await ref.getDownloadURL();
    var image2 = Image(image: NetworkImage(downloadUrl));
    _cachedImage[paket] = image2;
    return image2;
  } catch (e) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Icon(
        Icons.image,
        color: Colors.white,
      ),
    );
  }
}

Future<void> updateImageOfPaket(Paket paket, Uint8List list) async {
  // update gambar paket
  final storage = FirebaseStorage.instance;
  final ref = storage.ref().child('paket/${paket.id}.jpg');
  await ref.putData(list);
}

Future<void> deleteImageOfPaket(Paket paket) async {
  // hapus gambar paket
  final storage = FirebaseStorage.instance;
  final ref = storage.ref().child('paket/${paket.id}.jpg');
  await ref.delete();
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

Future<Paket> fetchPaket(String id) {
  // fetch paket dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('paket');
  return colRef.doc(id).get().then((doc) {
    return Paket.fromJson(doc.id, doc.data()!);
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

Future<Map<String, order.Order>> fetchOrders(String userId) {
  // fetch daftar order dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('users').doc(userId).collection('orders');
  return colRef.get().then((snapshot) {
    return Map.fromEntries(snapshot.docs.map((doc) {
      return MapEntry(doc.id, order.Order.fromJson(doc.data()));
    }));
  });
}

void updateOrderStatus(String id, order.OrderStatus status) {
  // update status order di firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collectionGroup('orders');
  colRef.get().then((snapshot) {
    for (var doc in snapshot.docs) {
      if (doc.id == id) {
        doc.reference.update({'status': describeEnum(status)});
        break;
      }
    }
  });
}

Future<Map<String, order.Order>> fetchAllOrders() {
  // fetch daftar order dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collectionGroup('orders');
  return colRef.get().then((snapshot) {
    return Map.fromEntries(snapshot.docs.map((doc) {
      return MapEntry(doc.id, order.Order.fromJson(doc.data()));
    }));
  });
}
