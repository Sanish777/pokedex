import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Core
  static const Color primaryBlue = Color(0xFF58ABF6); // Replaced red to match generic light ui often seen in modern UI
  static const Color lightBackground = Color(0xFFF5F7FA); // Very slight off height for scaffold
  static const Color whiteSurface = Color(0xFFFFFFFF); // Pure white cards
  
  static const Color textBlack = Color(0xFF2C3E50); // Dark sleek text
  static const Color textGrey = Color(0xFF7F8C8D); // Subtitles

  // Pokemon Type Colors
  static const Color typeFire = Color(0xFFFFA756); // Softer bright colors suitable for light UI
  static const Color typeWater = Color(0xFF58ABF6);
  static const Color typeGrass = Color(0xFF8BBE8A);
  static const Color typeElectric = Color(0xFFFFCE4B);
  static const Color typePoison = Color(0xFFA040A0);
  static const Color typeIce = Color(0xFF98D8D8);
  static const Color typeFighting = Color(0xFFC03028);
  static const Color typeGround = Color(0xFFE0C068);
  static const Color typeFlying = Color(0xFFA890F0);
  static const Color typePsychic = Color(0xFFF85888);
  static const Color typeBug = Color(0xFFA8B820);
  static const Color typeRock = Color(0xFFB8A038);
  static const Color typeGhost = Color(0xFF705898);
  static const Color typeDragon = Color(0xFF7038F8);
  static const Color typeDark = Color(0xFF705848);
  static const Color typeSteel = Color(0xFFB8B8D0);
  static const Color typeFairy = Color(0xFFEE99AC);
  static const Color typeNormal = Color(0xFFA8A878);

  static Color getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'fire': return typeFire;
      case 'water': return typeWater;
      case 'grass': return typeGrass;
      case 'electric': return typeElectric;
      case 'poison': return typePoison;
      case 'ice': return typeIce;
      case 'fighting': return typeFighting;
      case 'ground': return typeGround;
      case 'flying': return typeFlying;
      case 'psychic': return typePsychic;
      case 'bug': return typeBug;
      case 'rock': return typeRock;
      case 'ghost': return typeGhost;
      case 'dragon': return typeDragon;
      case 'dark': return typeDark;
      case 'steel': return typeSteel;
      case 'fairy': return typeFairy;
      default: return typeNormal;
    }
  }
}
