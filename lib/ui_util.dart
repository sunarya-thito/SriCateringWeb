import 'package:flutter/material.dart';
import 'package:sricatering/model/database.dart';
import 'package:sricatering/model/menu.dart';

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

class WebContainerWidth extends InheritedWidget {
  final double width;

  const WebContainerWidth({
    Key? key,
    required this.width,
    required Widget child,
  }) : super(key: key, child: child);

  static WebContainerWidth? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WebContainerWidth>();
  }

  @override
  bool updateShouldNotify(WebContainerWidth oldWidget) {
    return width != oldWidget.width;
  }
}

showPaketImageOverlay(BuildContext context, Widget paket) {
  OverlayEntry? entry;
  entry = OverlayEntry(
    builder: (ct) {
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              minScale: 0.3,
              maxScale: 3,
              child: paket,
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                alignment: Alignment.center,
                child: SizedBox(
                    width: WebContainerWidth.of(context)?.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          color: Colors.white,
                          iconSize: 32,
                          onPressed: () {
                            entry?.remove();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      );
    },
  );
  Overlay.of(context).insert(entry);
}
