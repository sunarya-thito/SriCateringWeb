import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/admin/manage_paket_page.dart';

class AdminPage extends StatefulWidget {
  final int selectedIndex;
  const AdminPage({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class PageItem {
  final String path;
  final String label;
  final Widget page;

  const PageItem({
    required this.path,
    required this.label,
    required this.page,
  });
}

const List<PageItem> adminPages = [
  PageItem(
    path: 'manage_paket',
    label: 'Manage Paket',
    page: ManagePaketPage(),
  ),
  PageItem(
    path: 'pemesanan',
    label: 'Pemesanan',
    page: Text('Pemesanan'),
  ),
];

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

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
            ...adminPages.mapIndexed((index, item) {
              return ListTile(
                title: Text(item.label),
                selected: index == _selectedIndex,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    context.pushReplacement('/admin/${item.path}');
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
        title: Text('SRI CATERING - ${adminPages[_selectedIndex].label}'),
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
      body: adminPages[_selectedIndex].page,
    );
  }
}
