class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int hp;
  final int attack;
  final int defense;
  final int speed;
  final String description; // Flavor text
  final double height; // in meters (API provides decimeters)
  final double weight; // in kg (API provides hectograms)

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    this.hp = 0,
    this.attack = 0,
    this.defense = 0,
    this.speed = 0,
    this.description = '',
    this.height = 0.0,
    this.weight = 0.0,
  });

  String get primaryType => types.isNotEmpty ? types.first : 'Normal';

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    var typesList = <String>[];
    if (json['types'] != null) {
      for (var t in json['types']) {
        typesList.add(_capitalize(t['type']['name'] as String));
      }
    }

    int getStat(String name) {
      if (json['stats'] == null) return 0;
      var stat = (json['stats'] as List).firstWhere(
        (s) => s['stat']['name'] == name,
        orElse: () => {'base_stat': 0},
      );
      return stat['base_stat'] as int;
    }

    String desc = '';
    if (json['species_data'] != null) {
      final entries = json['species_data']['flavor_text_entries'] as List;
      final englishEntry = entries.firstWhere(
        (e) => e['language']['name'] == 'en',
        orElse: () => {'flavor_text': 'No description available.'},
      );
      // Clean up weird API newline characters
      desc = (englishEntry['flavor_text'] as String).replaceAll('\n', ' ').replaceAll('\f', ' ');
    }

    return Pokemon(
      id: json['id'] as int,
      name: _capitalize(json['name'] as String),
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${json['id']}.png',
      types: typesList,
      hp: getStat('hp'),
      attack: getStat('attack'),
      defense: getStat('defense'),
      speed: getStat('speed'),
      description: desc,
      height: (json['height'] ?? 0) / 10.0, // decimeters to meters
      weight: (json['weight'] ?? 0) / 10.0, // hectograms to kg
    );
  }

  // Helper factory just for the list view since the list api only returns name/url
  factory Pokemon.fromListJson(Map<String, dynamic> json) {
    // Extract ID from URL (e.g. "url": "https://pokeapi.co/api/v2/pokemon/1/")
    final urlStr = json['url'] as String;
    final parts = urlStr.split('/');
    final idStr = parts[parts.length - 2];
    final id = int.parse(idStr);

    return Pokemon(
      id: id,
      name: _capitalize(json['name'] as String),
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      types: ['Normal'], // Placeholder until full details are fetched
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
