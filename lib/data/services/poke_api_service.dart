import 'package:dio/dio.dart';
import 'package:pokedex/data/models/pokemon.dart';
import 'package:pokedex/data/models/move.dart';
import 'package:pokedex/data/models/item.dart';

class PokeApiService {
  final Dio _dio;

  PokeApiService()
      : _dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'));

  /// Fetch a paginated list of basic Pokemon info
  Future<List<Pokemon>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    try {
      final response = await _dio.get('pokemon', queryParameters: {
        'limit': limit,
        'offset': offset,
      });

      final List results = response.data['results'];
      return results.map((json) => Pokemon.fromListJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load Pokemon list: $e');
    }
  }

  /// Fetch deep details for a specific Pokemon by ID (stats + species description)
  Future<Pokemon> fetchPokemonDetails(int id) async {
    try {
      final futures = await Future.wait([
        _dio.get('pokemon/$id'),
        _dio.get('pokemon-species/$id'),
      ]);

      final basicData = futures[0].data;
      final speciesData = futures[1].data;

      // Combine relevant data
      basicData['species_data'] = speciesData;

      return Pokemon.fromJson(basicData);
    } catch (e) {
      throw Exception('Failed to load details for Pokemon $id: $e');
    }
  }

  /// Fetch a paginated list of basic Moves
  Future<List<Move>> fetchMovesList({int limit = 20, int offset = 0}) async {
    try {
      final response = await _dio.get('move', queryParameters: {
        'limit': limit,
        'offset': offset,
      });

      final List results = response.data['results'];
      return results.map((json) => Move.fromListJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load moves list: $e');
    }
  }

  /// Fetch a paginated list of basic Items
  Future<List<Item>> fetchItemsList({int limit = 20, int offset = 0}) async {
    try {
      final response = await _dio.get('item', queryParameters: {
        'limit': limit,
        'offset': offset,
      });

      final List results = response.data['results'];
      return results.map((json) => Item.fromListJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load items list: $e');
    }
  }
}
