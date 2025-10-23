# Sistema WMS - Warehouse Management System

## Visão Geral
Sistema de gerenciamento de armazém (WMS) com backend em FastAPI e frontend em Express/HTML estático.

## Estrutura do Projeto

### Backend (SGA-Backend)
- **Framework**: FastAPI (Python 3.11)
- **Banco de Dados**: PostgreSQL (com asyncpg)
- **Autenticação**: JWT (JSON Web Tokens)
- **ORM**: SQLAlchemy 2.0 (async)
- **Porta**: 8000 (0.0.0.0 - acessível externamente)

### Frontend (SGA-Frontend)
- **Framework**: Express.js (Node.js 20)
- **Porta**: 5000 (0.0.0.0)
- **Arquivos estáticos**: HTML, CSS, JavaScript

## Configuração

### Variáveis de Ambiente (.env no SGA-Backend)
```
DATABASE_URL=postgresql+asyncpg://usuario:senha@host/database
SECRET_KEY=sua_chave_secreta_jwt
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

## Sistema de Autenticação Implementado

### 🔐 Login Profissional com JWT

#### Endpoint: POST /login
**Request**:
```json
{
  "email": "usuario@exemplo.com",
  "senha": "senha123"
}
```

**Response** (Success):
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "bearer",
  "tipo_usuario": "professor",  // ou "usuario"
  "email": "usuario@exemplo.com"
}
```

**Funcionamento**:
1. Verifica primeiro na tabela `DimProfessor`
2. Se não encontrar, verifica na tabela `DimUsuario`
3. Valida senha com hash bcrypt
4. Retorna JWT com diferenciação automática do tipo de usuário

### 👨‍🏫 Criar Usuário (Apenas Professores)

#### Endpoint: POST /usuarios
**Autenticação**: Requer JWT de Professor

**Headers**:
```
Authorization: Bearer <JWT_TOKEN>
```

**Request**:
```json
{
  "nome": "João Silva",
  "email": "joao@example.com",
  "senha": "senha123",
  "datanasc": "1990-01-15",
  "dataentrada": "2025-01-01"
}
```

**Response**:
```json
{
  "idusuario": 1,
  "nome": "João Silva",
  "email": "joao@example.com",
  "datanasc": "1990-01-15",
  "dataentrada": "2025-01-01",
  "inserido_por": "professor@exemplo.com"
}
```

**Regras**:
- Apenas usuários com tipo "professor" podem criar novos usuários
- O campo `inserido_por` é preenchido automaticamente com o email do professor logado
- Senha é armazenada com hash bcrypt

## Modelos do Banco de Dados

### DimUsuario
- `idusuario` (PK)
- `email` (unique)
- `nome`
- `senha` (bcrypt hash)
- `datanasc`
- `dataentrada`
- `inserido_por` (email do professor que criou)

### DimProfessor
- `sn` (PK)
- `nome`
- `email` (unique)
- `senha` (bcrypt hash)

## Arquitetura de Segurança

### Arquivos Principais:
- `app/core/security.py`: Funções JWT e autenticação
  - `create_access_token()`: Cria token JWT
  - `verify_password()`: Verifica senha com bcrypt
  - `get_password_hash()`: Gera hash de senha
  - `get_current_user()`: Middleware para obter usuário logado
  - `get_current_professor()`: Middleware que valida se usuário é professor

- `app/routers/auth.py`: Rotas de autenticação
  - `POST /login`: Login com diferenciação Professor/Usuário
  - `POST /usuarios`: Criar usuário (protegido, apenas professores)

- `app/schemas/auth.py`: Schemas Pydantic
  - `LoginRequest`: Validação de login
  - `LoginResponse`: Retorno com JWT
  - `CreateUserRequest`: Validação criação de usuário
  - `UserResponse`: Retorno de dados do usuário

## Como Testar

### 1. Login
```bash
curl -X POST http://localhost:8000/login \
  -H "Content-Type: application/json" \
  -d '{"email":"professor@exemplo.com","senha":"senha123"}'
```

### 2. Criar Usuário (com JWT)
```bash
curl -X POST http://localhost:8000/usuarios \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer SEU_JWT_TOKEN_AQUI" \
  -d '{
    "nome":"Novo Usuario",
    "email":"novo@exemplo.com",
    "senha":"senha123",
    "datanasc":"1995-05-20",
    "dataentrada":"2025-01-15"
  }'
```

## Alterações Recentes (Outubro 2025)

### Backend - Implementado:
✅ Sistema de autenticação JWT profissional
✅ Diferenciação automática entre Professor e Usuário
✅ Rota protegida para criação de usuários
✅ Campo `inserido_por` no modelo DimUsuario
✅ Hash de senhas com bcrypt
✅ Middleware de autorização para professores
✅ Schemas atualizados com validação de email

### Configuração do Ambiente:
✅ Suporte para PostgreSQL com asyncpg
✅ Conversão automática de DATABASE_URL do Replit
✅ Workflows configurados (Frontend porta 5000, Backend porta 8000)
✅ Dependências instaladas (python-jose, python-multipart, email-validator)
✅ Backend exposto em 0.0.0.0:8000 para acesso externo
✅ Frontend integrado com backend usando URL dinâmica

### Frontend - Correções Implementadas:
✅ Arquivo `js/config.js` criado com URL dinâmica da API
✅ Página de login (`index.html`) atualizada para usar a configuração centralizada
✅ Parsing da resposta JWT corrigido (access_token, tipo_usuario, email)
✅ Token JWT armazenado no localStorage para uso em outras requisições

## Próximos Passos Sugeridos

1. **Configurar DATABASE_URL** no .env com credenciais reais do banco
2. **Popular banco** com professores e usuários iniciais
3. **Integrar frontend** com as novas rotas de autenticação
4. **Adicionar refresh tokens** para sessões longas
5. **Implementar testes** unitários e de integração
6. **Configurar HTTPS** em produção
7. **Adicionar rate limiting** para proteger contra ataques

## Documentação da API

Acesse http://localhost:8000/docs para ver a documentação interativa do Swagger.
