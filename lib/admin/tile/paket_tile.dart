import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';

class PaketTile extends StatefulWidget {
  final Paket paket;
  const PaketTile({Key? key, required this.paket}) : super(key: key);

  @override
  _PaketTileState createState() => _PaketTileState();
}

class _PaketTileState extends State<PaketTile> {
  late Color _randomColor;

  @override
  void initState() {
    super.initState();
    // random bright color
    int minBrightness = 150;
    // _randomColor diisi dengan warna random yang lebih cerah dari minBrightness
    _randomColor = Color((minBrightness + 0xFF) +
            (DateTime.now().millisecondsSinceEpoch %
                (0xFFFFFF + 1 - minBrightness)))
        .withOpacity(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.paket.nama),
      subtitle: Text(widget.paket.id),
      childrenPadding: EdgeInsets.all(16),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              context.go('/admin/edit_paket?paket=${widget.paket.id}');
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Hapus Paket ${widget.paket.nama}?'),
                    content:
                        Text('Paket yang dihapus tidak dapat dikembalikan'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          // hapus paket
                          hapusPaket(widget.paket);
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text('Hapus'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          ),
        ],
      ),
      leading: ClipRRect(
        child: Container(
          color: _randomColor,
          height: 100,
          width: 100,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return FittedBox(
                  fit: BoxFit.cover,
                  child: snapshot.data!,
                );
              }
              return const SizedBox();
            },
            future: getImageOfPaket(widget.paket),
          ),
        ),
      ),
      children: [
        ListTile(
          title: Text('Harga'),
          subtitle: Text(widget.paket.baseHarga.toString()),
        ),
        ListTile(
          title: Text('Deskripsi'),
          subtitle: Text(widget.paket.deskripsi),
        ),
        ...widget.paket.pilihan.map((e) {
          return ExpansionTile(
              title: Text(e.nama),
              childrenPadding: EdgeInsets.all(16),
              children: [
                ListTile(
                  title: Text('Minimal'),
                  subtitle: Text(e.minimal.toString()),
                ),
                ListTile(
                  title: Text('Maksimal'),
                  subtitle: Text(e.maksimal.toString()),
                ),
                ...e.makanan.map((m) {
                  return ExpansionTile(
                      title: Text(m.nama),
                      childrenPadding: EdgeInsets.all(16),
                      children: [
                        ListTile(
                          title: Text('Harga'),
                          subtitle: Text(m.harga.toString()),
                        ),
                      ]);
                }),
              ]);
        }).toList(),
      ],
    );
  }
}
