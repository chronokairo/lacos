
        // Real-Time Clock and Date
        function updateTime() {
            const now = new Date();
            const timeOptions = { hour: '2-digit', minute: '2-digit', hour12: true };
            const dateOptions = { weekday: 'long', day: '2-digit', month: '2-digit', year: 'numeric' };
            const timeDisplay = document.getElementById('timeDisplay');
            const currentDate = document.getElementById('currentDate');
            if (timeDisplay) {
                timeDisplay.textContent = now.toLocaleTimeString('en-US', timeOptions)
                    .replace('PM', 'PM -04').replace('AM', 'AM -04');
            }
            if (currentDate) {
                currentDate.textContent = now.toLocaleDateString('pt-BR', dateOptions)
                    .replace(' de ', '/').replace(' de ', '/');
            }
        }
        setInterval(updateTime, 1000);
        updateTime();

        // Toggle Comments
        document.querySelectorAll('.comment-toggle').forEach(button => {
            button.addEventListener('click', () => {
                const section = button.nextElementSibling;
                section.classList.toggle('hidden');
                button.textContent = section.classList.contains('hidden')
                    ? `Comentários (${section.children.length})`
                    : 'Ocultar Comentários';
                button.setAttribute('aria-expanded', !section.classList.contains('hidden'));
            });
        });

        // Dynamic Upvotes with Local Storage
        document.querySelectorAll('.upvote-btn').forEach(button => {
            const voteSpan = button.querySelector('span');
            let votes = parseInt(voteSpan.dataset.votes) || parseInt(voteSpan.textContent);
            voteSpan.textContent = votes;

            button.addEventListener('click', () => {
                votes++;
                voteSpan.textContent = votes;
                voteSpan.dataset.votes = votes;
                button.classList.add('active');
                const postTitle = voteSpan.parentElement.parentElement.querySelector('.post-title');
                if (postTitle) {
                    localStorage.setItem(`votes_${postTitle.textContent}`, votes);
                }
            });

            const postTitle = voteSpan.parentElement.parentElement.querySelector('.post-title');
            if (postTitle) {
                const savedVotes = localStorage.getItem(`votes_${postTitle.textContent}`);
                if (savedVotes) {
                    voteSpan.textContent = savedVotes;
                    voteSpan.dataset.votes = savedVotes;
                    button.classList.add('active');
                }
            }
        });

        // Custom Feeds and Create Community (Placeholder)
        const customFeedsBtn = document.getElementById('customFeedsBtn');
        if (customFeedsBtn) {
            customFeedsBtn.addEventListener('click', () =>
                alert('Funcionalidade de Custom Feeds em desenvolvimento!')
            );
        }
        const createCommunityBtn = document.getElementById('createCommunityBtn');
        if (createCommunityBtn) {
            createCommunityBtn.addEventListener('click', () =>
                alert('Funcionalidade de Criar Comunidade em desenvolvimento!')
            );
        }

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
            showNotification('Bem-vindo à Comunidade Laços! Explore os tópicos e junte-se às discussões.'), 2000
        );

        // Modal Login
        const loginModal = document.getElementById('loginModal');
        const openLoginModal = document.getElementById('openLoginModal');
        const closeLoginModal = document.getElementById('closeLoginModal');

        if (openLoginModal && loginModal && closeLoginModal) {
            openLoginModal.addEventListener('click', (e) => {
                e.preventDefault();
                loginModal.classList.remove('hidden');
                document.body.style.overflow = 'hidden';
                const modalEmail = document.getElementById('modal-email');
                if (modalEmail) modalEmail.focus();
            });
            closeLoginModal.addEventListener('click', () => {
                loginModal.classList.add('hidden');
                document.body.style.overflow = '';
            });
            window.addEventListener('keydown', (e) => {
                if (e.key === 'Escape') {
                    loginModal.classList.add('hidden');
                    document.body.style.overflow = '';
                }
            });
            loginModal.addEventListener('click', (e) => {
                if (e.target === loginModal) {
                    loginModal.classList.add('hidden');
                    document.body.style.overflow = '';
                }
            });

            // Exemplo de submit (não faz login real)
            const loginForm = document.getElementById('loginForm');
            if (loginForm) {
                loginForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    loginModal.classList.add('hidden');
                    document.body.style.overflow = '';
                    showNotification('Login realizado com sucesso!');
                });
            }
        }