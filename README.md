# EnMiCiudad

**EnMiCiudad** es una aplicación desarrollada con **Flutter** que permite gestionar eventos de manera sencilla. La aplicación muestra una lista de eventos con detalles como ubicación, fecha, hora, tipo (Presencial, Online o Híbrido), y permite crear, editar y eliminar dichos eventos.

## Características Principales
- **Listar eventos**: Se conecta a un **API REST local** mediante `json_server` (en Docker) para obtener la información de los eventos.
- **CRUD de eventos**: Incluye un formulario para crear y editar eventos, así como la posibilidad de eliminarlos.
- **Modo oscuro**: El usuario puede alternar entre modo claro y oscuro, y la preferencia se guarda con SharedPreferences.
- **Filtrado por ciudad**: Permite filtrar los eventos según la ciudad, facilitando la búsqueda y organización de la información.
- **Navegación con rutas**: Manejo de rutas declarativas (e.g., `MaterialApp(routes: {...})`) para un flujo de usuario fácil de mantener.

## Estructura de Carpetas
- **`lib/models`**: Contiene la clase `Event` que define la estructura de un evento.
- **`lib/services`**: Incluye `ApiService` para manejar las peticiones HTTP al servidor JSON Server.
- **`lib/screens`**: Pantallas principales de la app (`HomeScreen`, `DetailScreen`, `FormScreen`).
- **`lib/utils`**: Contiene el helper de SharedPreferences (`shared_prefs_helper.dart`) para almacenar configuraciones como la última ciudad seleccionada y el modo oscuro.
- **`lib/widgets`**: Widgets reutilizables (e.g., `EventCard`).

## Requisitos
- **Flutter SDK** (versión recomendada: 3.0+)
- **Dart** (compatible con la versión de Flutter)
- **json_server** corriendo en Docker o de manera local en el puerto `3000`

## Demo en video
Si deseas ver cómo funciona la aplicación, puedes echar un vistazo a la demo en YouTube:  
[Demo de EnMiCiudad](https://www.youtube.com/watch?v=dj4AruILrgQ)
