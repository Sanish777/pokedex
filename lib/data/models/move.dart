class Move {
  final int id;
  final String name;
  final String type;
  final int? power;
  final int? accuracy;
  final int? pp;
  final String description;

  Move({
    required this.id,
    required this.name,
    required this.type,
    this.power,
    this.accuracy,
    this.pp,
    required this.description,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    String flavorText = '';
    if (json['flavor_text_entries'] != null) {
      final entries = json['flavor_text_entries'] as List;
      final englishEntry = entries.firstWhere(
        (e) => e['language']['name'] == 'en',
        orElse: () => {'flavor_text': 'No description available.'},
      );
      flavorText = (englishEntry['flavor_text'] as String)
          .replaceAll('\n', ' ')
          .replaceAll('\f', ' ');
    }

    return Move(
      id: json['id'] as int,
      name: _capitalize(json['name'] as String),
      type: _capitalize(json['type']['name'] as String),
      power: json['power'] as int?,
      accuracy: json['accuracy'] as int?,
      pp: json['pp'] as int?,
      description: flavorText,
    );
  }

  factory Move.fromListJson(Map<String, dynamic> json) {
    final urlStr = json['url'] as String;
    final id = int.parse(urlStr.split('/').where((s) => s.isNotEmpty).last);

    return Move(
      id: id,
      name: _capitalize(json['name'] as String),
      type: '', // To be loaded later or ignored in list
      description: '',
    );
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
