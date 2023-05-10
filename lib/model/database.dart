import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sricatering/model/menu.dart';

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
