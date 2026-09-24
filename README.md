# Gestión de Usuarios y Productos con GraphQL

Aplicación full stack para crear, consultar, actualizar y eliminar usuarios (y productos) mediante una API **GraphQL** con **Node.js + Express** y una base de datos **MySQL**, consumida desde un frontend en **React + Vite** con **Apollo Client**.

## Tecnologías

| Capa | Tecnologías |
|---|---|
| Backend | Node.js, Express, `graphql`, `graphql-http`, `mysql2`, `dotenv`, `cors` |
| Base de datos | MySQL 5.7+ / 8.x (administrada con MySQL Workbench) |
| Frontend | React, Vite, Apollo Client |
| Pruebas de API | Postman |

## Estructura del proyecto

```
Lab4Postman/                      # Backend
├── src/
│   ├── config/db.js              # Pool de conexión a MySQL
│   ├── graphql/
│   │   ├── schema.js             # Tipos, queries y mutations
│   │   └── resolvers.js          # Resolutores (SQL parametrizado)
│   └── index.js                  # Servidor Express (/graphql y /graphiql)
├── postman/                      # Colección de Postman
├── database.sql                  # Script de la base de datos y datos de ejemplo
├── .env.example                  # Plantilla de variables de entorno
└── package.json

frontend/                         # Frontend (Vite + React)
└── src/
    ├── graphql/operaciones.js    # Queries y mutations de Apollo
    ├── components/
    │   ├── ListaUsuarios.jsx     # Tabla de usuarios (listar y eliminar)
    │   └── FormularioUsuario.jsx # Formulario (crear y editar)
    ├── App.jsx
    ├── main.jsx                  # ApolloProvider y cliente
    └── index.css                 # Estilos
```

> Ajusta los nombres de carpeta si en tu repositorio se llaman diferente.

## Requisitos previos

- [Node.js](https://nodejs.org/) 20 o superior
- [MySQL](https://www.mysql.com/) 5.7+ / 8.x y MySQL Workbench
- [Postman](https://www.postman.com/) (opcional, para probar la API)

## Instalación

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd Lab4Postman
```

### 2. Crear la base de datos

Abre MySQL Workbench, conéctate a tu servidor y ejecuta el contenido de `database.sql`. También puedes hacerlo desde la terminal:

```bash
mysql -u root -p < database.sql
```

Esto crea la base `graphql_db` con las tablas `users` y `products` y algunos datos de ejemplo.

### 3. Configurar el backend

```bash
npm install
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

> El archivo `.env` contiene credenciales y **no debe subirse** al repositorio.

### 4. Configurar el frontend

```bash
cd frontend
npm install
npm install @apollo/client graphql rxjs
```

Verifica que el cliente de Apollo en `src/main.jsx` apunte al backend:

```js
new HttpLink({ uri: 'http://localhost:4000/graphql' })
```

## Ejecución

Necesitas **dos terminales**, una para cada parte. Asegúrate de que MySQL esté corriendo.

**Terminal 1: Backend**

```bash
npm run dev      # con recarga automática (nodemon)
# o bien
npm start
```

Verás en consola:

```
Servidor GraphQL escuchando en http://localhost:4000/graphql
```

**Terminal 2: Frontend**

```bash
cd frontend
npm run dev
```

Abre en el navegador la dirección que muestra Vite (por defecto `http://localhost:5173`).

## Puertos utilizados

| Servicio | Puerto | URL |
|---|---|---|
| Backend GraphQL (Express) | `4000` | http://localhost:4000/graphql |
| Interfaz GraphiQL | `4000` | http://localhost:4000/graphiql |
| Frontend (Vite) | `5173` | http://localhost:5173 |
| MySQL | `3306` | `localhost:3306` |

El puerto del backend se cambia con la variable `PORT` del `.env`; si lo modificas, actualiza también el `uri` en `main.jsx`.

## Esquema GraphQL

```graphql
type User {
  id: ID!
  name: String!
  email: String!
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

### Ejemplo de consulta

```graphql
query {
  users {
    id
    name
    email
  }
}
```

## Pruebas con Postman

1. Importa `postman/usuarios-productos.postman_collection.json`.
2. Verifica que la variable `base_url` sea `http://localhost:4000`.
3. Con el backend corriendo, ejecuta las peticiones (todas son `POST` a `{{base_url}}/graphql` con cuerpo JSON).

## Solución de problemas

| Síntoma | Causa probable |
|---|---|
| `Missing query` al abrir `/graphql` en el navegador | Es normal: el navegador hace un `GET` sin consulta. Usa `/graphiql` o Postman |
| `Access denied` / `Unknown database` | Revisa `DB_USER`, `DB_PASSWORD` y `DB_NAME` en `.env`, y que hayas ejecutado `database.sql` |
| `Failed to fetch` en el frontend | El backend está apagado o el `uri` de Apollo no coincide con el puerto |
| `Duplicate entry ... for key 'email'` | Ya existe un usuario con ese correo |
| Pantalla en blanco en Vite | Revisa la consola del navegador (`F12`) y que `App.jsx` renderice los componentes |

## Autores

| Nombre | Rol |
|---|---|
| _Nombre del autor 1_ | _Backend / Base de datos_ |
| _Nombre del autor 2_ | _Frontend_ |

## Licencia

Proyecto académico desarrollado con fines educativos.
