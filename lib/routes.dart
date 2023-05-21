import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/admin/admin_page_auth_wrapper.dart';
import 'package:sricatering/admin/form/paket_form.dart';
import 'package:sricatering/admin/pemesanan_page.dart';
import 'package:sricatering/admin_page.dart';
import 'package:sricatering/main/page/home_page.dart';
import 'package:sricatering/main/page/order_page.dart';
import 'package:sricatering/main/standard_page.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';

import 'main/page/paket_page.dart';

GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    pageBuilder: (context, state) => MaterialPage(
      child: StandardPage(key: Key('HomePage'), child: HomePage()),
    ),
  ),
  GoRoute(
    path: '/paket/:paketId',
    pageBuilder: (context, state) {
      final paketId = state.pathParameters['paketId'] ?? '';
      return MaterialPage(
        child: StandardPage(
            key: ValueKey(paketId),
            child: PaketPage(
              paketId: paketId,
            )),
      );
    },
  ),
  GoRoute(
    path: '/me',
    pageBuilder: (context, state) {
      return MaterialPage(
        child: StandardPage(
          key: const ValueKey('MePage'),
          child: OrderPage(),
        ),
      );
    },
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
        path: 'pemesanan',
        pageBuilder: (context, state) => MaterialPage(
          child: AdminPageAuthWrapper(
            child: PemesananPage(),
          ),
        ),
      ),
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
