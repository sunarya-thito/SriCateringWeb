import 'package:flutter/material.dart';

showLoadingOverlay(BuildContext context, Future future) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return FutureBuilder(
        future: future.whenComplete(() {
          Navigator.pop(context);
        }),
        builder: (context, snapshot) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    },
  );
}
