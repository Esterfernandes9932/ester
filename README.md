# LogTrain — Deploy no GitHub Pages + Supabase

## Estrutura de arquivos

```
logtrain/
├── index.html        ← App principal
├── manifest.json     ← Config do PWA
├── sw.js             ← Service Worker (offline)
├── icon-192.png      ← Ícone 192×192
├── icon-512.png      ← Ícone 512×512
└── supabase_schema.sql ← SQL para rodar no Supabase
```

---

## PASSO 1 — Criar o projeto no Supabase

1. Acesse **[supabase.com](https://supabase.com)** → Entrar com GitHub
2. Clique em **New Project**
3. Dê um nome (ex.: `logtrain`) e defina uma senha
4. Escolha a região mais próxima (ex.: São Paulo - sa-east-1)
5. Aguarde a criação (~2 min)

### Configurar o banco

1. No menu esquerdo clique em **SQL Editor**
2. Clique em **New query**
3. Cole todo o conteúdo do arquivo `supabase_schema.sql`
4. Clique em **Run** (▶)

### Pegar as credenciais

1. No menu esquerdo: **Settings → API**
2. Copie:
   - **Project URL** (ex.: `https://abcdefgh.supabase.co`)
   - **anon public** key (chave longa)

### Colocar as credenciais no app

Abra o `index.html` e encontre estas linhas (perto do início do JavaScript):

```js
const SUPABASE_URL = 'https://SEU_PROJETO.supabase.co';
const SUPABASE_KEY = 'SUA_ANON_KEY';
```

Substitua pelos valores copiados.

---

## PASSO 2 — Publicar no GitHub Pages

### Criar o repositório

1. Acesse **[github.com](https://github.com)** → Login
2. Clique em **+** → **New repository**
3. Nome: `logtrain` (ou o nome que preferir)
4. Marque como **Public**
5. Clique em **Create repository**

### Fazer upload dos arquivos

**Opção A — Pelo site (mais fácil):**

1. Na página do repositório recém-criado, clique em **uploading an existing file**
2. Arraste todos os 5 arquivos de uma vez:
   - `index.html`
   - `manifest.json`
   - `sw.js`
   - `icon-192.png`
   - `icon-512.png`
3. Na caixa "Commit changes" clique em **Commit changes**

**Opção B — Pelo terminal:**

```bash
cd pasta-dos-arquivos
git init
git add .
git commit -m "LogTrain v1"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/logtrain.git
git push -u origin main
```

### Ativar o GitHub Pages

1. No repositório, clique em **Settings**
2. No menu esquerdo: **Pages**
3. Em "Source": selecione **Deploy from a branch**
4. Branch: **main** / Folder: **/ (root)**
5. Clique em **Save**
6. Aguarde ~1 minuto
7. A URL aparecerá: `https://SEU_USUARIO.github.io/logtrain/`

---

## PASSO 3 — Instalar como app no celular

### Android (Chrome)

1. Abra a URL no Chrome
2. Toque no menu **⋮** (três pontos)
3. Toque em **"Adicionar à tela inicial"**
4. Confirme → O ícone do LogTrain aparece como um app

### iPhone/iPad (Safari)

1. Abra a URL no **Safari** (obrigatório — não funciona no Chrome do iOS)
2. Toque no botão **Compartilhar** (quadrado com seta para cima)
3. Toque em **"Adicionar à Tela de Início"**
4. Confirme → O ícone aparece como app

---

## Atualizações futuras

Para atualizar o app após mudanças:

1. Edite os arquivos necessários
2. Faça upload do(s) arquivo(s) alterado(s) no GitHub
3. O GitHub Pages atualiza automaticamente em ~1 min
4. No celular, abra o app → ele baixa a versão nova automaticamente

---

## Notas importantes

- **Supabase free tier**: 500MB de banco + 1GB de transferência/mês — mais que suficiente para uso familiar
- **GitHub Pages**: gratuito e ilimitado para repositórios públicos
- Os dados ficam salvos em 3 lugares: localStorage, IndexedDB e Supabase — máxima segurança contra perda
- Funciona **offline**: se não tiver internet, o app usa o cache local e sincroniza quando voltar a conectar
