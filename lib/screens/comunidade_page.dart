import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ComunidadePage extends StatelessWidget {
  const ComunidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidade Laços'),
        backgroundColor: const Color(0xFF007bff),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Estatísticas da comunidade
          Card(
            color: const Color(0xFFE3F2FD),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Nossa Comunidade em Números',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF007bff),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _StatItem('15.832', 'Membros Ativos'),
                      _StatItem('2.415', 'Novos Tópicos este Mês'),
                      _StatItem('12.109', 'Comentários Postados'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Formulário para novo tópico
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Crie um Novo Tópico',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF007bff),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Título do Tópico',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem(
                        value: '',
                        child: Text('Selecione uma Categoria'),
                      ),
                      DropdownMenuItem(
                        value: 'trocas',
                        child: Text('Trocas e Parcerias'),
                      ),
                      DropdownMenuItem(
                        value: 'dicas',
                        child: Text('Dicas de Habilidades'),
                      ),
                      DropdownMenuItem(
                        value: 'eventos',
                        child: Text('Eventos e Oficinas'),
                      ),
                      DropdownMenuItem(
                        value: 'suporte',
                        child: Text('Suporte e Dúvidas'),
                      ),
                      DropdownMenuItem(value: 'outros', child: Text('Outros')),
                    ],
                    onChanged: (_) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Escreva sua mensagem...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007bff),
                    ),
                    onPressed: () {},
                    child: const Text('Publicar Tópico'),
                  ),
                ],
              ),
            ),
          ),
          // Filtros de tópicos
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtrar Tópicos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF007bff),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          items: const [
                            DropdownMenuItem(
                              value: '',
                              child: Text('Categoria'),
                            ),
                            DropdownMenuItem(
                              value: 'trocas',
                              child: Text('Trocas e Parcerias'),
                            ),
                            DropdownMenuItem(
                              value: 'dicas',
                              child: Text('Dicas de Habilidades'),
                            ),
                            DropdownMenuItem(
                              value: 'eventos',
                              child: Text('Eventos e Oficinas'),
                            ),
                            DropdownMenuItem(
                              value: 'suporte',
                              child: Text('Suporte e Dúvidas'),
                            ),
                            DropdownMenuItem(
                              value: 'outros',
                              child: Text('Outros'),
                            ),
                          ],
                          onChanged: (_) {},
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Buscar por palavra-chave...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007bff),
                        ),
                        onPressed: () {},
                        child: const Text('Aplicar Filtros'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Destaques da comunidade (exemplo)
          Card(
            color: const Color(0xFFE3F2FD),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Destaques da Comunidade',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF007bff),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      _HighlightCard(
                        title: 'Troca de Sucesso!',
                        description:
                            'Clara e Miguel trocaram aulas de culinária e jardinagem, criando um jardim de ervas e pratos incríveis juntos!',
                      ),
                      _HighlightCard(
                        title: 'Evento Comunitário',
                        description:
                            'Junte-se à Oficina de Fotografia Criativa online, dia 20 de maio!',
                      ),
                      _HighlightCard(
                        title: 'Conquista da Comunidade',
                        description:
                            'Nossa comunidade atingiu 15.000 trocas realizadas! Parabéns a todos os membros!',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Lista de tópicos da comunidade (exemplo)
          const Text(
            'Tópicos da Comunidade',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF007bff),
            ),
          ),
          const SizedBox(height: 8),
          _CommunityPost(
            title:
                '[Dicas] João: Como melhorar minhas habilidades em programação?',
            content:
                'Olá, comunidade! Estou aprendendo Python há 3 meses e quero dicas para avançar. Como organizo meu estudo e quais projetos práticos posso fazer?',
            comments: [
              'Maria: Pratique com projetos reais, como um app de lista de tarefas.',
              'Carlos: Resolver desafios no HackerRank é ótimo.',
            ],
            likes: 23,
          ),
          // ...adicione outros tópicos conforme necessário
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF007bff),
          ),
        ),
        Text(label),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String title;
  final String description;
  const _HighlightCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF007bff),
            ),
          ),
          const SizedBox(height: 4),
          Text(description),
        ],
      ),
    );
  }
}

class _CommunityPost extends StatelessWidget {
  final String title;
  final String content;
  final List<String> comments;
  final int likes;
  const _CommunityPost({
    required this.title,
    required this.content,
    required this.comments,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF007bff),
              ),
            ),
            const SizedBox(height: 8),
            Text(content),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red[300], size: 20),
                const SizedBox(width: 4),
                Text('$likes'),
                const SizedBox(width: 16),
                TextButton(onPressed: () {}, child: const Text('Responder')),
              ],
            ),
            ...comments.map(
              (c) => Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.green[400]!, width: 3),
                  ),
                  color: Colors.green[50],
                ),
                child: Text(c),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Escreva sua resposta...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007bff),
                ),
                onPressed: () {},
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
