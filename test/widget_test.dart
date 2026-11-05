import 'package:flutter_test/flutter_test.dart';
import 'package:citrus_ai/main.dart';
import 'package:citrus_ai/core/constants/strings.dart';

void main() {
  testWidgets('CitrusAI smoke test loads SplashScreen with app title', (WidgetTester tester) async {
    await tester.pumpWidget(const CitrusAIApp());

    // Expect brand title and tagline on splash
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);
  });
}
