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

    // Modal Login
    const loginModal = document.getElementById('loginModal');
    const openLoginModal = document.getElementById('openLoginModal');
    const closeLoginModal = document.getElementById('closeLoginModal');
    const loginForm = document.getElementById('loginForm');

    if (openLoginModal && loginModal && closeLoginModal && loginForm) {
        openLoginModal.addEventListener('click', (e) => {
            e.preventDefault();
            loginModal.classList.remove('hidden');
            loginModal.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';
            const modalEmail = document.getElementById('modal-email');
            if (modalEmail) modalEmail.focus();
        });

        closeLoginModal.addEventListener('click', () => {
            loginModal.classList.add('hidden');
            loginModal.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';
            loginForm.reset();
            clearErrors();
        });

        window.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && !loginModal.classList.contains('hidden')) {
                loginModal.classList.add('hidden');
                loginModal.setAttribute('aria-hidden', 'true');
                document.body.style.overflow = '';
                loginForm.reset();
                clearErrors();
            }
        });

        loginModal.addEventListener('click', (e) => {
            if (e.target === loginModal) {
                loginModal.classList.add('hidden');
                loginModal.setAttribute('aria-hidden', 'true');
                document.body.style.overflow = '';
                loginForm.reset();
                clearErrors();
            }
        });

        function clearErrors() {
            document.querySelectorAll('.error').forEach(error => error.classList.add('hidden'));
        }

        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const email = document.getElementById('modal-email').value.trim();
            const password = document.getElementById('modal-password').value;
            let valid = true;

            clearErrors();

            if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                document.getElementById('email-error').classList.remove('hidden');
                valid = false;
            }
            if (!password || password.length < 8) {
                document.getElementById('password-error').classList.remove('hidden');
                valid = false;
            }

            if (valid) {
                loginModal.classList.add('hidden');
                loginModal.setAttribute('aria-hidden', 'true');
                document.body.style.overflow = '';
                loginForm.reset();
                showNotification('Login realizado com sucesso!');
            }
        });
    }

    // Create Community Form
    const createCommunityForm = document.getElementById('createCommunityForm');
    if (createCommunityForm) {
        createCommunityForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const name = document.getElementById('community-name').value.trim();
            const description = document.getElementById('community-description').value.trim();
            let valid = true;

            document.querySelectorAll('.error').forEach(error => error.classList.add('hidden'));

            if (!name || name.length < 3) {
                document.getElementById('name-error').classList.remove('hidden');
                valid = false;
            }
            if (!description || description.length < 10) {
                document.getElementById('description-error').classList.remove('hidden');
                valid = false;
            }

            if (valid) {
                showNotification(`Comunidade "${name}" criada com sucesso!`);
                createCommunityForm.reset();
            }
        });
    }
});