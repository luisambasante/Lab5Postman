# Usuarios y Productos GraphQL

Servicio de datos GraphQL que permite crear, consultar, actualizar y
eliminar usuarios y productos en una base de datos MySQL. Ideal para
aprender GraphQL, esquemas tipados, resolutores y pruebas funcionales.

**Área:** Desarrollo de software y arquitectura de microservicios

**Competencia:** Construir servicios de datos con GraphQL aplicando
esquemas tipados, resolutores, persistencia en MySQL y pruebas
funcionales, de acuerdo con requisitos de calidad y seguridad.

## Estructura del proyecto

```
usuarios-graphql/
├── src/
│   ├── config/
│   │   └── db.js                  # Pool de conexión a MySQL (mysql2/promise)
│   ├── graphql/
│   │   ├── schema.js              # Tipos, queries y mutaciones (SDL, buildSchema)
│   │   └── resolvers.js           # Resolutores de Usuario y Producto
│   └── index.js                   # Servidor Express que expone /graphql
├── postman/
│   └── usuarios-productos.postman_collection.json   # Colección de Postman
├── database.sql                   # Script de creación de la BD (users, products) y datos de ejemplo
├── package.json
├── .env.example                   # Plantilla de variables de entorno
└── .env                           # Variables de entorno reales (NO se sube al repo)
```

### Código fuente

- **`src/config/db.js`**: crea un *pool* de conexiones MySQL a partir
  de las variables de entorno (`DB_HOST`, `DB_PORT`, `DB_USER`,
  `DB_PASSWORD`, `DB_NAME`). Es el único punto donde se configura la
  conexión a la base de datos.
- **`src/graphql/schema.js`**: define el esquema GraphQL con
  `buildSchema` — tipos `User` y `Product`, queries
  `users`/`user`/`products`/`product`, mutaciones
  `createUser`/`updateUser`/`deleteUser` y
  `createProduct`/`updateProduct`/`deleteProduct`.
- **`src/graphql/resolvers.js`**: implementa los resolutores para cada
  query/mutation del esquema. Todas las consultas SQL usan parámetros
  (`?`) en vez de concatenar strings, para evitar inyección SQL.
- **`src/index.js`**: levanta un servidor Express, habilita CORS y
  expone el esquema en la ruta `/graphql` usando `graphql-http`.

## Requisitos previos

- [Node.js](https://nodejs.org/) 18 o superior
- [MySQL](https://www.mysql.com/) 5.7+ / 8.x (o XAMPP/WAMP con MySQL)

## Instalación

1. Clonar el repositorio y entrar a la carpeta del laboratorio:

   ```bash
   git clone <url-del-repositorio>
   cd Lab4Postman
   ```

2. Instalar las dependencias:

   ```bash
   npm install
   ```

3. Crear el archivo `.env` a partir de la plantilla y completar tus
   propias credenciales de MySQL (este archivo **no** se sube al
   repositorio):

   ```bash
   cp .env.example .env
   ```

   ```env
   PORT=4000
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=usuario_mysql
   DB_PASSWORD=clave_mysql
   DB_NAME=graphql_db
   ```

4. Crear la base de datos y las tablas `users` y `products`
   ejecutando `database.sql` en tu servidor MySQL, por ejemplo:

   ```bash
   mysql -u root -p < database.sql
   ```

   o pegando su contenido en MySQL Workbench / phpMyAdmin.

## Ejecución

- Modo desarrollo (con recarga automática vía `nodemon`):

  ```bash
  npm run dev
  ```

- Modo producción:

  ```bash
  npm start
  ```

Al arrancar correctamente verás en consola:

```
Servidor GraphQL escuchando en http://localhost:4000/graphql
```

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
  users {
    id
    name
    email
    created_at
  }
}
```

**Obtener un usuario por ID**

```graphql
query {
  user(id: 1) {
    id
    name
    email
  }
}
```

**Crear un usuario**

```graphql
mutation {
  createUser(name: "Ana Torres", email: "ana@example.com") {
    id
    name
    email
  }
}
```

**Actualizar un usuario**

```graphql
mutation {
  updateUser(id: 1, name: "Ana Actualizada") {
    id
    name
    email
  }
}
```

**Eliminar un usuario**

```graphql
mutation {
  deleteUser(id: 1)
}
```

**Listar productos**

```graphql
query {
  products {
    id
    name
    description
    price
    stock
    created_at
  }
}
```

**Obtener un producto por ID**

```graphql
query {
  product(id: 1) {
    id
    name
    price
    stock
  }
}
```

**Crear un producto**

```graphql
mutation {
  createProduct(name: "Monitor 24''", description: "Monitor Full HD 24 pulgadas", price: 199.5, stock: 10) {
    id
    name
    price
    stock
  }
}
```

**Actualizar un producto**

```graphql
mutation {
  updateProduct(id: 1, price: 149.99, stock: 15) {
    id
    name
    price
    stock
  }
}
```

**Eliminar un producto**

```graphql
mutation {
  deleteProduct(id: 1)
}
```

## Pruebas con Postman

El repositorio incluye
[`postman/usuarios-productos.postman_collection.json`](./postman/usuarios-productos.postman_collection.json)
con dos carpetas — **Usuarios** y **Productos** —, cada una con sus 5
operaciones CRUD y 2 pruebas negativas.

1. Abrir Postman y usar **Import** → seleccionar
   `postman/usuarios-productos.postman_collection.json`.
2. La colección define la variable `base_url` (por defecto
   `http://localhost:4000`); ajústala si tu servidor corre en otro
   puerto.
3. Con el servidor corriendo (`npm run dev`), ejecutar en orden las
   peticiones de cada carpeta. Todas se envían como `POST` a
   `{{base_url}}/graphql` con el cuerpo en formato JSON
   (`{ "query": "...", "variables": { ... } }`).

### Pruebas negativas

La colección incluye cuatro casos de error esperados:

- **`[Negativa] Crear usuario con email duplicado`**: intenta crear un
  usuario con un email que ya existe (`ana@example.com`). Debe fallar
  por la restricción `UNIQUE` de la columna `email` en MySQL, sin
  llegar a insertar el registro.
- **`[Negativa] Actualizar usuario inexistente`**: intenta actualizar
  un `id` que no existe (`999999`). Debe responder `data.updateUser: null`
  en vez de un error de servidor.
- **`[Negativa] Crear producto con precio inválido`**: envía un string
  en el argumento `price` (que es `Float!`). Debe fallar con un error
  de validación de GraphQL, sin crear el producto.
- **`[Negativa] Eliminar producto inexistente`**: intenta eliminar un
  `id` que no existe (`999999`). Debe responder `data.deleteProduct: false`
  en vez de un error de servidor.

## Seguridad

- Las credenciales reales de la base de datos viven únicamente en
  `.env`, el cual está excluido del control de versiones mediante
  `.gitignore`. Usa `.env.example` como referencia de las variables
  requeridas.
- Todas las consultas a la base de datos usan sentencias
  parametrizadas (`mysql2` con `?`), nunca concatenación de strings,
  para prevenir inyección SQL.
