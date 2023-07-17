// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner {
  final BuildContext context;

  Scanner({required this.context});

  Future<String?> scanBarcode() async {
    String? scanBarcode;
    try {
      scanBarcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff9100",
        "Cancel",
        true,
        ScanMode.DEFAULT,
      );
    } on Exception {
      print('Failed to get platform version.');
    }
    return scanBarcode;
  }
}
