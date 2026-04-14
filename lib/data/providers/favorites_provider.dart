import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends Notifier<Set<int>> {
  static const _key = 'favorite_pokemon_ids';

  @override
  Set<int> build() {
    _loadFavorites();
    return {};
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesString = prefs.getStringList(_key);
    if (favoritesString != null) {
      state = favoritesString.map((id) => int.parse(id)).toSet();
    }
  }

  Future<void> toggleFavorite(int pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    final newFavorites = Set<int>.from(state);
    
    if (newFavorites.contains(pokemonId)) {
      newFavorites.remove(pokemonId);
    } else {
      newFavorites.add(pokemonId);
    }
    
    state = newFavorites;
    await prefs.setStringList(_key, state.map((id) => id.toString()).toList());
  }

  bool isFavorite(int pokemonId) {
    return state.contains(pokemonId);
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(() {
  return FavoritesNotifier();
});
