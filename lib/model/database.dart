import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sricatering/model/menu.dart';

Future<List<Makanan>> fetchDaftarMakanan() {
  // fetch daftar makanan dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('makanan');
  return colRef.get().then((value) {
    return value.docs.map((e) => Makanan.fromJson(e.data())).toList();
  });
}

Future<List<Makanan>> fetchMakananBerdasarkanListId(List<String> listId) {
  // fetch daftar makanan dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('makanan');
  if (listId.isEmpty) return Future.value([]);
  if (listId.length > 10) {
    // firestore limitasi 10 item per query
    // jadi kalau lebih dari 10, dibagi jadi beberapa query
    var listFuture = <Future<QuerySnapshot>>[];
    var listIdChunk = <List<String>>[];
    for (var i = 0; i < listId.length; i += 10) {
      listIdChunk.add(listId.sublist(i, i + 10));
    }
    for (var idChunk in listIdChunk) {
      listFuture
          .add(colRef.where(FieldPath.documentId, whereIn: idChunk).get());
    }
    return Future.wait(listFuture).then((value) {
      var listMakanan = <Makanan>[];
      for (var querySnapshot in value) {
        listMakanan.addAll(querySnapshot.docs
            .map((e) => Makanan.fromJson(e.data() as Map<String, dynamic>))
            .toList());
      }
      return listMakanan;
    });
  }
  return colRef
      .where(FieldPath.documentId, whereIn: listId)
      .get()
      .then((value) {
    return value.docs.map((e) => Makanan.fromJson(e.data())).toList();
  });
}

Future<List<Paket>> fetchDaftarPaket() async {
  // fetch daftar paket dari firestore
  final db = FirebaseFirestore.instance;
  final colRef = db.collection('paket');
  var colVal = await colRef.get();
  List<Paket> listPaket = [];
  for (var e in colVal.docs) {
    var paket = Paket.fromJson(e.data());
    var pilihanListJson = e.data()['pilihan'] as List<dynamic>;
    for (var pilihanJson in pilihanListJson) {
      var pilihan = PilihanPaket.fromJson(pilihanJson);
      var makananListJson = pilihanJson['makanan'] as List<String>;
      var makananList = await fetchMakananBerdasarkanListId(makananListJson);
      pilihan.makanan.addAll(makananList);
      paket.pilihan.add(pilihan);
    }
    listPaket.add(paket);
  }
  return listPaket;
}
