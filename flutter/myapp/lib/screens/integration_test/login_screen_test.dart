import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login & Create Account Integration Tests', () {
    testWidgets('Register navigation and Login attempt', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');

      await tester.enterText(emailField, 'testuser@example.com');
      await tester.enterText(passwordField, 'TestPass123');

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Login Successful'), findsOneWidget);
    });

    testWidgets('Navigate to create account screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final signUpLink = find.widgetWithText(TextButton, "Don't have an account? Sign up");

      await tester.tap(signUpLink);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Create Account'), findsOneWidget);
    });

    testWidgets('Register a new account', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final signUpLink = find.widgetWithText(TextButton, "Don't have an account? Sign up");
      await tester.tap(signUpLink);
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final createButton = find.widgetWithText(ElevatedButton, 'Create Account');

      await tester.enterText(emailField, 'newuser@example.com');
      await tester.enterText(passwordField, 'TestPass@123');

      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Account Created'), findsOneWidget);
    });

    testWidgets('Child Profile creation validation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Assuming we're now on ChildProfileScreen after login or account creation
      final nameField = find.widgetWithText(TextFormField, "Child's Name/Username");
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final ageField = find.byType(TextFormField).last;
      final generateButton = find.widgetWithText(ElevatedButton, "Generate Child’s Login");

      await tester.enterText(nameField, 'TestChild');
      await tester.enterText(passwordField, 'child123');
      await tester.enterText(ageField, '6');

      await tester.tap(generateButton);
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('profile created successfully'), findsOneWidget);
    });
  });
}