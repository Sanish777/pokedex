import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/data/models/pokemon.dart';
import 'package:pokedex/data/providers/pokemon_provider.dart';
import 'package:pokedex/data/providers/favorites_provider.dart';

class PokemonDetailScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const PokemonDetailScreen({super.key, required this.initialIndex});

  @override
  ConsumerState<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends ConsumerState<PokemonDetailScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(pokemonListProvider);
    final pokemonList = listState.pokemon;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      // Wrap in PageView for easy swiping between Pokemon
      body: PageView.builder(
        controller: _pageController,
        itemCount: pokemonList.length,
        onPageChanged: (index) {
          // If we are reaching the end of our current chunk, load next page implicitly
          if (index >= pokemonList.length - 2) {
             ref.read(pokemonListProvider.notifier).fetchNextPage();
          }
        },
        itemBuilder: (context, index) {
          final basicPokemon = pokemonList[index];
          // Use Riverpod to fetch the detailed species data for this swiped pokemon
          final detailAsync = ref.watch(pokemonDetailProvider(basicPokemon.id));

          return _buildDetailPage(context, basicPokemon, detailAsync);
        },
      ),
    );
  }

  Widget _buildDetailPage(BuildContext context, Pokemon basicPokemon, AsyncValue<Pokemon> detailAsync) {
    // Determine color using the simple list data as a placeholder until deep data loads
    final baseColor = AppColors.getColorForType(basicPokemon.primaryType);

    return detailAsync.when(
      loading: () => _buildLayout(context, basicPokemon, baseColor, isLoading: true),
      error: (e, st) => Center(child: Text('Error loading! $e')),
      data: (detailedPokemon) => _buildLayout(context, detailedPokemon, AppColors.getColorForType(detailedPokemon.primaryType)),
    );
  }

  // Master UI matching the Image exactly
  Widget _buildLayout(BuildContext context, Pokemon pokemon, Color typeColor, {bool isLoading = false}) {
    return Stack(
      children: [
        // Top Curved Background
        ClipPath(
          clipper: _TopCurveClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: typeColor,
              // Adding the watermark Pokeball
              image: const DecorationImage(
                image: AssetImage('assets/pokeball_watermark.png'), // Placeholder or fallback to icon
                fit: BoxFit.none,
                alignment: Alignment(1.2, -0.2),
                opacity: 0.1,
              ),
            ),
          ),
        ),
        
        // Navigation Icons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                IconButton(
                  icon: Icon(
                    ref.watch(favoritesProvider).contains(pokemon.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: ref.watch(favoritesProvider).contains(pokemon.id)
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(pokemon.id);
                  },
                ).animate(
                  target: ref.watch(favoritesProvider).contains(pokemon.id) ? 1 : 0,
                ).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 200.ms, curve: Curves.bounceOut),
              ],
            ),
          ),
        ),

        // Main content column
        SafeArea(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              
              // Animated Pokemon Image resting on the curve
              Hero(
                tag: 'pokemon_image_${pokemon.id}',
                child: Image.network(
                  pokemon.imageUrl,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),
              
              // Card Details
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBlack,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 5),
                      // ID
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textGrey,
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: 15),

                      // Types Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: pokemon.types.map((type) {
                          final color = AppColors.getColorForType(type);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8));
                        }).toList(),
                      ),

                      const SizedBox(height: 30),
                      
                      // Flavor Text or Loading block
                      if (isLoading)
                        const SizedBox(
                          height: 40,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else
                        Text(
                          pokemon.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textBlack,
                            height: 1.5,
                          ),
                        ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 30),

                      // Weight / Height Grid
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMeasurementCard(Icons.fitness_center, '${pokemon.weight} kg', 'Weight'),
                          Container(width: 1, height: 40, color: Colors.grey.withValues(alpha: 0.3)),
                          _buildMeasurementCard(Icons.height, '${pokemon.height} m', 'Height'),
                        ],
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                      
                      const Spacer(),
                      // Swipe Hint
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chevron_left, color: AppColors.textGrey, size: 16),
                          Text(
                            'Swipe for more',
                            style: TextStyle(
                              color: AppColors.textGrey.withValues(alpha: 0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 16),
                        ],
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                       .fadeIn(duration: 1.seconds)
                       .moveX(begin: -5, end: 5),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textGrey),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textBlack)),
          ],
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGrey, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// Custom Clipper generating the exact rounded arc seen in the image reference
class _TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    // A nice soft quadratic bezier curve
    path.quadraticBezierTo(size.width / 2, size.height + 30, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
