import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utilities/constantes.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orangePerso,
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double diameter = MediaQuery.of(context).size.width * 0.9;
            return Container(
              width: diameter,
              height: diameter,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(diameter * 0.15),
                child: QrImageView(
                  data: 'https://www.youtube.com/watch?v=ZZ5LpwO-An4&list=PLDLnJA_LGxsJjv9-9ZmQtuOr5YuqK1ah6',
                  version: QrVersions.auto,
                  size: diameter * 0.7,
                ),
              ),
            );
          },
        ),

      ),
    );
  }
}
