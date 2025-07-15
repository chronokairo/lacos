import 'package:flutter/material.dart';

class ComoFuncionaPage extends StatelessWidget {
  const ComoFuncionaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Como Funciona o Laços'),
        backgroundColor: const Color(0xFF007bff),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF007bff), Color(0xFF00c4b4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Como Funciona o Laços',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'Aprenda como trocar habilidades de forma simples e colaborativa!',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // O que é o Laços
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'O que é o Laços?',
                    style: TextStyle(
                      color: Color(0xFF007bff),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'O Laços é uma plataforma inovadora que conecta pessoas interessadas em trocar habilidades e conhecimentos. '
                    'A ideia é simples: você ensina algo que sabe e aprende algo que deseja, sem a necessidade de pagamentos financeiros. '
                    'Seja ensinar culinária, aprender um idioma ou trocar dicas de marketing, o Laços promove o aprendizado mútuo e a colaboração.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Como funciona? (Steps)
          const Text(
            'Como funciona?',
            style: TextStyle(
              color: Color(0xFF007bff),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StepCard(
                    number: '1',
                    title: 'Cadastro',
                    description:
                        'Crie uma conta na plataforma e preencha seu perfil com suas habilidades e interesses. Um perfil detalhado aumenta suas chances de encontrar bons parceiros!',
                  ),
                  if (isWide)
                    const SizedBox(width: 16)
                  else
                    const SizedBox(height: 16),
                  _StepCard(
                    number: '2',
                    title: 'Busca',
                    description:
                        'Navegue pela plataforma para encontrar pessoas que oferecem as habilidades que você deseja aprender. Use filtros como categoria ou localização para refinar sua busca.',
                  ),
                  if (isWide)
                    const SizedBox(width: 16)
                  else
                    const SizedBox(height: 16),
                  _StepCard(
                    number: '3',
                    title: 'Conexão',
                    description:
                        'Entre em contato com outros usuários para combinar uma troca de habilidades. Discuta expectativas e formatos (online ou presencial).',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Dicas para uma Troca Bem-Sucedida
          const Text(
            'Dicas para uma Troca Bem-Sucedida',
            style: TextStyle(
              color: Color(0xFF007bff),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const _BulletList(
            items: [
              'Seja claro sobre suas expectativas: defina o tempo, formato e nível de habilidade desejado.',
              'Prepare-se para ensinar: organize seu conteúdo para facilitar o aprendizado do outro.',
              'Respeite o tempo do parceiro: cumpra os horários combinados e seja pontual.',
              'Comunique-se abertamente: tire dúvidas e ajuste a troca conforme necessário.',
              'Divirta-se: aproveite o processo de ensinar e aprender algo novo!',
            ],
          ),
          const SizedBox(height: 32),

          // Benefícios do Laços
          const Text(
            'Benefícios do Laços',
            style: TextStyle(
              color: Color(0xFF007bff),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const _BulletList(
            items: [
              'Aprenda novas habilidades de forma gratuita, economizando em cursos ou aulas.',
              'Compartilhe seu conhecimento com outras pessoas, contribuindo para a comunidade.',
              'Construa uma rede de contatos com interesses semelhantes, abrindo portas para colaborações futuras.',
              'Promova a colaboração e o aprendizado mútuo, fortalecendo laços e desenvolvendo-se pessoal e profissionalmente.',
            ],
          ),
          const SizedBox(height: 32),

          // Perguntas Frequentes (FAQ)
          const Text(
            'Perguntas Frequentes',
            style: TextStyle(
              color: Color(0xFF007bff),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const _FaqItem(
            question:
                'Posso trocar habilidades mesmo sem experiência profissional?',
            answer:
                'Sim! No Laços, todos os níveis de habilidade são bem-vindos. Você pode oferecer algo que sabe, como cozinhar uma receita caseira, e aprender algo novo, como tocar um instrumento básico.',
          ),
          const _FaqItem(
            question: 'As trocas são sempre presenciais?',
            answer:
                'Não! Você pode combinar trocas presenciais ou online, via videochamadas ou troca de materiais. Escolha o formato que for mais conveniente para ambos.',
          ),
          const _FaqItem(
            question: 'E se a troca não funcionar como esperado?',
            answer:
                'Você pode conversar com seu parceiro para ajustar a troca ou encerrá-la respeitosamente. Use o sistema de avaliação para compartilhar sua experiência e ajudar a comunidade.',
          ),
          const SizedBox(height: 32),

          // Footer
          const Center(
            child: Text(
              '© 2025 Laços. Todos os direitos reservados.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF007bff),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF007bff),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(
                    child: Text(item, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF007bff), width: 1.5),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.question,
                style: const TextStyle(
                  color: Color(0xFF007bff),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.answer,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
