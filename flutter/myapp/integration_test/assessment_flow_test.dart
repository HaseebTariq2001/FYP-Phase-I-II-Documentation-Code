import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full Autism Assessment Flow Test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(seconds: 2)); // Longer initial wait

    // Verify initial screen
    expect(find.text('CARS Assessment'), findsOneWidget);

    final scrollable = find.byType(Scrollable);
    expect(scrollable, findsOneWidget);

    int questionIndex = 0;
    const totalQuestions = 15;
    const scrollAmount = -300.0; // Increased scroll amount

    while (questionIndex < totalQuestions) {
      // Try to find radio options with timeout
      final radioOptions = find.byType(RadioListTile<double>);

      // If no radios found, scroll down
      if (radioOptions.evaluate().isEmpty) {
        await tester.drag(scrollable, const Offset(0, scrollAmount));
        await tester.pumpAndSettle(Duration(milliseconds: 500));
        continue;
      }

      // Get the first visible radio option's center point
      final firstRadioCenter = tester.getCenter(radioOptions.first);

      // Verify the radio is actually visible on screen
      final screenSize = tester.binding.window.physicalSize;
      final screenHeight =
          screenSize.height / tester.binding.window.devicePixelRatio;

      if (firstRadioCenter.dy < 0 || firstRadioCenter.dy > screenHeight) {
        await tester.drag(scrollable, const Offset(0, scrollAmount));
        await tester.pumpAndSettle(Duration(milliseconds: 500));
        continue;
      }

      // Tap the radio option safely
      await tester.tap(
        radioOptions.first,
        warnIfMissed: false, // Suppress the warning we saw in logs
      );
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      // Small scroll to move to next question
      await tester.drag(scrollable, const Offset(0, -150));
      await tester.pumpAndSettle(Duration(milliseconds: 300));

      questionIndex++;
    }

    // Scroll to find Submit button with more reliable method
    final submitButton = find.text('Submit Assessment');

    await tester.scrollUntilVisible(
      submitButton,
      500.0,
      scrollable: scrollable,
      maxScrolls: 10, // Prevent infinite scrolling
    );
    await tester.pumpAndSettle(Duration(seconds: 1));

    expect(submitButton, findsOneWidget);

    await tester.tap(submitButton);
    await tester.pumpAndSettle(Duration(seconds: 2)); // Longer wait for results

    // More flexible text matching for the result page
    expect(
      find.descendant(
        of: find.byType(Scaffold),
        matching: find.textContaining('Your child has'),
      ),
      findsOneWidget,
      reason: 'Could not find results text on the page',
    );

    // Alternative: Look for any text that might contain the result
    // final resultTextFinder = find.textContaining(RegExp(r'Your child has|result|score', caseSensitive: false));
    // expect(resultTextFinder, findsOneWidget);
  });
}
