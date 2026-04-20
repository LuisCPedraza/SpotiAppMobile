# Spotiapp Mobile

Aplicacion movil en Flutter para explorar musica con Spotify API.

## Que hace actualmente

- Home con contenido musical cargado desde Spotify.
- Busqueda de artistas por nombre.
- Pantalla de detalle de artista con top tracks.
- Reproduccion de preview de 30 segundos cuando Spotify lo permite.
- Modo fallback para cuentas con restricciones de API (evita romper la pantalla cuando `top-tracks` devuelve 403).

## Cambios implementados en esta modernizacion

- Migracion de nomenclatura de peliculas a canciones:
	- `Movie` -> `Song`
	- `MoviesProvider` -> `SongsProvider`
	- `movie_slider.dart` -> `song_slider.dart`
- Correcciones de integracion Spotify para credenciales restringidas:
	- Search con limites compatibles (`limit=10`).
	- Fallback de top tracks por busqueda (`artist:<nombre>`), cuando endpoint oficial falla.
- Mejora visual:
	- Tema minimalista claro (blanco principal, grises y negro de contraste).
	- Badge informativo en detalle: `Top tracks (fallback por busqueda)`.
- Organizacion del repositorio por tipo de artefacto:
	- Evidencias visuales en `docs/evidence/screenshots/`
	- Jerarquias UI (xml) en `docs/evidence/ui-hierarchy/`
	- Reportes y logs en `docs/reports/`
	- Scripts tecnicos en `scripts/` separados por categoria.

## Requisitos

- Flutter SDK instalado.
- Android Studio con emulador Android configurado.
- Credenciales de Spotify for Developers.

## Configuracion de entorno

1. Copia archivo de ejemplo:

```bash
copy .env.example .env
```

2. Completa variables:

```env
SPOTIFY_CLIENT_ID=tu_client_id
SPOTIFY_CLIENT_SECRET=tu_client_secret
SPOTIFY_REDIRECT_URI=com.example.appmovilspotify://spotify-auth
```

Nota: este taller usa `Client Credentials`. En produccion no se debe exponer `client_secret` en app movil.

## Instalacion

```bash
flutter pub get
```

## Ejecucion

```bash
flutter run -d emulator-5554 --no-resident --no-enable-impeller --enable-software-rendering
```

## Estructura del proyecto (organizada)

### Codigo fuente

- `lib/models/`: modelos de dominio y mapeos.
- `lib/providers/`: estado global con Provider.
- `lib/services/`: consumo de Spotify API.
- `lib/screens/`: pantallas principales.
- `lib/widgets/`: componentes reutilizables.

### Documentacion y evidencias

- `docs/spotiApp.pptx`: guia base del taller.
- `docs/evidence/screenshots/`: capturas de Home, Buscar y Artista.
- `docs/evidence/ui-hierarchy/`: dumps xml de UI para depuracion.
- `docs/reports/`: logs y reportes de ejecucion.

### Scripts de soporte

- `scripts/extract/`: utilidades para extraer texto/documentos.
- `scripts/spotify-tests/`: pruebas manuales de endpoints Spotify.
- `scripts/refactor/`: scripts usados para refactor tecnico.

## Endpoints usados

- `GET /v1/search` (artist, track)
- `GET /v1/artists/{id}`
- `GET /v1/artists/{id}/top-tracks` (con fallback si no disponible)

## Que se puede hacer con este proyecto

- Usarlo como base para una app musical en Flutter con Provider.
- Extender la busqueda con filtros (pais, genero, popularidad).
- Implementar autenticacion OAuth completa para eliminar restricciones de `Client Credentials`.
- Agregar favoritos, historial y playlists locales.
- Publicar version Android con ajustes de seguridad y backend proxy para tokens.
