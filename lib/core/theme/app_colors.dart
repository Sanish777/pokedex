import 'package:flutter/material.dart';

class AppColors {
  // Nintendo Theme Core
  static const Color primaryRed = Color(0xFFE3350D);
  static const Color darkBackground = Color(0xFF111111);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceLight = Color(0xFF2C2C2C);
  
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFAAAAAA);

  // Pokemon Type Colors
  static const Color typeFire = Color(0xFFF08030);
  static const Color typeWater = Color(0xFF6890F0);
  static const Color typeGrass = Color(0xFF78C850);
  static const Color typeElectric = Color(0xFFF8D030);
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
