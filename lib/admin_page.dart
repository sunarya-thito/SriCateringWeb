import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sricatering/admin/manage_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class PageItem {
  final String label;
  final Widget page;

  const PageItem({
    required this.label,
    required this.page,
  });
}

class _AdminPageState extends State<AdminPage> {
  final List<PageItem> pages = const [
    PageItem(
      label: 'Manage Paket',
      page: ManagePage(),
    ),
    PageItem(
      label: 'Manage Makanan',
      page: Text('Manage Makanan'),
    ),
    PageItem(
      label: 'Pemesanan',
      page: Text('Pemesanan'),
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('SRI CATERING'),
            ),
            ...pages.mapIndexed((index, item) {
              return ListTile(
                title: Text(item.label),
                selected: index == _selectedIndex,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('SRI CATERING - ${pages[_selectedIndex].label}'),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // show drawer
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: pages[_selectedIndex].page,
    );
  }
}
