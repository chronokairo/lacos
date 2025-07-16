import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/skills_provider.dart';
import 'providers/events_provider.dart';
import 'screens/login/login_page.dart';
import 'screens/login/cadastro_page.dart';
import 'screens/comofunciona_page.dart';
import 'screens/comunidade_page.dart';
import 'screens/eventos_page.dart';
import 'screens/habilidade_page.dart';
import 'screens/mercado_page.dart';
import 'screens/main_page.dart';
import 'screens/onboarding_page.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, SkillsProvider>(
          create: (_) => SkillsProvider(),
          update: (_, auth, skills) {
            if (auth.currentUser != null && skills != null) {
              skills.initializeSkills(auth.currentUser!.id);
            }
            return skills ?? SkillsProvider();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
          create: (_) => EventsProvider(),
          update: (_, auth, events) {
            if (auth.isAuthenticated && events != null) {
              events.initializeEvents();
              if (auth.currentUser != null) {
                events.loadUserEvents(auth.currentUser!.id);
              }
            }
            return events ?? EventsProvider();
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Laços',
            theme: appTheme,
            home: const SplashScreen(),
            routes: {
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
        },
      ),
    );
  }
}
