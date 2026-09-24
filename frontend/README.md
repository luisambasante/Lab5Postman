# Frontend: Gestión de Usuarios

Interfaz web construida con **React + Vite** y **Apollo Client** que consume la API GraphQL del backend para listar, crear, editar y eliminar usuarios.

> Requiere que el backend esté corriendo (ver el README del backend).

## Funcionalidades

- Listar usuarios en una tabla, con contador de registros.
- Crear un usuario (nombre y correo).
- Editar un usuario existente desde la tabla.
- Eliminar un usuario, con confirmación.
- La tabla se actualiza sola después de crear, editar o eliminar.
- Estados de carga, error y lista vacía.
- Diseño responsive (celular y escritorio).

## Tecnologías

| Herramienta | Uso |
|---|---|
| React | Interfaz de usuario |
| Vite | Servidor de desarrollo y empaquetado |
| Apollo Client | Consultas y mutaciones GraphQL, caché |
| GraphQL | Lenguaje de consulta hacia la API |

## Requisitos previos

- [Node.js](https://nodejs.org/) 20 o superior
- Backend GraphQL corriendo en `http://localhost:4000/graphql`

## Instalación

```bash
cd frontend
npm install
npm install @apollo/client graphql rxjs
```

## Configuración

El cliente de Apollo se crea en `src/main.jsx` y apunta al backend:

```jsx
const client = new ApolloClient({
  link: new HttpLink({ uri: 'http://localhost:4000/graphql' }),
  cache: new InMemoryCache(),
});
```

Si el backend usa otro puerto (variable `PORT` de su `.env`), cambia el `uri` aquí.

## Ejecución

```bash
npm run dev
```

Abre en el navegador la dirección que muestra Vite (por defecto `http://localhost:5173`).

### Scripts disponibles

| Comando | Descripción |
|---|---|
| `npm run dev` | Servidor de desarrollo con recarga en caliente |
| `npm run build` | Genera la versión de producción en `dist/` |
| `npm run preview` | Sirve localmente la versión de producción |
| `npm run lint` | Revisa el código con ESLint |

## Puertos utilizados

| Servicio | Puerto | URL |
|---|---|---|
| Frontend (Vite) | `5173` | http://localhost:5173 |
| Backend GraphQL | `4000` | http://localhost:4000/graphql |

## Estructura

```
src/
├── graphql/
│   └── operaciones.js          # Queries y mutations (gql)
├── components/
│   ├── ListaUsuarios.jsx       # Tabla: lista y elimina usuarios
│   └── FormularioUsuario.jsx   # Formulario: crea y edita usuarios
├── App.jsx                     # Composición y estado del usuario en edición
├── main.jsx                    # ApolloProvider y cliente
└── index.css                   # Estilos globales
```

## Cómo funciona

- **`App.jsx`** guarda en un estado el usuario que se está editando. Al pulsar **Editar** en la tabla, ese usuario pasa al formulario; al terminar, el estado se limpia.
- **`ListaUsuarios`** ejecuta la consulta `users` y maneja los estados de carga y error.
- **`FormularioUsuario`** ejecuta `createUser` o `updateUser` según haya o no un usuario en edición.
- Después de cada mutación se usa `refetchQueries` para volver a pedir la lista.

## Operaciones GraphQL utilizadas

| Constante | Operación | Descripción |
|---|---|---|
| `OBTENER_USUARIOS` | `users` | Lista todos los usuarios |
| `CREAR_USUARIO` | `createUser(name, email)` | Crea un usuario |
| `ACTUALIZAR_USUARIO` | `updateUser(id, name, email)` | Actualiza un usuario |
| `ELIMINAR_USUARIO` | `deleteUser(id)` | Elimina un usuario (devuelve `true` / `false`) |

## Solución de problemas

| Síntoma | Causa probable |
|---|---|
| Pantalla en blanco | Revisa la consola del navegador (`F12`) y la terminal de Vite; suele ser un error de import o de sintaxis |
| Se ve la plantilla de Vite y no la tabla | `App.jsx` no renderiza `ListaUsuarios` |
| `Failed to fetch` | El backend está apagado o el `uri` no coincide con su puerto |
| `Could not find "client"` | Falta envolver `<App />` con `ApolloProvider` en `main.jsx` |
| Error al importar `useQuery` | Con Apollo Client 4 se importa de `@apollo/client/react` |
| `Duplicate entry ... for key 'email'` | Ya existe un usuario con ese correo |
| Estilos que no se aplican | `main.jsx` debe importar `./index.css` |
