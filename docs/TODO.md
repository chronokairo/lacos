

# TODO - Projeto Lacos (Offline)

## ✅ Concluídos

### ✅ **Funcionalidades Básicas Implementadas (Dezembro 2024)**
- [x] Sistema de autenticação (login/cadastro) com validação básica
- [x] Navegação entre páginas com drawer menu
- [x] Sistema básico de gerenciamento de habilidades (CRUD)
- [x] Sistema básico de eventos (adicionar, visualizar)
- [x] Página de mercado com filtros básicos
- [x] Página de comunidade com formulários
- [x] Persistência básica em memória (LocalDataService)
- [x] Otimização de imagens com CachedNetworkImage
- [x] Estados de loading básicos em formulários
- [x] Validação básica de formulários (campos obrigatórios)
- [x] Tema personalizado e design consistente
- [x] Página "Como Funciona" com conteúdo informativo

### ✅ **Estrutura e Organização**
- [x] Estrutura básica de pastas e arquivos
- [x] Modelos de dados (Usuario, Evento, Habilidade)
- [x] Serviço básico de dados locais
- [x] Widget drawer para navegação
- [x] Temas e estilos básicos aplicados

## Em andamento
<!-- Adicione aqui itens que estão em desenvolvimento -->

## A fazer

### 🔒 **URGENTE - Segurança (Crítico)**
- [ ] Implementar hash de senhas (bcrypt) - **CRÍTICO - senhas em texto plano**
- [ ] Remover credenciais hardcoded do repositório (usuarios.json)
- [ ] Adicionar sanitização e validação de inputs
- [ ] Implementar autenticação segura baseada em tokens
- [ ] Adicionar rate limiting e validação de sessão
- [ ] Implementar HTTPS e headers seguros

### ⚠️ **Alta Prioridade**
- [ ] Implementar tratamento abrangente de erros (try-catch, error boundaries)
- [ ] Adicionar validação robusta de formulários (regex email, senha forte)
- [ ] Implementar gerenciamento de estado adequado (Provider/Riverpod/Bloc)
- [ ] Adicionar persistência local de dados (SQLite/Hive)
- [ ] Criar sistema de testes abrangente (widget, integration, unit)
- [ ] Adicionar estados de loading para todas operações async
- [ ] Implementar diálogos de confirmação para ações destrutivas

### 🎨 **Experiência do Usuário**
- [ ] Padronizar componentes UI (design system)
- [ ] Adicionar funcionalidade de busca em todas as páginas
- [ ] Implementar paginação para listas grandes
- [ ] Adicionar pull-to-refresh e scroll infinito
- [ ] Criar indicadores de status offline/online
- [ ] Melhorar navegação e fluxos do usuário
- [ ] Adicionar animações e transições suaves

### 🚀 **Funcionalidades Principais Faltantes**
- [ ] Sistema real de matching/troca de habilidades
- [ ] Sistema de mensagens/chat in-app
- [ ] Perfis completos de usuário com fotos
- [ ] Sistema de avaliações e reviews
- [ ] Sistema de notificações push
- [ ] Algoritmo de recomendação de habilidades
- [ ] Configurações e preferências do usuário

### ⚡ **Performance**
- [ ] Otimizar carregamento de imagens (lazy loading)
- [ ] Implementar caching adequado para dados
- [ ] Adicionar construtores const onde possível
- [ ] Otimizar rebuilds desnecessários de widgets
- [ ] Implementar lazy loading para datasets grandes
- [ ] Usar ListView.builder com otimizações adequadas

### ♿ **Acessibilidade**
- [ ] Adicionar labels semânticos para screen readers
- [ ] Implementar navegação por teclado
- [ ] Garantir contraste de cores WCAG 2.1 AA
- [ ] Adicionar indicadores de foco
- [ ] Testar com ferramentas de acessibilidade
- [ ] Suporte para scaling de texto

### 🏗️ **Arquitetura e Código**
- [ ] Refatorar LocalDataService em serviços específicos
- [ ] Extrair constantes para arquivo dedicado
- [ ] Dividir widgets grandes em componentes menores
- [ ] Implementar documentação e comentários
- [ ] Padronizar convenções de nomenclatura
- [ ] Remover imports não utilizados e código morto
- [ ] Garantir null safety completo

### 🧪 **Testes**
- [ ] Testes de widget para todas as telas
- [ ] Testes de integração para fluxos completos
- [ ] Testes unitários para lógica de negócio
- [ ] Testes de performance
- [ ] Testes de acessibilidade automatizados
- [ ] Testes end-to-end
- [ ] Criar mocks para services em testes

### 📚 **Documentação**
- [ ] Documentação da API
- [ ] Documentação da arquitetura do código
- [ ] Guias de setup e desenvolvimento
- [ ] Manual do usuário/sistema de ajuda
- [ ] Guidelines de contribuição
- [ ] Instruções de deployment

### 🔧 **Infraestrutura**
- [ ] Configurar CI/CD pipeline
- [ ] Implementar code formatting automático
- [ ] Configurar análise estática de código
- [ ] Setup de ambientes (dev, staging, prod)
- [ ] Monitoramento e logging de erros
- [ ] Backup e recuperação de dados

## Melhorias Futuras
- Melhorar a documentação do código, incluindo comentários explicativos e exemplos de uso.
- Implementar testes automatizados para todas as funcionalidades críticas, aumentando a cobertura de testes.
- Refatorar componentes para maior reutilização e modularidade, reduzindo duplicidade de código.
- Adotar um padrão consistente de nomenclatura e organização de arquivos.
- Otimizar o desempenho do backend, especialmente em operações de leitura e escrita de dados.
- Implementar monitoramento de erros e logs detalhados para facilitar a manutenção.
- Melhorar a experiência do usuário com feedbacks visuais e mensagens claras em casos de erro.
- Garantir compatibilidade e responsividade em diferentes navegadores e dispositivos.
- Automatizar processos de build, deploy e integração contínua (CI/CD).
- Revisar e reforçar a segurança, incluindo validação de dados e proteção contra ataques comuns.
- Atualizar dependências e bibliotecas para versões mais recentes, evitando vulnerabilidades.
- Criar um guia de estilo para contribuidores e revisar o guia de contribuição.
- Adicionar suporte a internacionalização (i18n) para facilitar tradução do app.
- Realizar testes de usabilidade com usuários reais para identificar pontos de melhoria na interface.
- Documentar fluxos de dados e arquitetura do sistema para facilitar onboarding de novos desenvolvedores.
