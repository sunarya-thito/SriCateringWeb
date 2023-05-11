import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sricatering/admin/form/paket_form.dart';
import 'package:sricatering/admin_page.dart';

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
      GoRoute(
        path: 'buat_paket',
        pageBuilder: (context, state) => const MaterialPage(
          child: PaketForm(),
        ),
      ),
    ],
  ),
]);
