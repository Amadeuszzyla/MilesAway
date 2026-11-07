import 'package:flutter_test/flutter_test.dart';
import 'package:miles_away/app/app.dart';

void main() {
  testWidgets('MilesAway app starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MilesAwayApp());

    expect(find.text('MilesAway'), findsOneWidget);
  });
}
