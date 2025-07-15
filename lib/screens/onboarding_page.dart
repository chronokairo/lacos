import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_OnboardingStep> steps = [
      _OnboardingStep(
        title: 'Bem-vindo ao Laços',
        description:
            'Conecte-se, aprenda e compartilhe habilidades de forma colaborativa.',
        imageUrl:
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1350&q=80',
      ),
      _OnboardingStep(
        title: 'Funciona Offline',
        description:
            'Acesse e utilize o app mesmo sem internet. Seus dados ficam salvos localmente.',
        imageUrl:
            'https://images.unsplash.com/photo-1511632765486-a01980e01a18?auto=format&fit=crop&w=1920&q=80',
      ),
      _OnboardingStep(
        title: 'Eventos e Mercado',
        description:
            'Busque eventos, troque habilidades e encontre oportunidades.',
        imageUrl:
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1350&q=80',
      ),
    ];

    final pageController = PageController();
    int currentPage = 0;
    return Scaffold(
      body: StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              PageView.builder(
                controller: pageController,
                itemCount: steps.length,
                onPageChanged: (i) => setState(() => currentPage = i),
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(step.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              step.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              step.description,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentPage > 0)
                      ElevatedButton(
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text('Voltar'),
                      )
                    else
                      const SizedBox(width: 80),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/main');
                      },
                      child: const Text(
                        'Pular',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (currentPage < steps.length - 1)
                      ElevatedButton(
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text('Avançar'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/main');
                        },
                        child: const Text('Começar'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OnboardingStep {
  final String title;
  final String description;
  final String imageUrl;

  _OnboardingStep({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
