import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/main/page/home_page.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';
import 'package:intl/intl.dart';

class PaketCard extends StatefulWidget {
  final Paket paket;
  const PaketCard({Key? key, required this.paket}) : super(key: key);

  @override
  _PaketCardState createState() => _PaketCardState();
}

String formatRupiahCurrency(int value) {
  if (value == 0) {
    return 'Gratis';
  }
  return NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
      .format(value);
}

class _PaketCardState extends State<PaketCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          hover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hover = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          context.go('/paket/${widget.paket.id}');
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 220,
                  color: kHeaderColor,
                  child: FutureBuilder(
                    future: getImageOfPaket(widget.paket),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AnimatedScale(
                          scale: hover ? 1.2 : 1,
                          duration: const Duration(milliseconds: 200),
                          child: Hero(
                            tag: 'gambar_paket:${widget.paket.id}',
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: snapshot.data!,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(widget.paket.nama, style: TextStyle(color: Colors.black54)),
              Text('${formatRupiahCurrency(widget.paket.baseHarga)}/Porsi',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
