import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';

class PokemonCard extends StatelessWidget {
  final int id;
  final String name;
  final String primaryType; // e.g. "Grass"
  final String imageUrl;

  const PokemonCard({
    super.key,
    required this.id,
    required this.name,
    required this.primaryType,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = AppColors.getColorForType(primaryType);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: typeColor.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Gradient effect for the Type
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.8, 0.8),
                    radius: 0.8,
                    colors: [
                      typeColor.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Pokeball watermark icon (Top right)
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.catching_pokemon,
              size: 140,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${id.toString().padLeft(3, '0')}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: typeColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        primaryType,
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Pokemon Image overlapping bounds
          Positioned(
            right: 8,
            bottom: 8,
            height: 90,
            width: 90,
            child: Hero(
              tag: 'pokemon_image_$id',
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
