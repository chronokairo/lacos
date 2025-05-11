document.addEventListener('DOMContentLoaded', () => {
    // Botão CTA
    const ctaButton = document.querySelector('.cta-button');
    ctaButton.addEventListener('click', () => {
        alert('Junte-se ao SkillSwap! Comece a trocar suas habilidades e faça parte da nossa comunidade colaborativa.');
    });

    // Botão Perfil
    const perfilButton = document.querySelector('.perfil-button');
    perfilButton.addEventListener('click', () => {
        alert('Perfil de Amanda Costa\nHabilidades: Montagem de móveis, Aulas de violão\nAvaliação: ⭐ 4.9 (32 avaliações)\nEntre em contato para trocar habilidades!');
    });

    // Navegação por abas
    const navLinks = document.querySelectorAll('.nav-link');
    const tabPanes = document.querySelectorAll('.tab-pane');

    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();

            // Remove classe active de todos os links e painéis
            navLinks.forEach(l => l.classList.remove('active'));
            tabPanes.forEach(pane => pane.classList.remove('active'));

            // Adiciona classe active ao link clicado e ao painel correspondente
            link.classList.add('active');
            const tabId = link.getAttribute('data-tab');
            const targetPane = document.getElementById(tabId);
            targetPane.classList.add('active');
        });
    });

    // Inicializa a primeira aba como ativa
    document.querySelector('.nav-link[data-tab="o-que-e"]').classList.add('active');
    document.getElementById('o-que-e').classList.add('active');
});