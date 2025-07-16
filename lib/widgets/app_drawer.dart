import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final usuario = authProvider.currentUser;

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(usuario?.nome ?? 'Usuário'),
                accountEmail: Text(usuario?.email ?? 'email@exemplo.com'),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    usuario?.nome.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                decoration: const BoxDecoration(color: Color(0xFF4A7C59)),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Início'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/main');
                },
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Habilidades'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/habilidade');
                },
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Mercado'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/mercado');
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Eventos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/eventos');
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Comunidade'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/comunidade');
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Como Funciona'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/comofunciona');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
