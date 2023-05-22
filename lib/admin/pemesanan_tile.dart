import 'package:flutter/material.dart';
import 'package:sricatering/main/page/paket_card.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/order.dart' as ord;

class PemesananTile extends StatefulWidget {
  final String id;
  final ord.Order order;
  const PemesananTile({Key? key, required this.order, required this.id})
      : super(key: key);

  @override
  _PemesananTileState createState() => _PemesananTileState();
}

class _PemesananTileState extends State<PemesananTile> {
  late ord.OrderStatus status;

  @override
  void initState() {
    super.initState();
    status = widget.order.status;
  }

  int kalkulasiHarga(ord.OrderPaket paket, int jumlah) {
    int total = paket.baseHarga;
    for (var item in paket.pilihan) {
      for (var makanan in item.makanan) {
        total += makanan.harga;
      }
    }
    return total * jumlah;
  }

  @override
  void didUpdateWidget(covariant PemesananTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.status != widget.order.status) {
      status = widget.order.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        foregroundImage: NetworkImage(widget.order.photoUrl),
      ),
      childrenPadding: const EdgeInsets.all(16),
      tilePadding: const EdgeInsets.all(8),
      title: Text(
          'Pesanan ${widget.order.username} (${widget.order.orderInfo.paket.nama})'),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                SelectableText(widget.order.email),
                const SizedBox(height: 8),
                const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.order.tanggal.toString()),
                const SizedBox(height: 8),
                const Text('Alamat', style: TextStyle(fontWeight: FontWeight.bold)),
                SelectableText(widget.order.alamat),
                const SizedBox(height: 8),
                const Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold)),
                SelectableText(widget.order.catatan),
                const SizedBox(height: 8),
                const Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.order.orderInfo.jumlah.toString()),
                const SizedBox(height: 8),
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                SelectableText(formatRupiahCurrency(kalkulasiHarga(
                    widget.order.orderInfo.paket,
                    widget.order.orderInfo.jumlah))),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.order.orderInfo.paket.pilihan.map((pil) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pil.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: pil.makanan.map((makanan) {
                          return Text(makanan.nama);
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
                const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<ord.OrderStatus>(
                  items: ord.OrderStatus.values
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.displayName)))
                      .toList(),
                  value: widget.order.status,
                  onChanged: (value) {
                    updateOrderStatus(widget.id, value!);
                  },
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
