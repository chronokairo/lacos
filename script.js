document.addEventListener('DOMContentLoaded', () => {
    console.log('script.js carregado com sucesso');

    // Botão CTA
    const ctaButton = document.querySelector('.cta-button');
    if (ctaButton) {
        ctaButton.addEventListener('click', () => {
            alert('Junte-se ao SkillSwap! Comece a trocar suas habilidades e faça parte da nossa comunidade colaborativa.');
        });
    } else {
        console.error('Botão CTA (.cta-button) não encontrado');
    }

    // Botão Perfil
    const perfilButton = document.querySelector('.perfil-button');
    if (perfilButton) {
        perfilButton.addEventListener('click', () => {
            alert('Perfil de Amanda Costa\nHabilidades: Montagem de móveis, Aulas de violão\nAvaliação: ⭐ 4.9 (32 avaliações)\nEntre em contato para trocar habilidades!');
        });
    } else {
        console.error('Botão Perfil (.perfil-button) não encontrado');
    }

    // Navegação por abas
    const navLinks = document.querySelectorAll('.nav-link');
    const tabPanes = document.querySelectorAll('.tab-pane');

    if (navLinks.length === 0) {
        console.error('Nenhum link de navegação (.nav-link) encontrado');
        return;
    }

    if (tabPanes.length === 0) {
        console.error('Nenhum painel de aba (.tab-pane) encontrado');
        return;
    }

    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            console.log(`Clicado na aba: ${link.getAttribute('data-tab')}`);

            // Remove active de todos os links e painéis
            navLinks.forEach(l => l.classList.remove('active'));
            tabPanes.forEach(pane => pane.classList.remove('active'));

            // Adiciona active ao link clicado e painel correspondente
            link.classList.add('active');
            const tabId = link.getAttribute('data-tab');
            const targetPane = document.getElementById(tabId);
            if (targetPane) {
                targetPane.classList.add('active');
            } else {
                console.error(`Painel com id ${tabId} não encontrado`);
            }
        });
    });

    // Inicializa a primeira aba
    const firstLink = document.querySelector('.nav-link[data-tab="o-que-e"]');
    const firstPane = document.getElementById('o-que-e');
    if (firstLink && firstPane) {
        firstLink.classList.add('active');
        firstPane.classList.add('active');
    } else {
        console.error('Erro ao inicializar a primeira aba');
    }
});