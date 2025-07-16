import 'package:flutter/material.dart';
import '../services/local_data_service.dart';
import '../widgets/app_drawer.dart';

class OfertaTroca {
  final String nome;
  final String oferece;
  final String busca;
  final String descricao;

  OfertaTroca({
    required this.nome,
    required this.oferece,
    required this.busca,
    required this.descricao,
  });
}

class MercadoPage extends StatefulWidget {
  const MercadoPage({super.key});

  @override
  State<MercadoPage> createState() => _MercadoPageState();
}

class _MercadoPageState extends State<MercadoPage> {
  final List<OfertaTroca> _ofertas = [
    OfertaTroca(
      nome: 'João Silva',
      oferece: 'Aulas de Violão',
      busca: 'Prática de Espanhol',
      descricao:
          'João é um músico apaixonado que dá aulas de violão há 5 anos. Quer melhorar seu espanhol para viajar pela América Latina.',
    ),
    OfertaTroca(
      nome: 'Ana Costa',
      oferece: 'Noções de Desenvolvimento Web',
      busca: 'Aulas de Yoga',
      descricao:
          'Ana é desenvolvedora front-end e ensina HTML e CSS. Busca yoga para relaxar e melhorar sua saúde.',
    ),
    // Adicione mais ofertas conforme necessário
  ];

  String _categoria = '';
  String _formato = '';
  String _busca = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (LocalDataService().usuarioLogado == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ofertasFiltradas = _ofertas.where((oferta) {
      final buscaLower = _busca.toLowerCase();
      return (_busca.isEmpty ||
          oferta.oferece.toLowerCase().contains(buscaLower) ||
          oferta.busca.toLowerCase().contains(buscaLower) ||
          oferta.nome.toLowerCase().contains(buscaLower));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mercado de Trocas')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estatísticas
              Card(
                color: Colors.blue[50],
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _StatColumn(label: 'Usuários Ativos', value: '12.543'),
                      _StatColumn(label: 'Novos este Mês', value: '1.872'),
                      _StatColumn(label: 'Trocas Realizadas', value: '9.321'),
                    ],
                  ),
                ),
              ),
              // Filtros
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtrar Ofertas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _categoria.isEmpty ? null : _categoria,
                              decoration: const InputDecoration(
                                labelText: 'Categoria',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text('Todas'),
                                ),
                                DropdownMenuItem(
                                  value: 'tecnologia',
                                  child: Text('Tecnologia'),
                                ),
                                DropdownMenuItem(
                                  value: 'idiomas',
                                  child: Text('Idiomas'),
                                ),
                                DropdownMenuItem(
                                  value: 'artes',
                                  child: Text('Artes'),
                                ),
                                DropdownMenuItem(
                                  value: 'culinaria',
                                  child: Text('Culinária'),
                                ),
                                DropdownMenuItem(
                                  value: 'bem-estar',
                                  child: Text('Bem-Estar'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _categoria = v ?? ''),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _formato.isEmpty ? null : _formato,
                              decoration: const InputDecoration(
                                labelText: 'Formato',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text('Todos'),
                                ),
                                DropdownMenuItem(
                                  value: 'online',
                                  child: Text('Online'),
                                ),
                                DropdownMenuItem(
                                  value: 'presencial',
                                  child: Text('Presencial'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _formato = v ?? ''),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Buscar por habilidade...',
                        ),
                        onChanged: (v) => setState(() => _busca = v),
                      ),
                    ],
                  ),
                ),
              ),
              // Ofertas de Trocas
              const Text(
                'Ofertas de Trocas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              ...ofertasFiltradas.map(
                (oferta) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          oferta.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Oferece: ${oferta.oferece}'),
                        Text('Busca: ${oferta.busca}'),
                        const SizedBox(height: 6),
                        Text(
                          oferta.descricao,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Entrar em Contato'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (ofertasFiltradas.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Nenhuma oferta encontrada.')),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicione lógica para criar nova oferta
        },
        tooltip: 'Nova Oferta',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
