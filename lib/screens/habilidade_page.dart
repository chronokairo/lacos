import 'package:flutter/material.dart';
import '../models/models.dart';
import '../../services/local_data_service.dart';

class HabilidadePage extends StatefulWidget {
  const HabilidadePage({super.key});

  @override
  State<HabilidadePage> createState() => _HabilidadePageState();
}

class _HabilidadePageState extends State<HabilidadePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (LocalDataService().usuarioLogado == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  void _adicionarHabilidade() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova Habilidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nomeController.clear();
                _descricaoController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nomeController.text.isNotEmpty) {
                  final usuario = LocalDataService().usuarioLogado;
                  if (usuario != null) {
                    final habilidade = Habilidade(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nome: _nomeController.text,
                      descricao: _descricaoController.text,
                    );
                    setState(() {
                      usuario.habilidades = [
                        ...usuario.habilidades,
                        habilidade,
                      ];
                    });
                  }
                  _nomeController.clear();
                  _descricaoController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _editarHabilidade(Habilidade habilidade) {
    _nomeController.text = habilidade.nome;
    _descricaoController.text = habilidade.descricao;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Habilidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nomeController.clear();
                _descricaoController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nomeController.text.isNotEmpty) {
                  final usuario = LocalDataService().usuarioLogado;
                  if (usuario != null) {
                    setState(() {
                      final idx = usuario.habilidades.indexWhere(
                        (h) => h.id == habilidade.id,
                      );
                      if (idx != -1) {
                        usuario.habilidades[idx] = Habilidade(
                          id: habilidade.id,
                          nome: _nomeController.text,
                          descricao: _descricaoController.text,
                        );
                      }
                    });
                  }
                  _nomeController.clear();
                  _descricaoController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removerHabilidade(Habilidade habilidade) {
    final usuario = LocalDataService().usuarioLogado;
    if (usuario != null) {
      setState(() {
        usuario.habilidades = usuario.habilidades
            .where((h) => h.id != habilidade.id)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = LocalDataService().usuarioLogado;
    final habilidades = usuario?.habilidades ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Habilidades')),
      body: Column(
        children: [
          // Trocas em Destaque
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Trocas de Habilidades em Destaque',
                  style: TextStyle(
                    color: Color(0xFF007bff),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          SizedBox(
            height: 170,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: const [
                  _TrocaDestaqueCard(
                    titulo: 'Desenvolvimento Web ↔ Design Gráfico',
                    descricao:
                        'Crie sites incríveis enquanto aprende a desenvolver interfaces visuais impactantes.',
                  ),
                  _TrocaDestaqueCard(
                    titulo: 'Fotografia ↔ Edição de Vídeo',
                    descricao:
                        'Capture momentos perfeitos e aprenda a criar vídeos dinâmicos e profissionais.',
                  ),
                  _TrocaDestaqueCard(
                    titulo: 'Idiomas ↔ Música',
                    descricao:
                        'Ensine um idioma e aprenda a tocar um instrumento musical com paixão.',
                  ),
                  _TrocaDestaqueCard(
                    titulo: 'Culinária ↔ Jardinagem',
                    descricao:
                        'Prepare pratos deliciosos enquanto aprende a cultivar ervas e vegetais frescos.',
                  ),
                  _TrocaDestaqueCard(
                    titulo: 'Marketing Digital ↔ Escrita Criativa',
                    descricao:
                        'Domine estratégias de marketing online e aprenda a criar histórias envolventes.',
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 32, thickness: 1),
          // Lista de habilidades do usuário
          Expanded(
            child: habilidades.isEmpty
                ? const Center(child: Text('Nenhuma habilidade cadastrada.'))
                : ListView.builder(
                    itemCount: habilidades.length,
                    itemBuilder: (context, index) {
                      final habilidade = habilidades[index];
                      return ListTile(
                        title: Text(habilidade.nome),
                        subtitle: Text(habilidade.descricao),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editarHabilidade(habilidade),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removerHabilidade(habilidade),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarHabilidade,
        tooltip: 'Adicionar Habilidade',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Card de Troca em Destaque
class _TrocaDestaqueCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  const _TrocaDestaqueCard({required this.titulo, required this.descricao});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: Colors.blue[50],
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF007bff),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(descricao, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
