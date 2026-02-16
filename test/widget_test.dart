import 'package:flutter_test/flutter_test.dart';

import 'package:monthly_budget/main.dart';
import 'package:monthly_budget/pages/home_page.dart';
import 'package:monthly_budget/pages/stats_page.dart';

void main() {
  testWidgets('switches between home and statistics from bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Monthly Budget'), findsOneWidget);
    expect(find.byType(StatsPage), findsNothing);

    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();

    expect(find.byType(StatsPage), findsOneWidget);
    expect(find.text('No data for this month.'), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });
}
