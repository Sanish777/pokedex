import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/main.dart';

void main() {
  testWidgets('App spawns and shows Pokédex title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PokedexApp()));

    expect(find.text('Pokédex'), findsWidgets);
  });
}
