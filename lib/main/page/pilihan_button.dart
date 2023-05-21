import 'package:flutter/material.dart';
import 'package:sricatering/main/page/paket_card.dart';
import 'package:sricatering/model/menu.dart';

import 'home_page.dart';

class PilihanButton extends StatelessWidget {
  final Makanan makanan;
  final bool selected;
  final Function(bool selected) onTap;
  const PilihanButton(
      {Key? key,
      required this.makanan,
      required this.selected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onTap(selected);
        },
        child: Container(
          decoration: BoxDecoration(
            color: selected ? kHeaderColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: !selected ? kHeaderColor : Colors.transparent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  makanan.nama,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selected ? kBackgroundColor : kHeaderColor,
                  ),
                ),
              ),
              Text(
                formatRupiahCurrency(makanan.harga),
                style: TextStyle(
                  fontSize: 16,
                  color: selected
                      ? kBackgroundColor.withOpacity(0.5)
                      : kHeaderColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
