import 'package:flutter/material.dart';

const orangePerso = Colors.orangeAccent;
const couleurIcone = Colors.white;

const double tailleSmiley = 30;
const double arrondiBox = 10;

Image smiley1 = Image.asset('assets/smiley/1.png', height: tailleSmiley);
Image smiley2 = Image.asset('assets/smiley/2.png', height: tailleSmiley);
Image smiley3 = Image.asset('assets/smiley/3.png', height: tailleSmiley);
Image smiley4 = Image.asset('assets/smiley/4.png', height: tailleSmiley);
Image smiley5 = Image.asset('assets/smiley/5.png', height: tailleSmiley);

const Image add_bilan = Image(
  image: AssetImage('assets/divers/add_bilan.png'),
  alignment: Alignment.center,
);

const String photoMisterV = "https://covers-ng3.hosting-media.net/art/r288/641835.jpg";
const String photoAdamouze = "https://www.reussiralecole.fr/wp-content/uploads/2022/09/fantome-dessin-11.jpg";
const String photoAlaska = "https://img-31.ccm2.net/9cktEUL6z0jOnDlgru1FSwe7bkA=/595x/smart/fa9ca80f1f954f3899fc84cb881295b7/ccmcms-hugo/10600435.png";

String getDefaultPhoto(String genre) {
  if (genre == "Mlle") {
    return "assets/images/avatar_fille.png";
  } else {
    return "assets/images/avatar.png";
  }
}

