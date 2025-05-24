document.addEventListener('DOMContentLoaded', () => {
    // Constantes
    const CAROUSEL_INTERVAL = 5000;
    const MIN_PASSWORD_LENGTH = 8;
    
    // Elements
    const elements = {
        sidebar: document.getElementById('sidebar'),
        toggleSidebar: document.getElementById('toggleSidebar'),
        loginModal: document.getElementById('loginModal'),
        loginForm: document.getElementById('loginForm'),
        emailInput: document.getElementById('modal-email'),
        passwordInput: document.getElementById('modal-password'),
        carousel: document.getElementById('eventsCarousel'),
        notification: document.getElementById('notification')
    };

    // Mobile Menu
    const initializeMobileMenu = () => {
        const toggleMenu = () => {
            elements.sidebar.classList.toggle('-translate-x-full');
            document.body.classList.toggle('overflow-hidden');
        };

        elements.toggleSidebar.addEventListener('click', toggleMenu);

        // Fecha menu ao clicar fora
        document.addEventListener('click', (e) => {
            if (window.innerWidth < 1024 && 
                !elements.sidebar.contains(e.target) && 
                !elements.toggleSidebar.contains(e.target)) {
                elements.sidebar.classList.add('-translate-x-full');
                document.body.classList.remove('overflow-hidden');
            }
        });
    };

    // Modal Handling
    const initializeModal = () => {
        const openModal = () => {
            elements.loginModal.classList.remove('hidden');
            elements.emailInput.focus();
            document.body.classList.add('overflow-hidden');
        };

        const closeModal = () => {
            elements.loginModal.classList.add('hidden');
            document.body.classList.remove('overflow-hidden');
        };

        document.getElementById('openLoginModal').addEventListener('click', openModal);
        document.getElementById('closeLoginModal').addEventListener('click', closeModal);
        
        // Fecha modal com ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') closeModal();
        });

        // Fecha modal ao clicar fora
        elements.loginModal.addEventListener('click', (e) => {
            if (e.target === elements.loginModal) closeModal();
        });
    };

    // Form Validation
    const initializeFormValidation = () => {
        const validateEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        
        const updateValidation = () => {
            const email = elements.emailInput.value.trim();
            const password = elements.passwordInput.value;
            
            const isEmailValid = validateEmail(email);
            const isPasswordValid = password.length >= MIN_PASSWORD_LENGTH;
            
            elements.emailInput.classList.toggle('border-red-500', !isEmailValid);
            elements.passwordInput.classList.toggle('border-red-500', !isPasswordValid);
            
            const submitBtn = elements.loginForm.querySelector('button[type="submit"]');
            submitBtn.disabled = !(isEmailValid && isPasswordValid);
        };

        elements.loginForm.addEventListener('input', updateValidation);
        elements.loginForm.addEventListener('submit', handleSubmit);
    };

    // Carousel
    const initializeCarousel = () => {
        let currentSlide = 0;
        const slides = elements.carousel.children;
        
        const updateCarousel = () => {
            const cardWidth = slides[0].offsetWidth + 24;
            elements.carousel.scrollTo({
                left: currentSlide * cardWidth,
                behavior: 'smooth'
            });
        };

        const nextSlide = () => {
            currentSlide = (currentSlide + 1) % slides.length;
            updateCarousel();
        };

        const prevSlide = () => {
            currentSlide = (currentSlide - 1 + slides.length) % slides.length;
            updateCarousel();
        };

        // Controls
        document.querySelector('.carousel-next').addEventListener('click', nextSlide);
        document.querySelector('.carousel-prev').addEventListener('click', prevSlide);

        // Touch support
        let touchStartX = 0;
        elements.carousel.addEventListener('touchstart', e => {
            touchStartX = e.touches[0].clientX;
        }, { passive: true });

        elements.carousel.addEventListener('touchend', e => {
            const touchEndX = e.changedTouches[0].clientX;
            const diff = touchStartX - touchEndX;

            if (Math.abs(diff) > 50) {
                if (diff > 0) nextSlide();
                else prevSlide();
            }
        }, { passive: true });

        // Auto-scroll
        let interval = setInterval(nextSlide, CAROUSEL_INTERVAL);
        
        elements.carousel.addEventListener('mouseenter', () => clearInterval(interval));
        elements.carousel.addEventListener('mouseleave', () => {
            interval = setInterval(nextSlide, CAROUSEL_INTERVAL);
        });

        // Resize handling
        let resizeTimeout;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(updateCarousel, 100);
        });
    };

    // Initialize
    initializeMobileMenu();
    initializeModal();
    initializeFormValidation();
    initializeCarousel();
});