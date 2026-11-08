import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles_away/app/app.dart';

void main() {
  testWidgets('MilesAway app starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MilesAwayApp());

    expect(find.text('MilesAway'), findsOneWidget);
    expect(find.text('Moje podróże'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches between screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MilesAwayApp());

    await tester.tap(find.text('Mapa'));
    await tester.pumpAndSettle();
    expect(find.text('Mapa podróży'), findsOneWidget);

    await tester.tap(find.text('Statystyki').last);
    await tester.pumpAndSettle();
    expect(find.text('Statystyki').first, findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    expect(find.text('Profil').first, findsOneWidget);

    await tester.tap(find.text('Konto').last);
    await tester.pumpAndSettle();
    expect(find.text('Konto').first, findsOneWidget);

    await tester.tap(find.text('Podróże'));
    await tester.pumpAndSettle();
    expect(find.text('Moje podróże'), findsOneWidget);
  });

  testWidgets('User can open and close a details screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MilesAwayApp());

    await tester.ensureVisible(find.text('Otwórz szczegóły'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Otwórz szczegóły'));
    await tester.pumpAndSettle();

    expect(find.text('Szczegóły'), findsOneWidget);

    await tester.tap(find.text('Wróć'));
    await tester.pumpAndSettle();

    expect(find.text('Moje podróże'), findsOneWidget);
  });

  testWidgets('App works on a small screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MilesAwayApp());

    expect(find.text('MilesAway'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
