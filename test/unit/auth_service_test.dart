import 'package:flutter_test/flutter_test.dart';
import 'package:lacos/services/auth_service.dart';
import 'package:lacos/models/models.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    group('User Registration', () {
      test('should successfully register a new user', () async {
        final result = await authService.register(
          'Test User',
          'test@example.com',
          'password123',
        );

        expect(result['success'], true);
        expect(result['user'], isA<Usuario>());
        expect(result['user'].nome, 'Test User');
        expect(result['user'].email, 'test@example.com');
      });

      test('should fail registration with invalid email', () async {
        final result = await authService.register(
          'Test User',
          'invalid-email',
          'password123',
        );

        expect(result['success'], false);
        expect(result['error'], 'Email inválido');
      });

      test('should fail registration with short password', () async {
        final result = await authService.register(
          'Test User',
          'test@example.com',
          '123',
        );

        expect(result['success'], false);
        expect(result['error'], contains('pelo menos'));
      });

      test('should fail registration with short name', () async {
        final result = await authService.register(
          'A',
          'test@example.com',
          'password123',
        );

        expect(result['success'], false);
        expect(result['error'], contains('pelo menos 2 caracteres'));
      });

      test('should fail registration with duplicate email', () async {
        // Register first user
        await authService.register(
          'User One',
          'test@example.com',
          'password123',
        );

        // Try to register second user with same email
        final result = await authService.register(
          'User Two',
          'test@example.com',
          'password456',
        );

        expect(result['success'], false);
        expect(result['error'], 'Email já cadastrado');
      });
    });

    group('User Login', () {
      setUp(() async {
        // Register a test user
        await authService.register(
          'Test User',
          'test@example.com',
          'password123',
        );
      });

      test('should successfully login with correct credentials', () async {
        final result = await authService.login(
          'test@example.com',
          'password123',
        );

        expect(result['success'], true);
        expect(result['user'], isA<Usuario>());
        expect(result['token'], isA<String>());
        expect(result['user'].email, 'test@example.com');
      });

      test('should fail login with wrong password', () async {
        final result = await authService.login(
          'test@example.com',
          'wrongpassword',
        );

        expect(result['success'], false);
        expect(result['error'], 'Senha incorreta');
      });

      test('should fail login with non-existent email', () async {
        final result = await authService.login(
          'nonexistent@example.com',
          'password123',
        );

        expect(result['success'], false);
        expect(result['error'], 'Usuário não encontrado');
      });

      test('should fail login with empty credentials', () async {
        final result = await authService.login('', '');

        expect(result['success'], false);
      });

      test('should be case insensitive for email', () async {
        final result = await authService.login(
          'TEST@EXAMPLE.COM',
          'password123',
        );

        expect(result['success'], true);
      });
    });

    group('Token Management', () {
      test('should generate valid token on login', () async {
        await authService.register(
          'Test User',
          'test@example.com',
          'password123',
        );

        final result = await authService.login(
          'test@example.com',
          'password123',
        );

        expect(result['success'], true);
        expect(result['token'], isA<String>());
        
        final token = result['token'] as String;
        expect(token.split('.').length, 3); // JWT has 3 parts
        expect(authService.isTokenExpired(token), false);
      });

      test('should detect expired tokens', () {
        // Create a token that's already expired
        const expiredToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjMiLCJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20iLCJpYXQiOjE2MDAwMDAwMDAsImV4cCI6MTYwMDAwMDAwMH0.invalidtoken';
        
        expect(authService.isTokenExpired(expiredToken), true);
      });

      test('should handle invalid token format', () {
        const invalidToken = 'invalid.token.format.extra';
        
        expect(authService.isTokenExpired(invalidToken), true);
      });
    });

    group('Profile Update', () {
      late Usuario testUser;

      setUp(() async {
        final registerResult = await authService.register(
          'Test User',
          'test@example.com',
          'password123',
        );
        testUser = registerResult['user'];
      });

      test('should successfully update user profile', () async {
        final updatedUser = testUser.copyWith(
          nome: 'Updated Name',
          bio: 'New bio',
        );

        final result = await authService.updateProfile(updatedUser);

        expect(result['success'], true);
        expect(result['user'].nome, 'Updated Name');
        expect(result['user'].bio, 'New bio');
      });

      test('should fail update with invalid email', () async {
        final updatedUser = testUser.copyWith(email: 'invalid-email');

        final result = await authService.updateProfile(updatedUser);

        expect(result['success'], false);
        expect(result['error'], 'Email inválido');
      });

      test('should fail update with short name', () async {
        final updatedUser = testUser.copyWith(nome: 'A');

        final result = await authService.updateProfile(updatedUser);

        expect(result['success'], false);
        expect(result['error'], contains('pelo menos 2 caracteres'));
      });

      test('should fail update with duplicate email', () async {
        // Register another user
        await authService.register(
          'Another User',
          'another@example.com',
          'password123',
        );

        // Try to update first user with second user's email
        final updatedUser = testUser.copyWith(email: 'another@example.com');

        final result = await authService.updateProfile(updatedUser);

        expect(result['success'], false);
        expect(result['error'], 'Email já está em uso');
      });
    });
  });
}