import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/data/models/move.dart';
import 'package:pokedex/data/models/item.dart';
import 'package:pokedex/data/providers/pokemon_provider.dart';

// --- Moves Provider ---

class MovesListState {
  final List<Move> moves;
  final bool isLoading;
  final int offset;
  final bool hasReachedMax;

  MovesListState({
    required this.moves,
    required this.isLoading,
    required this.offset,
    required this.hasReachedMax,
  });

  MovesListState copyWith({
    List<Move>? moves,
    bool? isLoading,
    int? offset,
    bool? hasReachedMax,
  }) {
    return MovesListState(
      moves: moves ?? this.moves,
      isLoading: isLoading ?? this.isLoading,
      offset: offset ?? this.offset,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class MovesListNotifier extends Notifier<MovesListState> {
  static const int _limit = 20;

  @override
  MovesListState build() {
    Future.microtask(() => fetchNextPage());
    return MovesListState(
      moves: [],
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
      final newMoves = await apiService.fetchMovesList(
        limit: _limit,
        offset: state.offset,
      );

      state = state.copyWith(
        moves: [...state.moves, ...newMoves],
        offset: state.offset + _limit,
        isLoading: false,
        hasReachedMax: newMoves.length < _limit,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final movesListProvider = NotifierProvider<MovesListNotifier, MovesListState>(() {
  return MovesListNotifier();
});

// --- Items Provider ---

class ItemsListState {
  final List<Item> items;
  final bool isLoading;
  final int offset;
  final bool hasReachedMax;

  ItemsListState({
    required this.items,
    required this.isLoading,
    required this.offset,
    required this.hasReachedMax,
  });

  ItemsListState copyWith({
    List<Item>? items,
    bool? isLoading,
    int? offset,
    bool? hasReachedMax,
  }) {
    return ItemsListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      offset: offset ?? this.offset,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class ItemsListNotifier extends Notifier<ItemsListState> {
  static const int _limit = 20;

  @override
  ItemsListState build() {
    Future.microtask(() => fetchNextPage());
    return ItemsListState(
      items: [],
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
      final newItems = await apiService.fetchItemsList(
        limit: _limit,
        offset: state.offset,
      );

      state = state.copyWith(
        items: [...state.items, ...newItems],
        offset: state.offset + _limit,
        isLoading: false,
        hasReachedMax: newItems.length < _limit,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final itemsListProvider = NotifierProvider<ItemsListNotifier, ItemsListState>(() {
  return ItemsListNotifier();
});
