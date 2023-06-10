import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final String title;
  final MaterialAccentColor color;

  CustomAppBar({Key? key, required this.title, required this.color,})
      : super(
    key: key,
    preferredSize: const Size.fromHeight(80.0),
    child: AppBar(
      toolbarHeight: 80.0,
      backgroundColor: color,
      title: Row(
        children: [
          SizedBox(
            width: 70,
            height: 80,
            child: Stack(
              children: [
                Positioned(
                  top: 5, // adjust this to move logo vertically
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 5, // match this with Container's top
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150), // n'importe quoi > 35
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Noto Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const Spacer(flex: 1),

          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(150),
                ),
                padding: const EdgeInsets.all(3),
              ),
              child: const FittedBox(
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 50,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ),



        ],
      ),
    ),
  );
}
