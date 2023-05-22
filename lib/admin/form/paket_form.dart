import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/admin/form/pilihan_paket_form.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';
import 'package:sricatering/ui_util.dart';
import 'package:transparent_image/transparent_image.dart';

class PaketForm extends StatefulWidget {
  final Paket? paket;
  const PaketForm({Key? key, this.paket}) : super(key: key);

  @override
  _PaketFormState createState() => _PaketFormState();
}

class _PaketFormState extends State<PaketForm> {
  static final ImageProvider defaultImage = MemoryImage(kTransparentImage);
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();

  final List<PilihanPaket> pilihan = [];

  ImageProvider? image;

  @override
  void initState() {
    super.initState();
    var paket = widget.paket;
    if (paket != null) {
      name.text = paket.nama;
      price.text = paket.baseHarga.toString();
      description.text = paket.deskripsi;

      pilihan.addAll(paket.pilihan);
    }
  }

  Widget createFormInput(String text, TextEditingController controller,
      {bool multiline = false, bool isNumber = false, bool required = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        required
            ? Text(
                '$text (* Wajib Diisi)',
              )
            : Text(text),
        if (multiline)
          TextFormField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          )
        else
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (required && (value == null || value.isEmpty)) {
                return 'Tidak boleh kosong';
              }
              if (value != null && isNumber && int.tryParse(value) == null) {
                return 'Harus angka';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.always,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paket == null
            ? 'Buat Paket'
            : 'Edit Paket - ${widget.paket!.nama}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.go('/admin/manage_paket');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.paket == null) {
                // buat paket
                var paket = Paket(
                  id: '',
                  nama: name.text,
                  baseHarga: int.parse(price.text),
                  deskripsi: description.text,
                  pilihan: pilihan,
                );
                String? validasi = paket.validasi();
                if (validasi != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(validasi),
                    ),
                  );
                  return;
                }
                showLoadingOverlay(
                    context,
                    tambahPaket(paket).then((value) {
                      if (image is MemoryImage) {
                        updateImageOfPaket(value, (image as MemoryImage).bytes);
                      }
                      // post frame
                      return value;
                    }).whenComplete(() {
                      // show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil mengubah paket'),
                        ),
                      );
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () {
                          context.go('/admin/manage_paket');
                        },
                      );
                    }));
              } else {
                // edit paket
                var paket = Paket(
                    id: widget.paket!.id,
                    nama: name.text,
                    pilihan: pilihan,
                    baseHarga: int.tryParse(price.text) ?? 0,
                    deskripsi: description.text);
                String? validasi = paket.validasi();
                if (validasi != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(validasi),
                    ),
                  );
                  return;
                }
                showLoadingOverlay(
                    context,
                    updatePaket(paket).then((value) {
                      if (image is MemoryImage) {
                        updateImageOfPaket(value, (image as MemoryImage).bytes);
                      } else if (image == defaultImage) {
                        deleteImageOfPaket(value);
                      }
                      // post frame
                      return value;
                    }).whenComplete(() {
                      // show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil mengubah paket'),
                        ),
                      );
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () {
                          context.go('/admin/manage_paket');
                        },
                      );
                    }));
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (image is MemoryImage && image != defaultImage) {
                          // hapus gambar
                          setState(() {
                            image = defaultImage;
                          });
                          return;
                        }
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                dialogTitle: 'Pilih Gambar',
                                type: FileType.image);
                        if (result != null) {
                          setState(() {
                            image = MemoryImage(result.files.single.bytes!);
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image(image: image!),
                                ),
                              )
                            : widget.paket != null
                                ? FutureBuilder(
                                    future:
                                        getImageOfPaket(widget.paket!, false),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: snapshot.data,
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.add),
                                      Text('Tambahkan Photo'),
                                    ],
                                  ),
                      ),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 16),
                      createFormInput('Nama Paket', name),
                      const SizedBox(height: 24),
                      createFormInput('Harga', price, isNumber: true),
                      const SizedBox(height: 24),
                      createFormInput('Deskripsi', description,
                          multiline: true, required: false),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...pilihan.mapIndexed((i, e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: PilihanPaketForm(
                        pilihan: e,
                        onChanged: (p) {
                          setState(() {
                            if (p == null) {
                              pilihan.removeAt(i);
                            } else {
                              pilihan[i] = p;
                            }
                          });
                        },
                      ),
                    );
                  }),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pilihan.add(const PilihanPaket(
                          makanan: [],
                          maksimal: 0,
                          minimal: 0,
                          nama: '',
                        ));
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add),
                        Text('Tambahkan Opsi'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
