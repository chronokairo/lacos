import 'package:flutter/material.dart';
import '../models/models.dart';
import '../../services/local_data_service.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (LocalDataService().usuarioLogado == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _dataEvento;

  void _adicionarEvento() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo Evento'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Data:'),
                    const SizedBox(width: 8),
                    Text(
                      _dataEvento == null
                          ? 'Selecione'
                          : _dataEvento!.toLocal().toString().split(' ')[0],
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _dataEvento = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _tituloController.clear();
                _descricaoController.clear();
                _dataEvento = null;
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_tituloController.text.isNotEmpty && _dataEvento != null) {
                  LocalDataService().adicionarEvento(
                    Evento(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      titulo: _tituloController.text,
                      descricao: _descricaoController.text,
                      data: _dataEvento!,
                    ),
                  );
                  setState(() {});
                  _tituloController.clear();
                  _descricaoController.clear();
                  _dataEvento = null;
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

  void _mostrarDetalhes(Evento evento) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(evento.titulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descrição: ${evento.descricao}'),
              const SizedBox(height: 8),
              Text('Data: ${evento.data.toLocal().toString().split(' ')[0]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventos = LocalDataService().eventos;
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos')),
      body: ListView(
        children: [
          if (eventos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Nenhum evento cadastrado.')),
            )
          else
            ...List.generate(eventos.length, (index) {
              final evento = eventos[index];
              return ListTile(
                title: Text(evento.titulo),
                subtitle: Text(evento.data.toLocal().toString().split(' ')[0]),
                onTap: () => _mostrarDetalhes(evento),
              );
            }),
          const SizedBox(height: 32),
          // Dicas para Eventos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Dicas para Eventos',
              style: TextStyle(
                color: Color(0xFF007bff),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: const [
                _DicaEventoCard(
                  titulo: 'Prepare-se Antes',
                  descricao:
                      'Revise o cronograma do evento, leve materiais necessários (como caderno ou laptop) e chegue com antecedência.',
                ),
                _DicaEventoCard(
                  titulo: 'Interaja Ativamente',
                  descricao:
                      'Participe de discussões, troque contatos e aproveite para fazer perguntas aos facilitadores.',
                ),
                _DicaEventoCard(
                  titulo: 'Aproveite o Networking',
                  descricao:
                      'Leve cartões de visita ou use a plataforma Laços para conectar-se com outros participantes.',
                ),
                _DicaEventoCard(
                  titulo: 'Dê Feedback',
                  descricao:
                      'Compartilhe sua experiência no evento para ajudar a melhorar edições futuras.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Destaques de Eventos Passados
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Destaques de Eventos Passados',
              style: TextStyle(
                color: Color(0xFF007bff),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: const [
                _DestaqueEventoCard(
                  titulo: 'Hackathon Laços 2024',
                  descricao:
                      'Mais de 100 participantes colaboraram em projetos de tecnologia, criando soluções inovadoras em 48 horas!',
                  depoimento:
                      '"Foi incrível trabalhar em equipe e aprender com outros programadores!" - Carlos, desenvolvedor.',
                ),
                _DestaqueEventoCard(
                  titulo: 'Oficina de Escrita Criativa',
                  descricao:
                      'Participantes exploraram técnicas de storytelling, resultando em histórias compartilhadas na comunidade.',
                  depoimento:
                      '"Aprendi a transformar ideias em narrativas envolventes!" - Maria, escritora.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarEvento,
        tooltip: 'Adicionar Evento',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Dica para Eventos Card
class _DicaEventoCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  const _DicaEventoCard({required this.titulo, required this.descricao});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF007bff),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(descricao),
      ),
    );
  }
}

// Destaque de Evento Passado Card
class _DestaqueEventoCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String depoimento;
  const _DestaqueEventoCard({
    required this.titulo,
    required this.descricao,
    required this.depoimento,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Color(0xFF007bff),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(descricao),
            const SizedBox(height: 8),
            Text(
              depoimento,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
