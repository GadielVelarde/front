# API Documentation - Backend ASC

## Descripción General

Backend para el sistema de gestión de rutas, seguimientos y socios. La API está construida con AWS Lambda y API Gateway, implementando una arquitectura serverless. Todos los endpoints (excepto login) requieren autenticación mediante JWT.

## Base URL

```
https://<api-gateway-url>/
```

---

## Autenticación

### JWT Authentication

La mayoría de los endpoints requieren un token JWT en el header `Authorization`:

```
Authorization: Bearer <jwt-token>
```

**Obtener un token:**
1. Hacer login usando el endpoint `POST /auth/login`
2. El token retornado debe incluirse en todas las peticiones subsecuentes

**Roles de usuario:**
- `ASESOR` - Asesor de campo
- `JEFE` - Jefe de agencia
- `ADMIN` - Administrador del sistema

---

## Índice de Endpoints

### Autenticación
- [POST /auth/login](#post-authlogin) - Iniciar sesión

### Socios
- [GET /socios](#get-socios) - Buscar socio
- [GET /socios/me](#get-sociosme) - Obtener mis socios asignados
- [GET /socios/{socio_id}](#get-sociossocio_id) - Obtener resumen de socio
- [GET /socios/{socio_id}/creditos](#get-sociossocio_idcreditos) - Obtener créditos de un socio

### Créditos
- [GET /creditos/{credito_id}](#get-creditoscredito_id) - Obtener detalle de crédito

### Rutas
- [GET /routes](#get-routes) - Listar todas las rutas
- [GET /routes/{route_id}](#get-routesroute_id) - Obtener detalle de ruta
- [POST /routes](#post-routes) - Crear nueva ruta
- [PUT /routes/{route_id}](#put-routesroute_id) - Actualizar ruta
- [DELETE /routes/{route_id}](#delete-routesroute_id) - Eliminar ruta
- [POST /routes/{route_id}/approve](#post-routesroute_idapprove) - Aprobar ruta
- [PATCH /routes/{route_id}/status](#patch-routesroute_idstatus) - Actualizar estado de ruta
- [GET /routes/{route_id}/socios](#get-routesroute_idsocios) - Obtener socios de una ruta

### Clientes en Rutas
- [POST /routes/{route_id}/clientes](#post-routesroute_idclientes) - Agregar cliente a ruta
- [PUT /routes/{route_id}/clientes/{cliente_id}](#put-routesroute_idclientescliente_id) - Actualizar visita de cliente
- [DELETE /routes/{route_id}/clientes/{cliente_id}](#delete-routesroute_idclientescliente_id) - Eliminar cliente de ruta

### Seguimientos
- [GET /seguimientos](#get-seguimientos) - Listar seguimientos
- [GET /seguimientos/{seguimiento_id}](#get-seguimientosseguimiento_id) - Obtener detalle de seguimiento
- [POST /seguimientos](#post-seguimientos) - Crear seguimiento
- [PUT /seguimientos/{seguimiento_id}](#put-seguimientosseguimiento_id) - Actualizar seguimiento
- [DELETE /seguimientos/{seguimiento_id}](#delete-seguimientosseguimiento_id) - Eliminar seguimiento
- [POST /seguimientos/{seguimiento_id}/complete](#post-seguimientosseguimiento_idcomplete) - Completar seguimiento

---

## Endpoints Detallados

---

## Autenticación

### POST /auth/login

**Descripción:** Autentica un usuario y retorna un token JWT.

**Autenticación:** ❌ No requiere

**Request Body:**
```json
{
    "username": "usuario123",
    "password": "password123"
}
```

**Response (200 OK):**
```json
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
        "id": 1,
        "username": "usuario123",
        "role": "ASESOR"
    }
}
```

**Códigos de Estado:**
- `200` - Login exitoso
- `400` - Datos inválidos
- `401` - Credenciales incorrectas
- `500` - Error del servidor

---

## Socios

### GET /socios

**Descripción:** Busca un socio por tipo y número de documento.

**Autenticación:** ✅ JWT (Roles: ASESOR, JEFE, ADMIN)

**Query Parameters:**
- `tipo_documento` (string, requerido): Tipo de documento (ej: "DNI", "RUC")
- `num_documento` (string, requerido): Número de documento

**Request:**
```http
GET /socios?tipo_documento=DNI&num_documento=12345678
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
    "id": "SOC001",
    "nombre": "Juan Pérez",
    "tipo_documento": "DNI",
    "num_documento": "12345678",
    "direccion": "Av. Principal 123",
    "telefono": "987654321"
}
```

**Códigos de Estado:**
- `200` - Socio encontrado
- `400` - Parámetros faltantes o inválidos
- `401` - No autenticado
- `403` - Sin permisos
- `404` - Socio no encontrado
- `500` - Error del servidor

---

### GET /socios/me

**Descripción:** Obtiene la lista de socios asignados al usuario autenticado.

**Autenticación:** ✅ JWT (Roles: ASESOR, JEFE, ADMIN)

**Request:**
```http
GET /socios/me
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
    "socios": [
        {
            "id": "SOC001",
            "nombre": "Juan Pérez",
            "creditos_activos": 2,
            "total_deuda": 5000.00
        },
        {
            "id": "SOC002",
            "nombre": "María García",
            "creditos_activos": 1,
            "total_deuda": 2500.00
        }
    ]
}
```

**Códigos de Estado:**
- `200` - Lista obtenida exitosamente
- `401` - No autenticado
- `403` - Sin permisos
- `500` - Error del servidor

---

### GET /socios/{socio_id}

**Descripción:** Obtiene el resumen completo de un socio específico.

**Autenticación:** ✅ JWT (Roles: ASESOR, JEFE, ADMIN)

**Path Parameters:**
- `socio_id` (string, requerido): ID del socio

**Request:**
```http
GET /socios/SOC001
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
    "id": "SOC001",
    "nombre": "Juan Pérez",
    "tipo_documento": "DNI",
    "num_documento": "12345678",
    "direccion": "Av. Principal 123",
    "telefono": "987654321",
    "email": "juan.perez@email.com",
    "creditos": [
        {
            "id": "CRE001",
            "monto": 5000.00,
            "saldo": 2500.00,
            "estado": "ACTIVO"
        }
    ]
}
```

**Códigos de Estado:**
- `200` - Resumen obtenido
- `401` - No autenticado
- `403` - Sin permisos
- `404` - Socio no encontrado
- `500` - Error del servidor

---

### GET /socios/{socio_id}/creditos

**Descripción:** Obtiene todos los créditos asociados a un socio.

**Autenticación:** ✅ JWT (Roles: ASESOR, JEFE, ADMIN)

**Path Parameters:**
- `socio_id` (string, requerido): ID del socio

**Request:**
```http
GET /socios/SOC001/creditos
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
[
    {
        "id": "CRE001",
        "monto_original": 5000.00,
        "saldo_actual": 2500.00,
        "fecha_desembolso": "2024-01-15",
        "fecha_vencimiento": "2025-01-15",
        "estado": "ACTIVO",
        "cuotas_pendientes": 6,
        "cuotas_totales": 12
    },
    {
        "id": "CRE002",
        "monto_original": 3000.00,
        "saldo_actual": 0.00,
        "fecha_desembolso": "2023-06-10",
        "fecha_vencimiento": "2024-06-10",
        "estado": "PAGADO",
        "cuotas_pendientes": 0,
        "cuotas_totales": 12
    }
]
```

**Códigos de Estado:**
- `200` - Créditos obtenidos
- `401` - No autenticado
- `403` - Sin permisos
- `404` - Socio no encontrado
- `500` - Error del servidor

---

## Créditos

### GET /creditos/{credito_id}

**Descripción:** Obtiene el detalle completo de un crédito específico.

**Autenticación:** ✅ JWT (Roles: ASESOR, JEFE, ADMIN)

**Path Parameters:**
- `credito_id` (string, requerido): ID del crédito

**Request:**
```http
GET /creditos/CRE001
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
    "id": "CRE001",
    "socio_id": "SOC001",
    "socio_nombre": "Juan Pérez",
    "monto_original": 5000.00,
    "saldo_actual": 2500.00,
    "tasa_interes": 15.5,
    "fecha_desembolso": "2024-01-15",
    "fecha_vencimiento": "2025-01-15",
    "estado": "ACTIVO",
    "cuotas": [
        {
            "numero": 1,
            "monto": 450.00,
            "fecha_vencimiento": "2024-02-15",
            "estado": "PAGADO",
            "fecha_pago": "2024-02-14"
        }
    ]
}
```

**Códigos de Estado:**
- `200` - Crédito obtenido
- `401` - No autenticado
- `403` - Sin permisos
- `404` - Crédito no encontrado
- `500` - Error del servidor

---

## Rutas

### GET /routes

**Descripción:** Lista todas las rutas disponibles en el sistema.

**Autenticación:** ✅ JWT

**Request:**
```http
GET /routes
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
[
    {
        "id": 1,
        "nombre": "Ruta Centro - Enero 2024",
        "descripcion": "Visitas a socios del centro de la ciudad",
        "fecha": "2024-01-20",
        "estado": "Aprobado",
        "asesor_id": 5,
        "nombre_asesor": "Carlos López",
        "total_visitas": 15,
        "visitas_completadas": 10
    }
]
```

**Códigos de Estado:**
- `200` - Rutas obtenidas
- `401` - No autenticado
- `500` - Error del servidor

---

### GET /routes/{route_id}

**Descripción:** Obtiene el detalle completo de una ruta específica.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta

**Request:**
```http
GET /routes/1
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
    "id": 1,
    "nombre": "Ruta Centro - Enero 2024",
    "descripcion": "Visitas a socios del centro de la ciudad",
    "fecha": "2024-01-20",
    "tipo": "COBRANZA",
    "actividad": "Visita de campo",
    "estado": "Aprobado",
    "asesor_id": 5,
    "nombre_asesor": "Carlos López",
    "agencia_id": 2,
    "zona_id": 1,
    "total_visitas": 15,
    "visitas_completadas": 10,
    "clientes": [
        {
            "persona_id": 123,
            "nombre": "Juan Pérez",
            "direccion": "Av. Principal 123",
            "visita": true,
            "visita_fecha": "2024-01-20T10:30:00"
        }
    ]
}
```

**Códigos de Estado:**
- `200` - Ruta obtenida
- `401` - No autenticado
- `404` - Ruta no encontrada
- `500` - Error del servidor

---

### POST /routes

**Descripción:** Crea una nueva ruta.

**Autenticación:** ✅ JWT

**Request Body:**
```json
{
    "nombre": "Ruta Norte - Febrero 2024",
    "descripcion": "Cobranza zona norte",
    "fecha": "2024-02-15",
    "tipo": "COBRANZA",
    "actividad": "Visita de campo",
    "user_id": 1,
    "asesor_id": 5,
    "agencia_id": 2,
    "zona_id": 1,
    "tiporuta_id": 1,
    "estado": "No aprobado",
    "observacion": "Primera ruta del mes"
}
```

**Campos del Body:**
- `nombre` (string): Nombre de la ruta
- `descripcion` (string): Descripción de la ruta
- `fecha` (string ISO): Fecha programada (formato: "YYYY-MM-DD" o ISO 8601)
- `tipo` (string): Tipo de ruta
- `actividad` (string): Actividad a realizar
- `user_id` (integer, **requerido**): ID del usuario creador
- `asesor_id` (integer, opcional): ID del asesor asignado
- `agencia_id` (integer, opcional): ID de la agencia
- `zona_id` (integer, opcional): ID de la zona
- `tiporuta_id` (integer, opcional): ID del tipo de ruta
- `estado` (string, opcional): Estado inicial (default: "No aprobado")
- `observacion` (string, opcional): Observaciones

**Response (204 No Content):**
```json
{
    "message": "New route created"
}
```

**Códigos de Estado:**
- `204` - Ruta creada exitosamente
- `400` - Datos inválidos
- `401` - No autenticado
- `500` - Error del servidor

---

### PUT /routes/{route_id}

**Descripción:** Actualiza una ruta existente.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta

**Request Body:**
```json
{
    "nombre": "Ruta Centro - Enero 2024 (Actualizada)",
    "descripcion": "Visitas actualizadas",
    "fecha": "2024-01-21",
    "user_id": 1,
    "asesor_id": 5
}
```

**Response (204 No Content):**
```json
{
    "message": "Route updated"
}
```

**Códigos de Estado:**
- `204` - Ruta actualizada
- `400` - Datos inválidos
- `401` - No autenticado
- `404` - Ruta no encontrada
- `500` - Error del servidor

---

### DELETE /routes/{route_id}

**Descripción:** Elimina una ruta.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta

**Request:**
```http
DELETE /routes/1
Authorization: Bearer <token>
```

**Response (204 No Content):**
```json
{
    "message": "Route deleted"
}
```

**Códigos de Estado:**
- `204` - Ruta eliminada
- `401` - No autenticado
- `404` - Ruta no encontrada
- `500` - Error del servidor

---

### POST /routes/{route_id}/approve

**Descripción:** Aprueba una ruta.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta

**Request:**
```http
POST /routes/1/approve
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
    "message": "Ruta aprobada"
}
```

**Códigos de Estado:**
- `200` - Ruta aprobada
- `400` - Ruta ya aprobada o datos inválidos
- `401` - No autenticado
- `404` - Ruta no encontrada
- `500` - Error del servidor

---

### PATCH /routes/{route_id}/status

**Descripción:** Actualiza el estado de una ruta.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta

**Request Body:**
```json
{
    "estado": "En progreso"
}
```

**Valores válidos para `estado`:**
- `"No aprobado"`
- `"Aprobado"`
- `"En progreso"`
- `"Completado"`
- `"Cancelado"`

**Response (204 No Content):**
```json
{
    "message": "Route status updated"
}
```

**Códigos de Estado:**
- `204` - Estado actualizado
- `400` - Estado inválido
- `401` - No autenticado
- `404` - Ruta no encontrada
- `500` - Error del servidor

---

### GET /routes/{route_id}/socios

**Descripción:** Obtiene la lista de socios asociados a una ruta.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta

**Request:**
```http
GET /routes/1/socios
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
[
    {
        "id": "SOC001",
        "nombre": "Juan Pérez",
        "direccion": "Av. Principal 123",
        "telefono": "987654321",
        "visitado": true
    }
]
```

**Códigos de Estado:**
- `200` - Socios obtenidos
- `401` - No autenticado
- `404` - Ruta no encontrada
- `500` - Error del servidor

---

## Clientes en Rutas

### POST /routes/{route_id}/clientes

**Descripción:** Agrega un cliente (persona) a una ruta.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta

**Request Body:**
```json
{
    "persona_id": 123,
    "actividad_id": 1,
    "resultado_id": null,
    "proximavista": "2024-02-15T14:00:00",
    "foto": "https://s3.bucket.com/foto.jpg",
    "comentario": "Cliente interesado en nuevo crédito",
    "visita": false,
    "ubicacion_latitud": -12.046374,
    "ubicacion_longitud": -77.042793
}
```

**Campos del Body:**
- `persona_id` (integer, **requerido**): ID de la persona/cliente
- `actividad_id` (integer, opcional): ID de la actividad realizada
- `resultado_id` (integer, opcional): ID del resultado de la visita
- `proximavista` o `proximaVisita` (string ISO, opcional): Fecha de próxima visita
- `foto` (string, opcional): URL de la foto
- `comentario` (string, opcional): Comentarios de la visita
- `visita` (boolean, opcional): Si se realizó la visita
- `visita_fecha` o `visitaFecha` (string ISO, opcional): Fecha de la visita
- `ubicacion_latitud` o `ubicacionLatitud` (float, opcional): Latitud
- `ubicacion_longitud` o `ubicacionLongitud` (float, opcional): Longitud

**Response (201 Created):**
```json
{
    "id": 456,
    "ruta_id": 1,
    "persona_id": 123,
    "mensaje": "Cliente agregado a la ruta"
}
```

**Códigos de Estado:**
- `201` - Cliente agregado
- `400` - Datos inválidos
- `401` - No autenticado
- `404` - Ruta no encontrada
- `500` - Error del servidor

---

### PUT /routes/{route_id}/clientes/{cliente_id}

**Descripción:** Actualiza la información de visita de un cliente en la ruta.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta
- `cliente_id` (integer, requerido): ID del detalle de ruta (no es el persona_id)

**Request Body:**
```json
{
    "visita": true,
    "visita_fecha": "2024-01-20T10:30:00",
    "resultado_id": 2,
    "comentario": "Pago realizado satisfactoriamente",
    "ubicacion_latitud": -12.046374,
    "ubicacion_longitud": -77.042793
}
```

**Response (200 OK):**
```json
{
    "message": "Cliente actualizado"
}
```

**Códigos de Estado:**
- `200` - Cliente actualizado
- `400` - Datos inválidos
- `401` - No autenticado
- `404` - Cliente o ruta no encontrados
- `500` - Error del servidor

---

### DELETE /routes/{route_id}/clientes/{cliente_id}

**Descripción:** Elimina un cliente de una ruta.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `route_id` (integer, requerido): ID de la ruta
- `cliente_id` (integer, requerido): ID del detalle de ruta

**Request:**
```http
DELETE /routes/1/clientes/456
Authorization: Bearer <token>
```

**Response (204 No Content):**
```json
{
    "message": "Cliente eliminado de la ruta"
}
```

**Códigos de Estado:**
- `204` - Cliente eliminado
- `401` - No autenticado
- `404` - Cliente o ruta no encontrados
- `500` - Error del servidor

---

## Seguimientos

### GET /seguimientos

**Descripción:** Lista seguimientos con filtros opcionales.

**Autenticación:** ✅ JWT

**Query Parameters (todos opcionales):**
- `ruta_id` (integer): Filtrar por ID de ruta
- `asesor_id` (integer): Filtrar por ID de asesor
- `estado` (string): Filtrar por estado ("pendiente", "completado", "cancelado")

**Request:**
```http
GET /seguimientos?ruta_id=1&estado=pendiente
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
[
    {
        "id": 1,
        "ruta_id": 1,
        "nombre_ruta": "Ruta Centro - Enero 2024",
        "asesor_id": 5,
        "nombre_asesor": "Carlos López",
        "cliente_id": 123,
        "nombre_cliente": "Juan Pérez",
        "tipo_visita": "COBRANZA",
        "fecha_programada": "2024-01-20T10:00:00",
        "estado": "pendiente",
        "observaciones": "Primera visita del mes"
    }
]
```

**Códigos de Estado:**
- `200` - Seguimientos obtenidos
- `400` - Filtros inválidos
- `401` - No autenticado
- `500` - Error del servidor

---

### GET /seguimientos/{seguimiento_id}

**Descripción:** Obtiene el detalle de un seguimiento específico.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `seguimiento_id` (integer, requerido): ID del seguimiento

**Request:**
```http
GET /seguimientos/1
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
    "id": 1,
    "ruta_id": 1,
    "nombre_ruta": "Ruta Centro - Enero 2024",
    "asesor_id": 5,
    "nombre_asesor": "Carlos López",
    "cliente_id": 123,
    "nombre_cliente": "Juan Pérez",
    "tipo_visita": "COBRANZA",
    "observaciones": "Primera visita del mes",
    "ubicacion_latitud": -12.046374,
    "ubicacion_longitud": -77.042793,
    "fecha_programada": "2024-01-20T10:00:00",
    "fecha_realizada": null,
    "estado": "pendiente",
    "monto_recaudado": null,
    "comprobante": null,
    "fotos": [],
    "requiere_accion": false,
    "accion_requerida": null
}
```

**Códigos de Estado:**
- `200` - Seguimiento obtenido
- `401` - No autenticado
- `404` - Seguimiento no encontrado
- `500` - Error del servidor

---

### POST /seguimientos

**Descripción:** Crea un nuevo seguimiento.

**Autenticación:** ✅ JWT

**Request Body:**
```json
{
    "ruta_id": 1,
    "nombre_ruta": "Ruta Centro",
    "asesor_id": 5,
    "nombre_asesor": "Carlos López",
    "cliente_id": 123,
    "nombre_cliente": "Juan Pérez",
    "tipo_visita": "COBRANZA",
    "observaciones": "Seguimiento de cobro mensual",
    "ubicacion_latitud": -12.046374,
    "ubicacion_longitud": -77.042793,
    "fecha_programada": "2024-01-25T10:00:00",
    "estado": "pendiente",
    "requiere_accion": false
}
```

**Campos del Body:**
- `tipo_visita` o `tipoVisita` (string, **requerido**): Tipo de visita (ej: "COBRANZA", "SEGUIMIENTO", "PROSPECTO")
- `ruta_id` o `rutaId` (integer, opcional): ID de la ruta asociada
- `nombre_ruta` o `nombreRuta` (string, opcional): Nombre de la ruta
- `asesor_id` o `asesorId` (integer, opcional): ID del asesor
- `nombre_asesor` o `nombreAsesor` (string, opcional): Nombre del asesor
- `cliente_id` o `clienteId` (integer, opcional): ID del cliente
- `nombre_cliente` o `nombreCliente` (string, opcional): Nombre del cliente
- `observaciones` (string, opcional): Observaciones
- `ubicacion_latitud` o `ubicacionLatitud` (float, opcional): Latitud
- `ubicacion_longitud` o `ubicacionLongitud` (float, opcional): Longitud
- `fecha_programada` o `fechaProgramada` (string ISO, opcional): Fecha programada
- `fecha_realizada` o `fechaRealizada` (string ISO, opcional): Fecha realizada
- `estado` (string, opcional): Estado (default: "pendiente")
- `monto_recaudado` o `montoRecaudado` (float, opcional): Monto recaudado
- `comprobante` (string, opcional): Número de comprobante
- `fotos` (array de strings, opcional): URLs de fotos
- `requiere_accion` o `requiereAccion` (boolean, opcional): Si requiere acción
- `accion_requerida` o `accionRequerida` (string, opcional): Descripción de la acción

**Response (201 Created):**
```json
{
    "id": 2,
    "message": "Seguimiento creado"
}
```

**Códigos de Estado:**
- `201` - Seguimiento creado
- `400` - Datos inválidos
- `401` - No autenticado
- `500` - Error del servidor

---

### PUT /seguimientos/{seguimiento_id}

**Descripción:** Actualiza un seguimiento existente.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `seguimiento_id` (integer, requerido): ID del seguimiento

**Request Body:**
```json
{
    "observaciones": "Actualización de observaciones",
    "estado": "en_progreso",
    "ubicacion_latitud": -12.046374,
    "ubicacion_longitud": -77.042793
}
```

**Response (200 OK):**
```json
{
    "message": "Seguimiento actualizado"
}
```

**Códigos de Estado:**
- `200` - Seguimiento actualizado
- `400` - Datos inválidos
- `401` - No autenticado
- `404` - Seguimiento no encontrado
- `500` - Error del servidor

---

### DELETE /seguimientos/{seguimiento_id}

**Descripción:** Elimina un seguimiento.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `seguimiento_id` (integer, requerido): ID del seguimiento

**Request:**
```http
DELETE /seguimientos/1
Authorization: Bearer <token>
```

**Response (204 No Content):**
```json
{
    "message": "Seguimiento eliminado"
}
```

**Códigos de Estado:**
- `204` - Seguimiento eliminado
- `401` - No autenticado
- `404` - Seguimiento no encontrado
- `500` - Error del servidor

---

### POST /seguimientos/{seguimiento_id}/complete

**Descripción:** Marca un seguimiento como completado.

**Autenticación:** ✅ JWT

**Path Parameters:**
- `seguimiento_id` (integer, requerido): ID del seguimiento

**Request Body:**
```json
{
    "observaciones": "Cobro realizado exitosamente",
    "monto_recaudado": 500.00
}
```

**Campos del Body (todos opcionales):**
- `observaciones` (string): Observaciones finales
- `monto_recaudado` o `montoRecaudado` (float): Monto recaudado

**Response (200 OK):**
```json
{
    "id": 1,
    "estado": "completado",
    "fecha_realizada": "2024-01-20T10:30:00",
    "monto_recaudado": 500.00,
    "message": "Seguimiento completado"
}
```

**Códigos de Estado:**
- `200` - Seguimiento completado
- `400` - Datos inválidos o seguimiento ya completado
- `401` - No autenticado
- `404` - Seguimiento no encontrado
- `500` - Error del servidor

---

## Códigos de Error Comunes

| Código | Descripción |
|--------|-------------|
| 200 | OK - Solicitud exitosa |
| 201 | Created - Recurso creado exitosamente |
| 204 | No Content - Solicitud exitosa sin contenido de respuesta |
| 400 | Bad Request - Datos faltantes o inválidos |
| 401 | Unauthorized - No autenticado o token inválido |
| 403 | Forbidden - Sin permisos suficientes |
| 404 | Not Found - Recurso no encontrado |
| 500 | Internal Server Error - Error del servidor |

**Formato de Error:**
```json
{
    "error": "Descripción del error"
}
```

---

## Notas Importantes

### Formatos de Fecha
- Todas las fechas deben enviarse en formato ISO 8601: `"YYYY-MM-DDTHH:MM:SS"` o simplemente `"YYYY-MM-DD"`
- Ejemplos: `"2024-01-20T10:30:00"`, `"2024-01-20"`

### Nomenclatura de Campos
- La API acepta campos en formato snake_case y camelCase
- Ejemplos: `ruta_id` o `rutaId`, `fecha_programada` o `fechaProgramada`

### Estados de Rutas
- `"No aprobado"` - Ruta creada pero no aprobada
- `"Aprobado"` - Ruta aprobada por supervisor
- `"En progreso"` - Ruta en ejecución
- `"Completado"` - Ruta finalizada
- `"Cancelado"` - Ruta cancelada

### Estados de Seguimientos
- `"pendiente"` - Seguimiento programado
- `"en_progreso"` - Seguimiento en curso
- `"completado"` - Seguimiento finalizado
- `"cancelado"` - Seguimiento cancelado

### Almacenamiento de Evidencias
- Las fotos y comprobantes se almacenan en S3
- La API puede generar URLs pre-firmadas para subida de archivos
- Variable de entorno: `EVIDENCE_BUCKET`

---

## Ejemplos de Uso

### Ejemplo 1: Flujo de Login y Obtención de Socios (JavaScript)

```javascript
const API_BASE_URL = "https://your-api-gateway-url";

// 1. Login
async function login(username, password) {
    const response = await fetch(`${API_BASE_URL}/auth/login`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ username, password })
    });
    
    const data = await response.json();
    return data.token;
}

// 2. Obtener mis socios
async function getMySocios(token) {
    const response = await fetch(`${API_BASE_URL}/socios/me`, {
        headers: {
            "Authorization": `Bearer ${token}`
        }
    });
    
    return await response.json();
}

// Uso
const token = await login("usuario123", "password123");
const socios = await getMySocios(token);
console.log(socios);
```

### Ejemplo 2: Crear Ruta y Agregar Clientes (Python)

```python
import requests
from datetime import datetime

API_BASE_URL = "https://your-api-gateway-url"

# Obtener token
def get_token(username, password):
    response = requests.post(
        f"{API_BASE_URL}/auth/login",
        json={"username": username, "password": password}
    )
    return response.json()["token"]

# Crear ruta
def create_route(token, route_data):
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.post(
        f"{API_BASE_URL}/routes",
        headers=headers,
        json=route_data
    )
    return response.status_code == 204

# Agregar cliente a ruta
def add_cliente_to_route(token, route_id, cliente_data):
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.post(
        f"{API_BASE_URL}/routes/{route_id}/clientes",
        headers=headers,
        json=cliente_data
    )
    return response.json()

# Uso
token = get_token("usuario123", "password123")

nueva_ruta = {
    "nombre": "Ruta Norte - Febrero 2024",
    "descripcion": "Cobranza mensual",
    "fecha": "2024-02-15",
    "tipo": "COBRANZA",
    "actividad": "Visita de campo",
    "user_id": 1,
    "asesor_id": 5,
    "agencia_id": 2
}

create_route(token, nueva_ruta)

cliente = {
    "persona_id": 123,
    "comentario": "Primera visita",
    "ubicacion_latitud": -12.046374,
    "ubicacion_longitud": -77.042793
}

add_cliente_to_route(token, 1, cliente)
```

### Ejemplo 3: Gestión de Seguimientos (TypeScript)

```typescript
interface Seguimiento {
    tipo_visita: string;
    ruta_id?: number;
    cliente_id?: number;
    nombre_cliente?: string;
    fecha_programada?: string;
    observaciones?: string;
}

class SeguimientosAPI {
    private baseUrl: string;
    private token: string;

    constructor(baseUrl: string, token: string) {
        this.baseUrl = baseUrl;
        this.token = token;
    }

    private get headers() {
        return {
            "Authorization": `Bearer ${this.token}`,
            "Content-Type": "application/json"
        };
    }

    async listar(filtros?: { ruta_id?: number; estado?: string }) {
        const params = new URLSearchParams(filtros as any);
        const response = await fetch(
            `${this.baseUrl}/seguimientos?${params}`,
            { headers: this.headers }
        );
        return await response.json();
    }

    async crear(seguimiento: Seguimiento) {
        const response = await fetch(`${this.baseUrl}/seguimientos`, {
            method: "POST",
            headers: this.headers,
            body: JSON.stringify(seguimiento)
        });
        return await response.json();
    }

    async completar(id: number, data: { observaciones?: string; monto_recaudado?: number }) {
        const response = await fetch(
            `${this.baseUrl}/seguimientos/${id}/complete`,
            {
                method: "POST",
                headers: this.headers,
                body: JSON.stringify(data)
            }
        );
        return await response.json();
    }
}

// Uso
const api = new SeguimientosAPI("https://your-api-gateway-url", "your-token");

const nuevoSeguimiento = {
    tipo_visita: "COBRANZA",
    ruta_id: 1,
    cliente_id: 123,
    nombre_cliente: "Juan Pérez",
    fecha_programada: "2024-01-25T10:00:00",
    observaciones: "Cobro mensual"
};

await api.crear(nuevoSeguimiento);

await api.completar(1, {
    observaciones: "Pago recibido",
    monto_recaudado: 500.00
});
```

---

## Variables de Entorno

El backend requiere las siguientes variables de entorno:

| Variable | Descripción |
|----------|-------------|
| `JWT_SECRET` | Secret key para firmar tokens JWT |
| `FARGATE_URL` | URL del servicio de caché Fargate |
| `FARGATE_SECRET` | Secret para autenticación con Fargate |
| `ON_PREM_URL` | URL del sistema on-premise |
| `ON_PREM_SECRET` | Secret para comunicación on-premise |
| `EVIDENCE_BUCKET` | Nombre del bucket S3 para evidencias |
| `EVIDENCE_BASE_PATH` | Ruta base en S3 (default: "seguimientos") |
