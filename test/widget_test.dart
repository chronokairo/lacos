import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lacos/main.dart';
import 'package:lacos/providers/auth_provider.dart';
import 'package:lacos/providers/skills_provider.dart';
import 'package:lacos/providers/events_provider.dart';
import 'package:lacos/screens/login/login_page.dart';
import 'package:lacos/screens/login/cadastro_page.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App should start with splash screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify that splash screen is shown
      expect(find.text('Laços'), findsOneWidget);
      expect(
        find.text('Conectando pessoas através de habilidades'),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Login page should have required fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SkillsProvider()),
            ChangeNotifierProvider(create: (_) => EventsProvider()),
          ],
          child: MaterialApp(home: const LoginPage()),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify login form elements
      expect(find.text('Bem-vindo ao Laços'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(2),
      ); // Email and password fields
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Não tem uma conta? Cadastre-se'), findsOneWidget);
    });

    testWidgets('Registration page should validate required fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SkillsProvider()),
            ChangeNotifierProvider(create: (_) => EventsProvider()),
          ],
          child: MaterialApp(home: const CadastroPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Verify registration form elements
      expect(find.text('Cadastro Laços'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // Name, email, password fields
      expect(find.text('Cadastrar'), findsOneWidget);

      // Test form validation
      await tester.tap(find.text('Cadastrar'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Informe o nome'), findsOneWidget);
      expect(find.text('Informe o email'), findsOneWidget);
      expect(find.text('Informe a senha'), findsOneWidget);
    });
  });

  group('Authentication Tests', () {
    testWidgets('Should validate email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SkillsProvider()),
            ChangeNotifierProvider(create: (_) => EventsProvider()),
          ],
          child: MaterialApp(home: const LoginPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.text('Email inválido'), findsOneWidget);
    });

    testWidgets('Should validate password length', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SkillsProvider()),
            ChangeNotifierProvider(create: (_) => EventsProvider()),
          ],
          child: MaterialApp(home: const CadastroPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Find form fields
      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);

      // Enter valid name and email, but short password
      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '123');

      await tester.tap(find.text('Cadastrar'));
      await tester.pump();

      expect(
        find.text('Senha deve ter pelo menos 6 caracteres'),
        findsOneWidget,
      );
    });
  });

  group('Navigation Tests', () {
    testWidgets('Should navigate from login to registration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SkillsProvider()),
            ChangeNotifierProvider(create: (_) => EventsProvider()),
          ],
          child: MaterialApp(
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginPage(),
              '/cadastro': (context) => const CadastroPage(),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify we're on login page
      expect(find.text('Bem-vindo ao Laços'), findsOneWidget);

      // Tap registration link
      await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
      await tester.pumpAndSettle();

      // Verify we're on registration page
      expect(find.text('Cadastro Laços'), findsOneWidget);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('Should display error messages', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SkillsProvider()),
            ChangeNotifierProvider(create: (_) => EventsProvider()),
          ],
          child: MaterialApp(home: const LoginPage()),
        ),
      );

      await tester.pumpAndSettle();

      // Enter valid format but non-existent credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'nonexistent@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');

      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Should show error message (the exact message depends on the auth provider implementation)
      expect(find.textContaining('Erro'), findsAtLeastNWidgets(1));
    });
  });
}
