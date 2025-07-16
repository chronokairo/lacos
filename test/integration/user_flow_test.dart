import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lacos/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Flow Integration Tests', () {
    testWidgets('Complete user registration and login flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to finish
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to onboarding
      expect(find.text('Bem-vindo ao Laços'), findsOneWidget);

      // Skip onboarding
      await tester.tap(find.text('Pular'));
      await tester.pumpAndSettle();

      // Should navigate to main page, then to login (if not authenticated)
      // Wait for navigation
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // If we're on login page, test registration
      if (find.text('Bem-vindo ao Laços').evaluate().isNotEmpty) {
        // Navigate to registration
        await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
        await tester.pumpAndSettle();

        // Fill registration form
        expect(find.text('Cadastro Laços'), findsOneWidget);

        final nameField = find.byType(TextFormField).at(0);
        final emailField = find.byType(TextFormField).at(1);
        final passwordField = find.byType(TextFormField).at(2);

        await tester.enterText(nameField, 'Test User Integration');
        await tester.enterText(emailField, 'integration@test.com');
        await tester.enterText(passwordField, 'password123');

        // Submit registration
        await tester.tap(find.text('Cadastrar'));
        await tester.pumpAndSettle();

        // Wait for registration to complete
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should navigate back to login
        expect(find.text('Bem-vindo ao Laços'), findsOneWidget);

        // Now test login with registered credentials
        final loginEmailField = find.byType(TextFormField).at(0);
        final loginPasswordField = find.byType(TextFormField).at(1);

        await tester.enterText(loginEmailField, 'integration@test.com');
        await tester.enterText(loginPasswordField, 'password123');

        await tester.tap(find.text('Entrar'));
        await tester.pumpAndSettle();

        // Wait for login to complete
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should navigate to main page after successful login
        expect(find.text('Laços'), findsOneWidget);
        expect(find.text('Troque habilidades, transforme vidas!'), findsOneWidget);
      }
    });

    testWidgets('Skills management flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Assuming we're logged in (from previous test or setup)
      // Navigate to skills page through drawer
      
      // Wait for app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to skills
      await tester.tap(find.text('Habilidades'));
      await tester.pumpAndSettle();

      // Should be on skills page
      expect(find.text('Habilidades'), findsOneWidget);

      // Test adding a new skill
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill skill dialog
      expect(find.text('Nova Habilidade'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Nome').first,
        'Integration Test Skill',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Descrição').first,
        'This is a test skill for integration testing',
      );

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      // Skill should be added to the list
      expect(find.text('Integration Test Skill'), findsOneWidget);

      // Test editing the skill
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      expect(find.text('Editar Habilidade'), findsOneWidget);

      // Update skill name
      await tester.enterText(
        find.widgetWithText(TextField, 'Nome').first,
        'Updated Integration Test Skill',
      );

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      // Updated skill should be visible
      expect(find.text('Updated Integration Test Skill'), findsOneWidget);

      // Test deleting the skill
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      // Confirm deletion
      expect(find.text('Confirmar Exclusão'), findsOneWidget);
      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();

      // Skill should be removed
      expect(find.text('Updated Integration Test Skill'), findsNothing);
    });

    testWidgets('Events flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to events
      await tester.tap(find.text('Eventos'));
      await tester.pumpAndSettle();

      // Should be on events page
      expect(find.text('Eventos'), findsOneWidget);

      // Test adding a new event
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill event dialog
      expect(find.text('Novo Evento'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Título').first,
        'Integration Test Event',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Descrição').first,
        'This is a test event for integration testing',
      );

      // Select a future date
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();

      // Select tomorrow (assuming date picker is open)
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      await tester.tap(find.text(tomorrow.day.toString()).first);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      // Event should be added to the list
      expect(find.text('Integration Test Event'), findsOneWidget);
    });

    testWidgets('Navigation between pages', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test navigation through drawer
      final pages = [
        'Habilidades',
        'Mercado',
        'Eventos',
        'Comunidade',
        'Como Funciona',
        'Início',
      ];

      for (final page in pages) {
        // Open drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // Navigate to page
        await tester.tap(find.text(page));
        await tester.pumpAndSettle();

        // Verify we're on the correct page
        expect(find.text(page), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('Logout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Wait for app to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Tap logout
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();

      // Should navigate back to login page
      expect(find.text('Bem-vindo ao Laços'), findsOneWidget);
    });
  });
}