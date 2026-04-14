import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class PokedexSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const PokedexSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.textBlack),
      decoration: const InputDecoration(
        hintText: 'Search Pokémon, Move, Ability etc',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
