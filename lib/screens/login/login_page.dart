import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  String? _erro;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final sucesso = await authProvider.login(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (sucesso && mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      } else if (mounted) {
        setState(() {
          _erro = authProvider.error ?? 'Erro no login';
        });
      }
    }
  }

  void _irParaCadastro() {
    Navigator.pushNamed(context, '/cadastro');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          loadingMessage: 'Fazendo login...',
          child: Scaffold(
            // AppBar opcional para mobile
            body: Stack(
              children: [
                // Fundo com imagem
                SizedBox.expand(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1350&q=80',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
                // Overlay escuro
                Container(color: Colors.black.withOpacity(0.7)),
                // Conteúdo centralizado
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Bem-vindo ao Laços',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF007bff),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Uma plataforma para conectar pessoas com habilidades e quem deseja aprendê-las.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informe o email';
                                }
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Email inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _senhaController,
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Informe a senha'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: const Color(0xFF007bff),
                                ),
                                onPressed: _login,
                                child: const Text('Entrar'),
                              ),
                            ),
                            if (_erro != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _erro!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 12),
                            const Text(
                              'Ou faça login com',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SocialButton(
                                  color: Colors.red,
                                  icon: Icons.g_mobiledata,
                                  label: '',
                                  onTap: () {},
                                ),
                                SocialButton(
                                  color: Colors.blue,
                                  icon: Icons.linked_camera,
                                  label: '',
                                  onTap: () {},
                                ),
                                SocialButton(
                                  color: Colors.black,
                                  icon: Icons.alternate_email,
                                  label: '',
                                  onTap: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            TextButton(
                              onPressed: _irParaCadastro,
                              child: const Text(
                                'Não tem uma conta? Cadastre-se',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SocialButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 22,
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onTap,
      ),
    );
  }
}
