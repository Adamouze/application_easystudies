// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../utilities/constantes.dart';
import '../../logs/auth_stat.dart';



class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool showQR = true;

  @override
  Widget build(BuildContext context) {
    double diameter = MediaQuery.of(context).size.width * 0.9;

    // Fetch identifier from AuthState
    String? identifier = Provider.of<AuthState>(context, listen: false).identifier;
    String? data = identifier ?? 'EASYSTUDIES'; // Use identifier as data

    // ... Rest of your code

    return Scaffold(
      backgroundColor: orangePerso,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: diameter,
                  height: diameter,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(diameter * 0.15),
                    child: showQR
                        ? QrImageView(
                      data: data,
                      version: QrVersions.auto,
                      size: diameter * 0.7,
                    )
                        : Center(
                      child: BarcodeWidget(
                        barcode: Barcode.code39(),  // Use appropriate barcode encoding
                        data: data,
                        width: diameter * 0.7,
                        height: diameter * 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space between QR Code and button
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: orangePerso, backgroundColor: Colors.white, // this sets the color of the button's text and icon
                      textStyle: const TextStyle(fontSize: 20, fontFamily: 'NotoSans',fontWeight: FontWeight.bold), // adjust font size here
                    ),
                    onPressed: () {
                      setState(() {
                        showQR = !showQR;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 200,
                      alignment: Alignment.center,
                      child: Text(showQR ? 'Afficher code-barres' : 'Afficher QR Code'),
                    )
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,  // Adjust the position of the button here
            child: SizedBox(
              height: 70.0, // Set container height
              width: 70.0,  // Set container width
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the previous screen
                },
                backgroundColor: Colors.blueAccent,
                shape: const CircleBorder(), // Circular shape
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 40.0,  // Increase icon size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
