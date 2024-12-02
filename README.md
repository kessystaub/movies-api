# API de Importação de Filmes

Esta API permite a importação de filmes através de um arquivo CSV e oferece endpoints para visualizar e filtrar os filmes importados.

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
