import 'package:flutter/material.dart';

class ManagePage extends StatelessWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
