# Descrição do Projeto

Nesta atividade 3, foi utilizado o Docker para criar um banco de dados PostgreSQL na versão 15. Para iniciar o banco de dados, é necessário ter o Docker e o Docker Compose instalados.

## Visão Geral

Após o container ser iniciado e o banco de dados estar disponível, são executados outros scripts necessários para criar as tabelas, popular os dados e refatorar as tabelas, com o objetivo de garantir que os dados fiquem melhor estruturados.

**Obs:** O arquivo com a resposta da questão 3.5 está localizado na raiz do projeto e o nome do arquivo é `3.5.respostas.sql`.

## Como Rodar o Projeto

1. **Criação do diretório para o projeto:**
   Crie uma pasta onde o banco de dados será executado via Docker:
   ```bash
   mkdir project_bd
   ```

2. **Acessar o diretório criado:**
   Entre na pasta `project_bd`:
   ```bash
   cd project_bd
   ```

3. **Clonar o repositório do projeto:**
   Agora, clone o repositório:
   ```bash
   git clone https://github.com/norberto-jn/intuitive-bd.git
   ```

4. **Acessar a pasta do projeto clonado:**
   Entre na pasta `intuitive-bd`:
   ```bash
   cd intuitive-bd
   ```

5. **Rodar o Docker Compose:**
   Agora, dentro da pasta `intuitive-bd`, execute o comando:
   ```bash
   docker compose up -d
   ```

6. **Verificar se o projeto está rodando:**
   Após o Docker Compose subir os containers, você pode verificar o status do projeto com:
   ```bash
   docker compose ps
   ```

7. **Conectar ao banco de dados PostgreSQL:**
   Após verificar que o container esteja rodando, basta escolher um administrador de banco de dados da sua preferência para se conectar ao banco de dados. Como sugestão, indico o DBeaver.

   Dados de conexão:

   - **URL:** jdbc:postgresql://localhost:5422/postgres
   - **Host:** localhost
   - **Porta:** 5422
   - **Banco de dados:** postgres
   - **Usuário:** postgres
   - **Senha:** postgres
   - **Schema:** intuitivecare