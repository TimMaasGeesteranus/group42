import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ho_pla/model/item.dart';
import 'package:ho_pla/util/current_user.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeWidget extends StatefulWidget {
  final Item item;

  const QrCodeWidget(this.item, {super.key});

  @override
  State<QrCodeWidget> createState() => _QrCodeWidgetState();
}

class _QrCodeWidgetState extends State<QrCodeWidget> {
  final qrKey = GlobalKey();
  String data = "";

  @override
  void initState() {
    super.initState();
    data = "hopla://localhost/${CurrentUser.id}/${widget.item.id}";
  }

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
        "QR Code Generator",
        Column(
          children: [
            RepaintBoundary(
              key: qrKey,
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
              ),
            ),
            TextButton(
                onPressed: onPrintClicked, child: const Text("Share to print"))
          ],
        ));
  }

  void onPrintClicked() async {
    final boundary =
        qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await (image.toByteData(format: ImageByteFormat.png));

    if (byteData != null) {
      final pngBytes = byteData.buffer.asUint8List();
      var xFile = XFile.fromData(pngBytes, mimeType: "image/png");
      await Share.shareXFiles([xFile]);
    }
  }
}
