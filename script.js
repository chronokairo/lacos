document.addEventListener('DOMContentLoaded', () => {
    // Real-Time Clock and Date
    function updateTime() {
        const now = new Date();
        const timeOptions = { hour: '2-digit', minute: '2-digit', hour12: false, timeZone: 'America/Sao_Paulo' };
        const dateOptions = { weekday: 'long', day: '2-digit', month: '2-digit', year: 'numeric' };
        const timeDisplay = document.getElementById('timeDisplay');
        const currentDate = document.getElementById('currentDate');
        if (timeDisplay) {
            timeDisplay.textContent = now.toLocaleTimeString('pt-BR', timeOptions);
        }
        if (currentDate) {
            currentDate.textContent = now.toLocaleDateString('pt-BR', dateOptions);
        }
    }
    setInterval(updateTime, 1000);
    updateTime();

    // Highlight Active Nav Link
    const navLinks = document.querySelectorAll('.main-nav .nav-link');
    navLinks.forEach(link => {
        if (link.href === window.location.href) {
            link.classList.add('active');
        }
        link.addEventListener('click', () => {
            navLinks.forEach(l => l.classList.remove('active'));
            link.classList.add('active');
        });
    });

    // Toggle Comments with Event Delegation
    document.getElementById('postContainer')?.addEventListener('click', (e) => {
        if (e.target.classList.contains('comment-toggle')) {
            const section = e.target.nextElementSibling;
            section.classList.toggle('hidden');
            e.target.textContent = section.classList.contains('hidden')
                ? `Comentários (${section.children.length})`
                : 'Ocultar Comentários';
            e.target.setAttribute('aria-expanded', !section.classList.contains('hidden'));
        }
    });

    // Dynamic Upvotes with Local Storage
    document.getElementById('postContainer')?.addEventListener('click', (e) => {
        if (e.target.closest('.upvote-btn')) {
            const button = e.target.closest('.upvote-btn');
            const voteSpan = button.querySelector('span');
            let votes = parseInt(voteSpan.dataset.votes) || parseInt(voteSpan.textContent);
            votes++;
            voteSpan.textContent = votes;
            voteSpan.dataset.votes = votes;
            button.classList.add('active');
            const postTitle = button.closest('.post').querySelector('.post-title').textContent;
            localStorage.setItem(`votes_${postTitle}`, votes);
        }
    });

    // Load Saved Votes
    document.querySelectorAll('.upvote-btn').forEach(button => {
        const voteSpan = button.querySelector('span');
        const postTitle = button.closest('.post')?.querySelector('.post-title')?.textContent;
        if (postTitle) {
            const savedVotes = localStorage.getItem(`votes_${postTitle}`);
            if (savedVotes) {
                voteSpan.textContent = savedVotes;
                voteSpan.dataset.votes = savedVotes;
                button.classList.add('active');
            }
        }
    });

    // Notification System
    function showNotification(message) {
        const notification = document.getElementById('notification');
        if (notification) {
            notification.querySelector('p').textContent = message;
            notification.classList.remove('hidden');
            setTimeout(() => notification.classList.add('hidden'), 5000);
        }
    }
    setTimeout(() =>
        showNotification('Bem-vindo à Comunidade Laços! Explore as trocas de habilidades.'), 2000
    );

    // Elementos do DOM
    const loginModal = document.getElementById('loginModal');
    const openLoginModal = document.getElementById('openLoginModal');
    const closeLoginModal = document.getElementById('closeLoginModal');
    const loginForm = document.getElementById('loginForm');
    const notification = document.getElementById('notification');
    const carouselPrev = document.querySelector('.carousel-prev');
    const carouselNext = document.querySelector('.carousel-next');
    const eventsCarousel = document.querySelector('.events-carousel');

    // Login Modal
    function toggleModal(show = true) {
        loginModal.classList.toggle('hidden', !show);
        loginModal.setAttribute('aria-hidden', (!show).toString());
    }

    openLoginModal?.addEventListener('click', () => toggleModal(true));
    closeLoginModal?.addEventListener('click', () => toggleModal(false));

    // Fechar modal quando clicar fora
    loginModal?.addEventListener('click', (e) => {
        if (e.target === loginModal) {
            toggleModal(false);
        }
    });

    // Login Form
    loginForm?.addEventListener('submit', (e) => {
        e.preventDefault();
        const email = document.getElementById('modal-email').value;
        const password = document.getElementById('modal-password').value;

        if (!validateEmail(email)) {
            showError('email-error', 'Por favor, insira um e-mail válido.');
            return;
        }

        if (password.length < 8) {
            showError('password-error', 'A senha deve ter pelo menos 8 caracteres.');
            return;
        }

        // Simulação de login
        showNotification('Login realizado com sucesso!');
        toggleModal(false);
    });

    // Carousel de Eventos
    let currentSlide = 0;

    function updateCarousel() {
        if (eventsCarousel) {
            const cards = eventsCarousel.querySelectorAll('.event-card');
            cards.forEach((card, index) => {
                card.style.transform = `translateX(${(index - currentSlide) * 100}%)`;
            });
        }
    }

    carouselPrev?.addEventListener('click', () => {
        const cards = eventsCarousel?.querySelectorAll('.event-card');
        if (cards && currentSlide > 0) {
            currentSlide--;
            updateCarousel();
        }
    });

    carouselNext?.addEventListener('click', () => {
        const cards = eventsCarousel?.querySelectorAll('.event-card');
        if (cards && currentSlide < cards.length - 1) {
            currentSlide++;
            updateCarousel();
        }
    });

    // Funções Utilitárias
    function validateEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    function showError(elementId, message) {
        const errorElement = document.getElementById(elementId);
        if (errorElement) {
            errorElement.textContent = message;
            errorElement.classList.remove('hidden');
        }
    }

    function showNotification(message, type = 'success') {
        const notificationElement = document.getElementById('notification');
        if (notificationElement) {
            notificationElement.querySelector('p').textContent = message;
            notificationElement.className = `notification ${type}`;
            notificationElement.classList.remove('hidden');

            setTimeout(() => {
                notificationElement.classList.add('hidden');
            }, 3000);
        }
    }

    // Inicialização
    document.addEventListener('DOMContentLoaded', () => {
        updateCarousel();
    });
});