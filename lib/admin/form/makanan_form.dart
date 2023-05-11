import 'package:flutter/material.dart';
import 'package:sricatering/model/menu.dart';

class MakananForm extends StatefulWidget {
  final Makanan makanan;
  final void Function(Makanan?) onChanged;
  const MakananForm({Key? key, required this.onChanged, required this.makanan})
      : super(key: key);

  @override
  _MakananFormState createState() => _MakananFormState();
}

class _MakananFormState extends State<MakananForm> {
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.makanan.nama;
    price.text = widget.makanan.harga.toString();
  }

  @override
  void didUpdateWidget(covariant MakananForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.makanan != widget.makanan) {
      // store old cursor position before changing the value
      var nameSelection = name.selection;
      var priceSelection = price.selection;
      name.text = widget.makanan.nama;
      price.text = widget.makanan.harga.toString();
      // restore safely the cursor position
      name.selection = TextSelection(
          baseOffset: nameSelection.baseOffset.clamp(0, name.text.length),
          extentOffset: nameSelection.extentOffset.clamp(0, name.text.length));
      price.selection = TextSelection(
          baseOffset: priceSelection.baseOffset.clamp(0, price.text.length),
          extentOffset:
              priceSelection.extentOffset.clamp(0, price.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama Makanan'),
                    TextFormField(
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harus diisi';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        widget.onChanged(widget.makanan.copyWith(nama: value));
                      },
                      autovalidateMode: AutovalidateMode.always,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Harga'),
                    TextFormField(
                      controller: price,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harus diisi';
                        }
                        // angka
                        if (int.tryParse(value) == null) {
                          return 'Harus angka';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.onChanged(
                            widget.makanan.copyWith(harga: int.parse(value)));
                      },
                      autovalidateMode: AutovalidateMode.always,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                  onPressed: () {
                    widget.onChanged(null);
                  },
                  icon: Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}
