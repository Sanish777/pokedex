class Item {
  final int id;
  final String name;
  final String category;
  final int? cost;
  final String description;
  final String imageUrl;

  Item({
    required this.id,
    required this.name,
    required this.category,
    this.cost,
    required this.description,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    String effect = '';
    if (json['effect_entries'] != null) {
      final entries = json['effect_entries'] as List;
      final englishEntry = entries.firstWhere(
        (e) => e['language']['name'] == 'en',
        orElse: () => {'short_effect': 'No description available.'},
      );
      effect = (englishEntry['short_effect'] as String)
          .replaceAll('\n', ' ')
          .replaceAll('\f', ' ');
    }

    return Item(
      id: json['id'] as int,
      name: _capitalize(json['name'] as String),
      category: _capitalize(json['category']['name'] as String),
      cost: json['cost'] as int?,
      description: effect,
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/${json['name']}.png',
    );
  }

  factory Item.fromListJson(Map<String, dynamic> json) {
    final urlStr = json['url'] as String;
    final id = int.parse(urlStr.split('/').where((s) => s.isNotEmpty).last);
    final name = json['name'] as String;

    return Item(
      id: id,
      name: _capitalize(name),
      category: '',
      description: '',
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/$name.png',
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
