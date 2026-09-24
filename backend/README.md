# Backend: API GraphQL de Usuarios y Productos

API construida con **Node.js + Express** y **GraphQL** que permite crear, consultar, actualizar y eliminar usuarios y productos, con persistencia en **MySQL**.

## Funcionalidades

- CRUD completo de **usuarios** y **productos**.
- Esquema GraphQL tipado (`buildSchema`) con queries y mutations.
- Consultas SQL parametrizadas (`?`) para evitar inyección SQL.
- Interfaz GraphiQL para probar consultas desde el navegador.
- Colección de Postman con pruebas positivas y negativas.

## Tecnologías

| Herramienta | Uso |
|---|---|
| Node.js + Express | Servidor HTTP |
| `graphql` + `graphql-http` | Esquema y manejo de peticiones GraphQL |
| `mysql2` | Conexión a MySQL (pool de conexiones) |
| `dotenv` | Variables de entorno |
| `cors` | Permite peticiones desde el frontend |
| `nodemon` | Recarga automática en desarrollo |
| MySQL 5.7+ / 8.x | Base de datos (administrada con MySQL Workbench) |

## Requisitos previos

- [Node.js](https://nodejs.org/) 18 o superior
- [MySQL](https://www.mysql.com/) 5.7+ / 8.x y MySQL Workbench (o XAMPP/WAMP con MySQL)
- [Postman](https://www.postman.com/) (opcional, para probar la API)

## Instalación

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd Lab4Postman
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Crear la base de datos

Abre MySQL Workbench, conéctate a tu servidor y ejecuta el contenido de `database.sql`. También puedes hacerlo desde la terminal:

```bash
mysql -u root -p < database.sql
```

Esto crea la base `graphql_db` con las tablas `users` y `products` y datos de ejemplo.

### 4. Configurar las variables de entorno

```bash
cp .env.example .env
```

Edita `.env` con los datos de tu conexión de MySQL Workbench:

```env
PORT=4000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_contraseña
DB_NAME=graphql_db
```

| Variable | Descripción |
|---|---|
| `PORT` | Puerto del servidor (por defecto `4000`) |
| `DB_HOST` | Servidor de MySQL |
| `DB_PORT` | Puerto de MySQL (normalmente `3306`) |
| `DB_USER` | Usuario de MySQL |
| `DB_PASSWORD` | Contraseña de MySQL |
| `DB_NAME` | Nombre de la base de datos (`graphql_db`) |

> `.env` contiene credenciales y **no debe subirse** al repositorio (ya está en `.gitignore`).

## Ejecución

```bash
npm run dev      # desarrollo, con recarga automática (nodemon)
npm start        # producción
```

Al arrancar correctamente verás:

```
Servidor GraphQL escuchando en http://localhost:4000/graphql
```

## Puertos y rutas

| Servicio | Puerto | URL |
|---|---|---|
| API GraphQL | `4000` | http://localhost:4000/graphql |
| Interfaz GraphiQL | `4000` | http://localhost:4000/graphiql |
| MySQL | `3306` | `localhost:3306` |

- **`/graphql`** recibe las consultas. Si lo abres en el navegador verás `Missing query`: es normal, el navegador hace un `GET` sin consulta.
- **`/graphiql`** es la interfaz para escribir y ejecutar consultas (requiere conexión a internet, porque carga sus archivos desde un CDN).
- El frontend en Vite corre en el puerto `5173`.

## Estructura

```
Lab4Postman/
├── src/
│   ├── config/
│   │   └── db.js               # Pool de conexión a MySQL
│   ├── graphql/
│   │   ├── schema.js           # Tipos, queries y mutations
│   │   └── resolvers.js        # Resolutores de usuarios y productos
│   └── index.js                # Servidor Express (/graphql y /graphiql)
├── postman/
│   └── usuarios-productos.postman_collection.json
├── database.sql                # Creación de la BD, tablas y datos de ejemplo
├── .env.example                # Plantilla de variables de entorno
└── package.json
```

## Base de datos

**`users`**

| Campo | Tipo | Notas |
|---|---|---|
| `id` | INT UNSIGNED | Clave primaria, autoincremental |
| `name` | VARCHAR(100) | Obligatorio |
| `email` | VARCHAR(150) | Obligatorio y **único** |
| `created_at` | TIMESTAMP | Fecha de creación |

**`products`**

| Campo | Tipo | Notas |
|---|---|---|
| `id` | INT UNSIGNED | Clave primaria, autoincremental |
| `name` | VARCHAR(150) | Obligatorio |
| `description` | VARCHAR(500) | Opcional |
| `price` | DECIMAL(10,2) | Obligatorio |
| `stock` | INT UNSIGNED | Por defecto `0` |
| `created_at` | TIMESTAMP | Fecha de creación |

## Esquema GraphQL

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  created_at: String
}

type Product {
  id: ID!
  name: String!
  description: String
  price: Float!
  stock: Int!
  created_at: String
}

type Query {
  users: [User!]!
  user(id: ID!): User
  products: [Product!]!
  product(id: ID!): Product
}

type Mutation {
  createUser(name: String!, email: String!): User!
  updateUser(id: ID!, name: String, email: String): User
  deleteUser(id: ID!): Boolean!

  createProduct(name: String!, description: String, price: Float!, stock: Int!): Product!
  updateProduct(id: ID!, name: String, description: String, price: Float, stock: Int): Product
  deleteProduct(id: ID!): Boolean!
}
```

### Ejemplos de operaciones

**Listar usuarios**

```graphql
query {
  users { id name email created_at }
}
```

**Crear un usuario**

```graphql
mutation {
  createUser(name: "Ana Torres", email: "ana@example.com") { id name email }
}
```

**Actualizar un usuario**

```graphql
mutation {
  updateUser(id: 1, name: "Ana Actualizada") { id name email }
}
```

**Eliminar un usuario** (devuelve `true` o `false`)

```graphql
mutation {
  deleteUser(id: 1)
}
```

**Crear un producto**

```graphql
mutation {
  createProduct(name: "Monitor 24''", description: "Full HD", price: 199.5, stock: 10) {
    id name price stock
  }
}
```

## Pruebas con Postman

1. En Postman: **Import** → `postman/usuarios-productos.postman_collection.json`.
2. Verifica que la variable `base_url` sea `http://localhost:4000`.
3. Con el servidor corriendo, ejecuta las peticiones. Todas son `POST` a `{{base_url}}/graphql` con cuerpo JSON:

```json
{ "query": "{ users { id name email } }" }
```

### Pruebas negativas incluidas

| Prueba | Resultado esperado |
|---|---|
| Crear usuario con email duplicado | Error por la restricción `UNIQUE` |
| Actualizar usuario inexistente | `data.updateUser: null` |
| Crear producto con precio inválido | Error de validación de GraphQL |
| Eliminar producto inexistente | `data.deleteProduct: false` |

## Seguridad

- Las credenciales viven solo en `.env`, excluido del control de versiones.
- Todas las consultas SQL usan parámetros (`mysql2` con `?`), sin concatenar strings.

## Solución de problemas

| Síntoma | Causa probable |
|---|---|
| `Missing query` en el navegador | Es normal en `/graphql`. Usa `/graphiql` o Postman |
| `Access denied for user` | `DB_USER` o `DB_PASSWORD` incorrectos en `.env` |
| `Unknown database 'graphql_db'` | No ejecutaste `database.sql` |
| `ECONNREFUSED` | MySQL está apagado, o `DB_HOST` / `DB_PORT` no coinciden |
| `EADDRINUSE` | El puerto 4000 ya está en uso; cambia `PORT` en `.env` |
| `Duplicate entry ... for key 'email'` | Ya existe un usuario con ese correo |
| Cambios en `.env` que no se aplican | Reinicia el servidor |
