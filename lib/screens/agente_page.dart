import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/agent_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';

class AgentePage extends StatefulWidget {
  const AgentePage({super.key});

  @override
  State<AgentePage> createState() => _AgentePageState();
}

class _AgentePageState extends State<AgentePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        Provider.of<AgentProvider>(context, listen: false)
            .carregarDadosAgente(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agente IA'),
        backgroundColor: const Color(0xFF6f42c1),
      ),
      drawer: const AppDrawer(),
      body: Consumer<AgentProvider>(
        builder: (context, agentProvider, child) {
          if (agentProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6f42c1)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Analisando seu perfil...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6f42c1),
                    ),
                  ),
                ],
              ),
            );
          }

          if (agentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    agentProvider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      if (authProvider.currentUser != null) {
                        agentProvider.carregarDadosAgente(
                            authProvider.currentUser!.id);
                      }
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6f42c1), Color(0xFF007bff)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: const Column(
                  children: [
                    Icon(
                      Icons.psychology,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Seu Agente IA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Descobrindo as melhores conexões para você',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dicas Personalizadas
              if (agentProvider.dicas.isNotEmpty) ...[
                _SectionCard(
                  title: 'Dicas Personalizadas',
                  icon: Icons.lightbulb,
                  color: Colors.orange,
                  child: Column(
                    children: agentProvider.dicas
                        .map((dica) => _DicaItem(texto: dica))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Matches
              if (agentProvider.matches.isNotEmpty) ...[
                _SectionCard(
                  title: 'Seus Matches',
                  icon: Icons.people,
                  color: Colors.green,
                  child: Column(
                    children: agentProvider.matches
                        .take(5)
                        .map((match) => _MatchItem(match: match))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Recomendações
              if (agentProvider.recomendacoes.isNotEmpty) ...[
                _SectionCard(
                  title: 'Habilidades Recomendadas',
                  icon: Icons.recommend,
                  color: Colors.blue,
                  child: Column(
                    children: agentProvider.recomendacoes
                        .map((rec) => _RecomendacaoItem(recomendacao: rec))
                        .toList(),
                  ),
                ),
              ],

              // Estado vazio
              if (agentProvider.matches.isEmpty &&
                  agentProvider.recomendacoes.isEmpty &&
                  agentProvider.dicas.isEmpty) ...[
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Complete seu perfil para receber recomendações!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Adicione suas habilidades na página de perfil.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _DicaItem extends StatelessWidget {
  final String texto;

  const _DicaItem({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 15, height: 1.4),
      ),
    );
  }
}

class _MatchItem extends StatelessWidget {
  final dynamic match; // SkillMatch from agent_service.dart

  const _MatchItem({required this.match});

  @override
  Widget build(BuildContext context) {
    final porcentagem = (match.compatibilidade * 100).round();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  match.nomeUsuario.isNotEmpty 
                      ? match.nomeUsuario[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.nomeUsuario,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '$porcentagem% de compatibilidade',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            match.explicacao,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          if (match.habilidadesComplementares.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: match.habilidadesComplementares
                  .take(3)
                  .map<Widget>((habilidade) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          habilidade,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecomendacaoItem extends StatelessWidget {
  final dynamic recomendacao; // SkillRecommendation from agent_service.dart

  const _RecomendacaoItem({required this.recomendacao});

  @override
  Widget build(BuildContext context) {
    final porcentagem = (recomendacao.pontuacao * 100).round();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recomendacao.nomeHabilidade,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '$porcentagem% recomendado para você',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            recomendacao.razao,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          if (recomendacao.usuariosQueEnsinam.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Professores disponíveis: ${recomendacao.usuariosQueEnsinam.join(', ')}',
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}