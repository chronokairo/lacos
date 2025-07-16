import 'package:flutter/material.dart';
import 'screens/login/login_page.dart';
import 'screens/login/cadastro_page.dart';
import 'screens/comofunciona_page.dart';
import 'screens/comunidade_page.dart';
import 'screens/eventos_page.dart';
import 'screens/habilidade_page.dart';
import 'screens/mercado_page.dart';
import 'screens/main_page.dart';
import 'screens/onboarding_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lacos',
      theme: appTheme,
      initialRoute: '/onboarding',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/comofunciona': (context) => const ComoFuncionaPage(),
        '/comunidade': (context) => const ComunidadePage(),
        '/eventos': (context) => const EventosPage(),
        '/habilidade': (context) => const HabilidadePage(),
        '/mercado': (context) => const MercadoPage(),
        '/main': (context) => const MainPage(),
        '/onboarding': (context) => const OnboardingPage(),
      },
    );
  }
}
