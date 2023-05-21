import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/admin/admin_page_auth_wrapper.dart';
import 'package:sricatering/admin/form/paket_form.dart';
import 'package:sricatering/admin_page.dart';
import 'package:sricatering/main/home_page.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';

GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) => MaterialPage(
      child: HomePage(),
    ),
  ),
  GoRoute(
    path: '/admin',
    pageBuilder: (context, state) => const MaterialPage(
      child: AdminPageAuthWrapper(child: AdminPage()),
    ),
    routes: [
      ...adminPages.mapIndexed((i, item) {
        return GoRoute(
          path: item.path,
          pageBuilder: (context, state) => MaterialPage(
            child: AdminPageAuthWrapper(
                child: AdminPage(
              selectedIndex: i,
            )),
          ),
        );
      }),
      GoRoute(
        path: 'buat_paket',
        pageBuilder: (context, state) => const MaterialPage(
          child: AdminPageAuthWrapper(child: PaketForm()),
        ),
      ),
      GoRoute(
        path: 'edit_paket',
        pageBuilder: (context, state) {
          final paketId = state.queryParameters['paket'] ?? '';
          Future<Paket> paketFuture = fetchPaket(paketId);
          return MaterialPage(
            child: AdminPageAuthWrapper(
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
                    future: paketFuture)),
          );
        },
      )
    ],
  ),
]);
