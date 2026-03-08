import 'package:flutter_test/flutter_test.dart';
import 'package:habitforge/main.dart';

void main() {
  testWidgets('HabitForge smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HabitForgeApp());
  });
}
