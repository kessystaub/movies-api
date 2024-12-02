# API de Importação de Filmes

Esta API permite a importação de filmes através de um arquivo CSV e oferece endpoints para visualizar e filtrar os filmes importados.

## Instalação e Execução

### Passo 1: Clone o repositório

Use o comando abaixo para clonar o repositório:

```bash
git clone https://github.com/kessystaub/movies-api.git
```

### Passo 2: Instale as dependências

Navegue até o diretório do projeto e execute o seguinte comando para instalar as dependências:

```bash
bundle install
```

### Passo 3: Configure o banco de dados

Crie e migre o banco de dados com os comandos:

```bash
rails db:create db:migrate
```

### Passo 4: Inicie o servidor

Inicie o servidor Rails:

```bash
rails server
```

O servidor estará disponível em http://localhost:3000.

## Endpoints

### 1. Importar filmes

- **Método**: POST  
- **URL**: `http://localhost:3000/movies/import_csv`  
- **Descrição**: Importa filmes para a base de dados a partir de um arquivo CSV.  
- **Requisitos**:
  - O `body` da requisição deve ser do tipo `multipart/form-data`.
  - O parâmetro deve se chamar `file` e conter o arquivo CSV.

### 2. Listar e filtrar filmes

- **Método**: GET  
- **URL**: `http://localhost:3000/movies`  
- **Descrição**: Retorna uma lista de filmes importados. É possível aplicar filtros.
