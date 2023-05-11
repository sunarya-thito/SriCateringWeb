import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/admin/form/paket_form.dart';
import 'package:sricatering/admin_page.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';

GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) => MaterialPage(
      child: Container(),
    ),
  ),
  GoRoute(
    path: '/admin',
    pageBuilder: (context, state) => const MaterialPage(
      child: AdminPage(),
    ),
    routes: [
      ...adminPages.mapIndexed((i, item) {
        return GoRoute(
          path: item.path,
          pageBuilder: (context, state) => MaterialPage(
            child: AdminPage(
              selectedIndex: i,
            ),
          ),
        );
      }),
      GoRoute(
        path: 'buat_paket',
        pageBuilder: (context, state) => const MaterialPage(
          child: PaketForm(),
        ),
      ),
      GoRoute(
        path: 'edit_paket',
        pageBuilder: (context, state) {
          final paketId = state.queryParameters['paket'] ?? '';
          Future<Paket> paketFuture = fetchPaket(paketId);
          return MaterialPage(
            child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Paket paket = snapshot.data as Paket;
                    return PaketForm(
                      paket: paket,
                    );
                  }
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Edit Paket'),
                    ),
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                future: paketFuture),
          );
        },
      )
    ],
  ),
]);
