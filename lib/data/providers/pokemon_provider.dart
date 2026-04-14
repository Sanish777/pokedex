import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/data/models/pokemon.dart';
import 'package:pokedex/data/services/poke_api_service.dart';

final pokeApiProvider = Provider<PokeApiService>((ref) => PokeApiService());

// FutureProvider for fetching extensive details of a specific Pokemon
final pokemonDetailProvider = FutureProvider.family<Pokemon, int>((ref, id) async {
  final apiService = ref.read(pokeApiProvider);
  return apiService.fetchPokemonDetails(id);
});

class PokemonListState {
  final List<Pokemon> pokemon;
  final bool isLoading;
  final int offset;
  final bool hasReachedMax;

  PokemonListState({
    required this.pokemon,
    required this.isLoading,
    required this.offset,
    required this.hasReachedMax,
  });

  PokemonListState copyWith({
    List<Pokemon>? pokemon,
    bool? isLoading,
    int? offset,
    bool? hasReachedMax,
  }) {
    return PokemonListState(
      pokemon: pokemon ?? this.pokemon,
      isLoading: isLoading ?? this.isLoading,
      offset: offset ?? this.offset,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class PokemonListNotifier extends Notifier<PokemonListState> {
  static const int _limit = 20;

  @override
  PokemonListState build() {
    Future.microtask(() => fetchNextPage());
    return PokemonListState(
      pokemon: [],
      isLoading: false,
      offset: 0,
      hasReachedMax: false,
    );
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasReachedMax) return;

    state = state.copyWith(isLoading: true);
    
    final apiService = ref.read(pokeApiProvider);

    try {
      final newPokemon = await apiService.fetchPokemonList(
        limit: _limit,
        offset: state.offset,
      );

      state = state.copyWith(
        pokemon: [...state.pokemon, ...newPokemon],
        offset: state.offset + _limit,
        isLoading: false,
        hasReachedMax: newPokemon.length < _limit,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final pokemonListProvider = NotifierProvider<PokemonListNotifier, PokemonListState>(() {
  return PokemonListNotifier();
});
