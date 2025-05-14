const filter = document.getElementById('category-filter');
const search = document.getElementById('search');
const highlights = document.querySelectorAll('.highlight');

filter.addEventListener('change', updateFilter);
search.addEventListener('input', updateFilter);

function updateFilter() {
    const category = filter.value;
    const query = search.value.toLowerCase();
    highlights.forEach(highlight => {
        const title = highlight.querySelector('h2').textContent.toLowerCase();
        const isCategoryMatch = !category || title.includes(category);
        const isSearchMatch = !query || title.includes(query);
        highlight.style.display = isCategoryMatch && isSearchMatch ? 'block' : 'none';
    });
}

// Alternador de Tema (Modo Claro/Escuro)
document.getElementById('theme-toggle').addEventListener('click', () => {
    document.body.classList.toggle('dark');
    localStorage.setItem('theme', document.body.classList.contains('dark') ? 'dark' : 'light');
});

// Aplicar o tema salvo no localStorage
if (localStorage.getItem('theme') === 'dark') {
    document.body.classList.add('dark');
}