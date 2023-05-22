import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sricatering/admin/form/makanan_form.dart';
import 'package:sricatering/model/menu.dart';

class PilihanPaketForm extends StatefulWidget {
  final PilihanPaket pilihan;
  final void Function(PilihanPaket?) onChanged;
  const PilihanPaketForm(
      {Key? key, required this.pilihan, required this.onChanged})
      : super(key: key);

  @override
  _PilihanPaketFormState createState() => _PilihanPaketFormState();
}

class _PilihanPaketFormState extends State<PilihanPaketForm> {
  final TextEditingController name = TextEditingController();
  final TextEditingController min = TextEditingController();
  final TextEditingController max = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.pilihan.nama;
    min.text = widget.pilihan.minimal.toString();
    max.text = widget.pilihan.maksimal.toString();
  }

  @override
  void didUpdateWidget(covariant PilihanPaketForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pilihan != widget.pilihan) {
      // store old cursor position before changing the value
      var nameSelection = name.selection;
      var minSelection = min.selection;
      var maxSelection = max.selection;
      name.text = widget.pilihan.nama;
      min.text = widget.pilihan.minimal.toString();
      max.text = widget.pilihan.maksimal.toString();
      // restore safely the cursor position
      name.selection = TextSelection(
          baseOffset: nameSelection.baseOffset.clamp(0, name.text.length),
          extentOffset: nameSelection.extentOffset.clamp(0, name.text.length));
      min.selection = TextSelection(
          baseOffset: minSelection.baseOffset.clamp(0, min.text.length),
          extentOffset: minSelection.extentOffset.clamp(0, min.text.length));
      max.selection = TextSelection(
          baseOffset: maxSelection.baseOffset.clamp(0, max.text.length),
          extentOffset: maxSelection.extentOffset.clamp(0, max.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nama Pilihan',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        TextFormField(
                          controller: name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            widget.onChanged(
                                widget.pilihan.copyWith(nama: value));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.always,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      children: [
                        const Text(
                          'Minimal Pilih',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        TextFormField(
                          controller: min,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            widget.onChanged(widget.pilihan
                                .copyWith(minimal: int.tryParse(value) ?? 0));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }
                            // harus angka
                            if (int.tryParse(value) == null) {
                              return 'Harus angka';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.always,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      children: [
                        const Text(
                          'Maksimal Pilih',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        TextFormField(
                          controller: max,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            widget.onChanged(widget.pilihan
                                .copyWith(maksimal: int.tryParse(value) ?? 0));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harus diisi';
                            }
                            // harus angka
                            if (int.tryParse(value) == null) {
                              return 'Harus angka';
                            }
                            return null;
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
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ...widget.pilihan.makanan.mapIndexed((i, e) {
              return MakananForm(
                onChanged: (m) {
                  List<Makanan> copy = List.of(widget.pilihan.makanan);
                  if (m == null) {
                    copy.removeAt(i);
                  } else {
                    copy[i] = m;
                  }
                  widget.onChanged(widget.pilihan.copyWith(makanan: copy));
                },
                makanan: e,
              );
            }),
            ElevatedButton(
              onPressed: () {
                widget.onChanged(
                  widget.pilihan.copyWith(
                    makanan: [
                      ...widget.pilihan.makanan,
                      const Makanan(nama: '', harga: 0),
                    ],
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add),
                  const Text('Tambahkan Makanan'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
