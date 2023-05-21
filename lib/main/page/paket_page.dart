import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/main/flat_button.dart';
import 'package:sricatering/main/page/home_page.dart';
import 'package:sricatering/main/page/paket_card.dart';
import 'package:sricatering/main/page/pilihan_button.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';
import 'package:sricatering/model/order.dart' as order;
import 'package:sricatering/model/order.dart';

class PaketPage extends StatefulWidget {
  final String paketId;
  const PaketPage({Key? key, required this.paketId}) : super(key: key);

  @override
  State<PaketPage> createState() => _PaketPageState();
}

class _PaketPageState extends State<PaketPage> {
  late Future<Paket> _paketFuture;
  Map<PilihanPaket, List<Makanan>> _pilihanPaket = {};

  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _amountController =
      TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _paketFuture = fetchPaket(widget.paketId);
  }

  int kalkulasiHarga(Paket paket) {
    int total = paket.baseHarga;
    _pilihanPaket.forEach((key, value) {
      for (var makanan in value) {
        total += makanan.harga;
      }
    });
    return total * (int.tryParse(_amountController.text) ?? 0);
  }

  bool valid(Paket paket) {
    if (_alamatController.text.isEmpty) {
      return false;
    }
    if (paket.pilihan.isEmpty) {
      return true;
    }
    for (var pilihan in paket.pilihan) {
      var pilihanPaket = _pilihanPaket[pilihan];
      if (pilihanPaket == null) {
        return false;
      }
      if (pilihanPaket.length < pilihan.minimal) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _paketFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: kHeaderColor,
                      child: FutureBuilder(
                        future: getImageOfPaket(snapshot.data!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Hero(
                              tag: 'gambar_paket:${widget.paketId}',
                              child: snapshot.data!,
                            );
                          }
                          return Container(
                            alignment: Alignment.center,
                            height: 500,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.nama,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kHeaderColor,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        snapshot.data!.deskripsi.isEmpty
                            ? 'Tidak ada deskripsi'
                            : snapshot.data!.deskripsi,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      ...snapshot.data!.pilihan.map((e) {
                        List<Makanan>? _pil = _pilihanPaket[e];
                        if (_pil == null) {
                          _pil = [];
                          _pilihanPaket[e] = _pil;
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Divider(
                              color: kHeaderColor,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.nama,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: kHeaderColor,
                                    ),
                                  ),
                                ),
                                e.minimal > 0
                                    ? Text(
                                        '*min ${e.minimal}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      )
                                    : e.maksimal > 0
                                        ? Text(
                                            '*maks ${e.maksimal}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          )
                                        : Text(
                                            '*opsional',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                              ],
                            ),
                            ...e.makanan.map((makanan) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: PilihanButton(
                                    makanan: makanan,
                                    selected: _pil!.contains(makanan),
                                    onTap: (selected) {
                                      if (!selected) {
                                        if (_pil!.length + 1 > e.maksimal) {
                                          // remove first
                                          _pil.removeAt(0);
                                        }
                                        setState(() {
                                          _pil!.add(makanan);
                                        });
                                      } else {
                                        setState(() {
                                          _pil!.remove(makanan);
                                        });
                                      }
                                    }),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: kHeaderColor,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Catatan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kHeaderColor,
                              ),
                            ),
                          ),
                          Text(
                            '*opsional',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: _catatanController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kHeaderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kHeaderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kHeaderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Tulis catatan disini',
                        ),
                        maxLength: 250,
                        maxLines: 3,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: kHeaderColor,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Alamat',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kHeaderColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: _alamatController,
                        onChanged: (v) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kHeaderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kHeaderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kHeaderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Tulis alamat pengiriman disini',
                        ),
                        maxLength: 300,
                        maxLines: 3,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Jumlah Item',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kHeaderColor,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: _amountController,
                              onChanged: (v) {
                                setState(() {
                                  int amount =
                                      (int.tryParse(v) ?? 1).clamp(1, 999);
                                  var selection = _amountController.selection;
                                  _amountController.text = amount.toString();
                                  _amountController.selection = TextSelection(
                                    baseOffset: selection.baseOffset.clamp(
                                        0, _amountController.text.length),
                                    extentOffset: selection.extentOffset.clamp(
                                        0, _amountController.text.length),
                                  );
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                constraints: BoxConstraints(minHeight: 0),
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kHeaderColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kHeaderColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kHeaderColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Spacer(),
                          FlatButton(
                              child: Text(
                                'Pesan Sekarang - ${formatRupiahCurrency(kalkulasiHarga(snapshot.data!))}',
                                textAlign: TextAlign.center,
                              ),
                              onPressed: !valid(snapshot.data!)
                                  ? null
                                  : () async {
                                      var user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user == null) {
                                        await FirebaseAuth.instance
                                            .signInWithPopup(
                                                GoogleAuthProvider()
                                                    .setCustomParameters({
                                          'prompt': 'select_account',
                                        }));
                                        return;
                                      }
                                      Paket paket = snapshot.data!;
                                      List<order.OrderPilihanPaket> pilihan =
                                          _pilihanPaket.entries
                                              .map((e) =>
                                                  order.OrderPilihanPaket(
                                                      nama: e.key.nama,
                                                      makanan:
                                                          e.value.map((mak) {
                                                        return order
                                                            .OrderMakanan(
                                                                nama: mak.nama,
                                                                harga:
                                                                    mak.harga);
                                                      }).toList()))
                                              .toList();
                                      order.OrderPaket orderPaket =
                                          order.OrderPaket(
                                              nama: paket.nama,
                                              baseHarga: paket.baseHarga,
                                              deskripsi: paket.deskripsi,
                                              pilihan: pilihan);

                                      order.OrderInfo info = order.OrderInfo(
                                          paket: orderPaket,
                                          jumlah: int.tryParse(
                                                  _amountController.text) ??
                                              1);

                                      order.Order d = order.Order(
                                          username: user.displayName ?? '',
                                          email: user.email ?? '',
                                          photoUrl: user.photoURL ?? '',
                                          orderInfo: info,
                                          alamat: _alamatController.text,
                                          catatan: _catatanController.text,
                                          status: OrderStatus.pending,
                                          tanggal: DateTime.now());

                                      var db = FirebaseFirestore.instance;
                                      var colRef = db
                                          .collection('users')
                                          .doc(user.uid)
                                          .collection('orders');
                                      if (mounted) {
                                        context.go('/me');
                                      }
                                      await colRef.add(d.toJson());
                                    }),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          height: 500,
          child: CircularProgressIndicator(
            color: kHeaderColor,
          ),
        );
      },
    );
  }
}
