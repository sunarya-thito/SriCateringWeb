import 'package:flutter/material.dart';

class ManagePaketPage extends StatefulWidget {
  const ManagePaketPage({Key? key}) : super(key: key);

  @override
  State<ManagePaketPage> createState() => _ManagePaketPageState();
}

class _ManagePaketPageState extends State<ManagePaketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // push BuatPaketForm
          Navigator.pushNamed(context, '/buat_paket');
        },
        label: const Text('Tambah Menu'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
