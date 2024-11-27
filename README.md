# KCDragonBallProf

## Descripción del Proyecto

KCDragonBallProf es una aplicación para gestionar héroes y transformaciones, además de proporcionar funcionalidades de autenticación y manejo de datos mediante Combine, UIKit, y pruebas unitarias.

---

## Clases Principales

### App State y Control de Escena
- **AppState**: Maneja el estado global de la aplicación (login, logout, validación).
- **SceneDelegate**: Cambia entre vistas según el estado del usuario.

### Modelos
- **HerosModel**: Representa un héroe con atributos como `id`, `name`, `photo`.
- **TransformationModel**: Modelo de transformaciones con atributos como `description`, `photo`.

### Vista y Controladores
- **LoginView**: Interfaz personalizada para el login (email, password, botón).
- **LoginViewController**: Lógica del login y bindings con Combine.
- **HerosTableViewController**: Lista de héroes con navegación a detalles.
- **DetailHeroViewController**: Muestra detalles de un héroe.
- **TransformationsTableViewController**: Lista de transformaciones.
- **ErrorViewController**: Pantalla de error con opción de retorno.

### Casos de Uso y Repositorios
- **LoginUseCase**: Lógica de autenticación (implementación real y fake).
- **HeroUseCase**: Gestión de datos de héroes.
- **TransformationsUseCase**: Lógica de transformaciones.
- **Repositorios**: Acceso a datos reales y mockeados para héroes y transformaciones.

### Network
- **NetworkLogin / NetworkHeros / NetworkTransformations**: Llamadas reales y simuladas a la API.
- **ConstantsApp**: Contiene constantes globales como URL y claves.
- **HTTPMethods** y **EndPoints**: Métodos HTTP y rutas de API centralizadas.

