class AppConstants {
  // App Info
  static const String appName = 'Laços';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Plataforma para troca de habilidades';

  // Colors
  static const int primaryColorValue = 0xFF4A7C59;
  static const int secondaryColorValue = 0xFF007bff;
  static const int backgroundColor = 0xFFF5F6F5;

  // URLs
  static const String defaultImageUrl = 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1350&q=80';
  static const String fallbackImageUrl = 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?auto=format&fit=crop&w=1920&q=80';

  // Validation
  static const int minPasswordLength = 6;
  static const int minNameLength = 2;
  static const int maxDescriptionLength = 500;

  // Security
  static const String passwordSalt = 'lacos_security_salt_2024';

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardElevation = 4.0;

  // Animation
  static const int defaultAnimationDuration = 300;
  static const int loadingDelay = 1000;

  // Error Messages
  static const String genericError = 'Ocorreu um erro inesperado. Tente novamente.';
  static const String networkError = 'Erro de conexão. Verifique sua internet.';
  static const String authError = 'Email ou senha inválidos.';
  static const String emailExistsError = 'Este email já está cadastrado.';
}