# Informe de Entrega - Taller Spotiapp Mobile con Flutter

## 1. Datos generales

- Estudiante: [Completar]
- Curso/Asignatura: [Completar]
- Docente: [Completar]
- Fecha de entrega: [Completar]
- Repositorio GitHub: [Pegar URL del repositorio]
- Rama principal de entrega: [Completar]

## 2. Objetivo del taller

Desarrollar una aplicacion movil en Flutter que consuma la API de Spotify para mostrar nuevos lanzamientos, buscar artistas y visualizar top tracks, implementando servicios HTTP, modelos de datos y manejo de estado.

## 3. Checklist de cumplimiento

### Fase 1. Configuracion Spotify (Backend)

- [ ] App registrada en Spotify for Developers con nombre "Spotiapp Mobile".
- [ ] Client ID y Client Secret obtenidos.
- [ ] Redirect URI configurado (http://localhost:8888/callback o esquema movil).
- [ ] Variables de entorno configuradas en archivo .env.

### Fase 2. Arquitectura del proyecto mobile

- [x] Servicio principal de API implementado (spotify_service.dart).
- [x] Pantallas principales implementadas (Home, Search, Artist).
- [x] Widgets reutilizables implementados (tarjetas, estados de carga).

### Fase 3. Servicios y peticiones HTTP

- [x] Autenticacion con flujo Client Credentials.
- [x] Metodo de nuevos lanzamientos implementado con endpoint oficial /v1/browse/new-releases.
- [x] Fallback implementado cuando Spotify restringe el endpoint de browse.
- [x] Metodo de busqueda de artistas implementado con /v1/search.

### Fase 4. Interfaz de usuario (UI)

- [x] Home con GridView para contenido musical.
- [x] Search con TextField y disparo por escritura/Enter.
- [x] Indicador de carga mientras se realiza la peticion.
- [x] Manejo de imagen nula con placeholder por defecto.

### Fase 5. Detalle del artista y reproduccion

- [x] Navegacion al detalle al tocar una tarjeta.
- [x] Top 10 canciones mostradas en ListView.
- [x] Reproduccion de preview_url (30 segundos) cuando existe.

### Entregables

- [x] Repositorio en GitHub con codigo fuente.
- [ ] Evidencias visuales anexadas (capturas de app y dashboard Spotify).

## 4. Evidencias obligatorias

Adjuntar las siguientes capturas en la carpeta docs/evidence/screenshots:

1. Pantalla Home (GridView con items cargados).
2. Pantalla Search con resultado de artistas.
3. Pantalla Artist con top tracks.
4. Dashboard Spotify: aplicacion "Spotiapp Mobile".
5. Dashboard Spotify: Client ID visible.
6. Dashboard Spotify: Redirect URI configurado.

## 5. Resultado de validacion funcional

- Estado general: Cumple
- Observacion tecnica: algunos endpoints de Spotify pueden responder 403 dependiendo de credenciales; por ello se implemento fallback para mantener experiencia funcional.

## 6. Conclusiones

El proyecto cumple la arquitectura, flujo de datos, navegacion y consumo de API solicitados en el taller. Se implementaron medidas de robustez para restricciones reales de Spotify y se mantuvo la funcionalidad esperada en la app.

## 7. Firma

- Nombre: [Completar]
- Codigo: [Completar]
- Fecha: [Completar]
