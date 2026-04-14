import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/widgets/pokedex_search_bar.dart';
import 'package:pokedex/widgets/pokemon_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data to visualize the UI before Phase 3 (API Connection)
    final dummyPokemon = [
      {'id': 1, 'name': 'Bulbasaur', 'type': 'Grass', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png'},
      {'id': 4, 'name': 'Charmander', 'type': 'Fire', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png'},
      {'id': 7, 'name': 'Squirtle', 'type': 'Water', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png'},
      {'id': 25, 'name': 'Pikachu', 'type': 'Electric', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png'},
      {'id': 94, 'name': 'Gengar', 'type': 'Ghost', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/94.png'},
      {'id': 149, 'name': 'Dragonite', 'type': 'Dragon', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/149.png'},
      {'id': 150, 'name': 'Mewtwo', 'type': 'Psychic', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/150.png'},
      {'id': 133, 'name': 'Eevee', 'type': 'Normal', 'img': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/133.png'},
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Dynamic App Bar
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.darkBackground,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Pokédex',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
              background: Stack(
                children: [
                  // Decorative Pokeball background graphic
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Icon(
                      Icons.catching_pokemon,
                      size: 200,
                      color: AppColors.textWhite.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: PokedexSearchBar(
                onChanged: (val) {
                  // TODO: Implement local filtering or search
                },
              ),
            ),
          ),

          // Pokemon Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final pokemon = dummyPokemon[index];
                  return PokemonCard(
                    id: pokemon['id'] as int,
                    name: pokemon['name'] as String,
                    primaryType: pokemon['type'] as String,
                    imageUrl: pokemon['img'] as String,
                  );
                },
                childCount: dummyPokemon.length,
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }
}
