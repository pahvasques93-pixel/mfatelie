# MF Ateliê Gestão

Sistema simples de gestão para o MF Ateliê: vendas (entradas), despesas (saídas), produtos, estoque, materiais e precificação saudável.

É uma página estática (`index.html`), sem instalação e sem servidor próprio. O banco de dados é opcional (Supabase).

## Como publicar no GitHub Pages

1. Crie um repositório no GitHub (este: `mfatelie`).
2. Envie os arquivos desta pasta (`index.html`, `config.js`, `supabase.sql` e `README.md`) para a raiz do repositório.
3. No repositório, abra **Settings → Pages**.
4. Em **Build and deployment**, escolha **Deploy from a branch**, branch `main`, pasta `/ (root)`, e salve.
5. Em um ou dois minutos o sistema estará em `https://pahvasques93-pixel.github.io/mfatelie/`.

Pelo terminal:

```bash
git init
git add .
git commit -m "MF Ateliê Gestão"
git branch -M main
git remote add origin https://github.com/pahvasques93-pixel/mfatelie.git
git push -u origin main
```

## Onde ficam os dados

O sistema funciona de dois jeitos, definidos pelo arquivo `config.js`:

- **Sem conta** (campos vazios em `config.js`): os dados ficam só no navegador de quem usa. Em **Ajustes → Cópia de segurança** dá para baixar e restaurar um arquivo.
- **Com Supabase** (campos preenchidos): o sistema pede e-mail e senha, e os dados ficam na conta. Aparecem iguais no celular e no computador.

## Como ligar o Supabase

1. Crie uma conta e um projeto em https://supabase.com (o plano gratuito basta).
2. No projeto, abra **SQL Editor → New query**, cole o conteúdo de `supabase.sql` e clique em **Run**. Isso cria a tabela `mf_registros` e as regras que fazem cada conta enxergar só os próprios dados.
3. Abra **Project Settings → API** e copie a **Project URL** e a chave **anon public**.
4. Cole as duas em `config.js`:

   ```js
   window.MF_SUPABASE = {
     url: "https://SEU-PROJETO.supabase.co",
     anonKey: "SUA-CHAVE-ANON"
   };
   ```

   A chave `anon` pode ficar no GitHub: ela é pública por natureza e as regras do passo 2 protegem os dados. **Nunca** use a chave `service_role` aqui.
5. Em **Authentication → URL Configuration**, coloque o endereço do GitHub Pages em **Site URL**, para o link do e-mail de confirmação voltar ao sistema.
6. Abra o sistema, clique em **Criar conta**, confirme pelo e-mail recebido e entre.
7. Depois de criar a conta do ateliê, desligue novos cadastros em **Authentication → Sign In / Providers** ("Allow new users to sign up"), para ninguém mais criar conta no projeto.

Se já havia lançamentos guardados no navegador, o sistema oferece enviá-los para a conta no primeiro acesso.

Observações:

- Projetos gratuitos do Supabase são pausados depois de cerca de uma semana sem uso; basta reativar no painel.
- Com duas abas ou aparelhos abertos ao mesmo tempo, cada um atualiza os dados ao voltar para a aba.

## Como o preço sugerido é calculado

```
valor da hora     = pró-labore desejado ÷ horas de trabalho no mês
custo fixo/hora   = custos fixos do mês ÷ horas de trabalho no mês
custo da peça     = materiais + tempo × (valor da hora + custo fixo/hora)
preço mínimo      = custo da peça ÷ (1 − taxa de pagamento)
preço sugerido    = custo da peça ÷ (1 − taxa de pagamento − margem de lucro)
```

- **Saudável**: o preço cobrado é igual ou maior que o sugerido.
- **Abaixo do ideal**: cobre os custos e a sua hora, mas não a margem.
- **Prejuízo**: está abaixo do preço mínimo.
