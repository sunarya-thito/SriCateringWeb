import 'package:flutter/material.dart';
import 'package:sricatering/main/page/home_page.dart';
import 'package:sricatering/main/page/paket_card.dart';
import 'package:sricatering/model/order.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: kHeaderColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.order.orderInfo.paket.nama,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: kHeaderColor),
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.order.orderInfo.paket.deskripsi.isNotEmpty)
                    Text(
                      widget.order.orderInfo.paket.deskripsi,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  if (widget.order.orderInfo.paket.pilihan.isNotEmpty &&
                      widget.order.orderInfo.paket.deskripsi.isNotEmpty)
                    SizedBox(
                      height: 8,
                    ),
                  if (widget.order.orderInfo.paket.pilihan.isNotEmpty)
                    Text(
                      'Pilihan Menu',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kHeaderColor),
                    ),
                  if (widget.order.orderInfo.paket.pilihan.isNotEmpty)
                    SizedBox(
                      height: 2,
                    ),
                  ...widget.order.orderInfo.paket.pilihan.map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.nama,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        ...e.makanan.map((m) {
                          return Text(
                            m.nama,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          );
                        }).toList(),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    );
                  }),
                  if (widget.order.catatan.isNotEmpty)
                    SizedBox(
                      height: 8,
                    ),
                  if (widget.order.catatan.isNotEmpty)
                    Text(
                      'Catatan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kHeaderColor),
                    ),
                  if (widget.order.catatan.isNotEmpty)
                    SizedBox(
                      height: 2,
                    ),
                  if (widget.order.catatan.isNotEmpty)
                    Text(
                      widget.order.catatan,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengiriman',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kHeaderColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.order.alamat,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Jumlah',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kHeaderColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.order.orderInfo.jumlah.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kHeaderColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '${formatRupiahCurrency(kalkulasiHarga(widget.order))}',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Status',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kHeaderColor),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.order.status.displayName,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }

  int kalkulasiHarga(Order order) {
    int total = 0;
    total += order.orderInfo.paket.baseHarga;
    for (var element in order.orderInfo.paket.pilihan) {
      for (var element in element.makanan) {
        total += element.harga;
      }
    }
    return total * order.orderInfo.jumlah;
  }
}
