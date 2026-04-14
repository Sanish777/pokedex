import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/data/providers/favorites_provider.dart';
import 'package:pokedex/data/providers/pokemon_provider.dart';
import 'package:pokedex/widgets/pokemon_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.favorite_border, size: 80, color: AppColors.textGrey.withValues(alpha: 0.3)),
                   const SizedBox(height: 16),
                   const Text(
                     'No favorites yet!',
                     style: TextStyle(fontSize: 18, color: AppColors.textGrey, fontWeight: FontWeight.bold),
                   ),
                   const SizedBox(height: 8),
                   const Text(
                     'Tape the heart on a Pokémon to add it here.',
                     style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                   ),
                ],
              ).animate().fadeIn().scale(),
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: favoriteIds.length,
                  itemBuilder: (context, index) {
                    final id = favoriteIds.elementAt(index);
                    // Fetch basic details for each favorite id
                    final pokemonAsync = ref.watch(pokemonDetailProvider(id));

                    return pokemonAsync.when(
                      data: (pokemon) => PokemonCard(
                        id: pokemon.id,
                        index: index, // Index in the favorites list
                        name: pokemon.name,
                        primaryType: pokemon.primaryType,
                        imageUrl: pokemon.imageUrl,
                      ),
                      loading: () => Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, st) => Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(child: Icon(Icons.error, color: Colors.red)),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
