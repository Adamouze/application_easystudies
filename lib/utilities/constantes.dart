import 'package:flutter/material.dart';

const orangePerso = Colors.orangeAccent;
const couleurIcone = Colors.white;

const double tailleSmiley = 30;
const double arrondiBox = 10;
const double epaisseurContour = 2;
const double espacementBlocsDetailsEleve = 15;

Image smiley1 = Image.asset('assets/smiley/1.png', height: tailleSmiley);
Image smiley2 = Image.asset('assets/smiley/2.png', height: tailleSmiley);
Image smiley3 = Image.asset('assets/smiley/3.png', height: tailleSmiley);
Image smiley4 = Image.asset('assets/smiley/4.png', height: tailleSmiley);
Image smiley5 = Image.asset('assets/smiley/5.png', height: tailleSmiley);

Widget getSmiley(String rating) {
  switch (rating) {
    case "1":
      return smiley1;
    case "2":
      return smiley2;
    case "3":
      return smiley3;
    case "4":
      return smiley4;
    case "5":
      return smiley5;
    default:
      return Container();
  }
}

const Image addBilan = Image(
  image: AssetImage('assets/divers/add_bilan.png'),
  alignment: Alignment.center,
);

const Image detailsBilan = Image(
  image: AssetImage('assets/divers/bilan.png'),
  alignment: Alignment.center,
  width: 40,
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

