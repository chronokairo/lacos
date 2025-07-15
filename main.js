const express = require('express');
const session = require('express-session');
const bcrypt = require('bcrypt');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(session({
    secret: 'lacos_secret_key',
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false }
}));
app.use(express.static(__dirname));

const usuariosDir = path.join(__dirname, 'usuario');
const usuariosFile = path.join(usuariosDir, 'usuarios.json');

// Carregar usuários do arquivo JSON
function carregarUsuarios() {
    if (!fs.existsSync(usuariosDir)) fs.mkdirSync(usuariosDir);
    if (!fs.existsSync(usuariosFile)) fs.writeFileSync(usuariosFile, '[]');
    const data = fs.readFileSync(usuariosFile);
    return JSON.parse(data);
}

function salvarUsuarios(usuarios) {
    fs.writeFileSync(usuariosFile, JSON.stringify(usuarios, null, 2));
}

let users = carregarUsuarios();

// Registro
app.post('/register', async (req, res) => {
    const { email, password } = req.body;
    if (users.find(u => u.email === email)) {
        return res.status(400).json({ error: 'Usuário já existe' });
    }
    const hash = await bcrypt.hash(password, 10);
    users.push({ email, password: hash });
    salvarUsuarios(users);
    res.status(201).json({ message: 'Usuário registrado com sucesso' });
});

// Login
app.post('/login', async (req, res) => {
    const { email, password } = req.body;
    const user = users.find(u => u.email === email);
    if (!user) {
        return res.status(400).json({ error: 'Usuário não encontrado' });
    }
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) {
        return res.status(401).json({ error: 'Senha incorreta' });
    }
    req.session.user = user.email;
    res.json({ message: 'Login realizado com sucesso' });
});

// Logout
app.post('/logout', (req, res) => {
    req.session.destroy();
    res.json({ message: 'Logout realizado com sucesso' });
});

// Rota protegida de exemplo
app.get('/profile', (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ error: 'Não autenticado' });
    }
    res.json({ email: req.session.user });
});

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
});

