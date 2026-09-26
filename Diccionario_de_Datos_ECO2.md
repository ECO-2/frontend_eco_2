# Diccionario de Datos — ECO2

> Última actualización: junio 2026 · Sincronizado con el ERD vigente.

---

## Índice

**Auth y Plantas**
- [users](#users)
- [sessions](#sessions)
- [plans](#plans)
- [user_subscriptions](#user_subscriptions)
- [plant_species](#plant_species)
- [user_plants](#user_plants)
- [user_plant_tasks](#user_plant_tasks)
- [care_logs](#care_logs)

**Gamificación y Economía**
- [user_progress](#user_progress)
- [xp_logs](#xp_logs)
- [seed_transactions](#seed_transactions)
- [achievements](#achievements)
- [user_achievements](#user_achievements)
- [co2_logs](#co2_logs)
- [store_items](#store_items)

**Ambiente · IA · Notificaciones**
- [rooms](#rooms)
- [room_plants](#room_plants)
- [environment_snapshots](#environment_snapshots)
- [environmental_scores](#environmental_scores)
- [snapshot_scores](#snapshot_scores)
- [plant_identifications](#plant_identifications)
- [notifications](#notifications)

---

## Auth y Plantas

### users

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único del usuario. |
| email | varchar | 255 caracteres | | Correo electrónico del usuario (único). |
| username | varchar | 50 caracteres | | Nombre de usuario. |
| avatar_url | text | Variable (Ilimitado) | | URL de la imagen de perfil. |
| password_hash | text | Variable (Ilimitado) | | Hash de la contraseña. |
| provider | varchar | 50 caracteres | | Proveedor de autenticación (ej. local, google). |
| mfa_enabled | boolean | 1 byte | | Indica si la autenticación multifactor está activa. |
| plan_type | varchar | 50 caracteres | | Tipo de plan actual del usuario. |
| gender | enum | 1-2 bytes | | Género del usuario (ej. male, female, other). |
| birth_day | timestamp | 8 bytes | | Fecha de nacimiento del usuario. |
| role | varchar | 50 caracteres | | Rol del usuario en el sistema. |
| reset_token_hash | text | Variable (Ilimitado) | | Token para restablecer contraseña. |
| created_at | timestamp | 8 bytes | | Fecha y hora de registro. |
| updated_at | timestamp | 8 bytes | | Fecha y hora de la última actualización. |
| deleted_at | timestamp | 8 bytes | | Fecha y hora de eliminación lógica. |

---

### sessions

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único de la sesión. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| refresh_token_hash | text | Variable (Ilimitado) | | Token de actualización de sesión. |
| expires_at | timestamp | 8 bytes | | Fecha y hora de expiración de la sesión. |
| revoked_at | timestamp | 8 bytes | | Fecha y hora si la sesión fue revocada. |
| created_at | timestamp | 8 bytes | | Fecha y hora de inicio de sesión. |

---

### plans

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único del plan. |
| name | varchar | 50 caracteres | | Nombre interno del plan. |
| display_name | varchar | 100 caracteres | | Nombre público del plan. |
| payment_frequency | int | 4 bytes | | Frecuencia de pago en días (ej. 30 = mensual, 365 = anual). |
| price | numeric | (10, 2) | | Precio del plan según la frecuencia de pago. |
| plant_limit | int | 4 bytes | | Límite de plantas permitidas. |
| ai_scans_monthly | int | 4 bytes | | Límite de escaneos IA mensuales. |
| has_co2_tracking | boolean | 1 byte | | Si incluye seguimiento de CO2. |
| has_advanced_stats | boolean | 1 byte | | Si incluye estadísticas avanzadas. |
| active | boolean | 1 byte | | Indica si el plan está disponible. |
| created_at | timestamp | 8 bytes | | Fecha de creación del registro. |

---

### user_subscriptions

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único de la suscripción. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| plan_id | uuid | 16 bytes | FK | Referencia al plan (plans.id). |
| status | varchar | 50 caracteres | | Estado de la suscripción. |
| started_at | timestamp | 8 bytes | | Fecha de inicio. |
| expires_at | timestamp | 8 bytes | | Fecha de vencimiento. |
| cancelled_at | timestamp | 8 bytes | | Fecha de cancelación. |

---

### plant_species

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único de la especie. |
| scientific_name | varchar | 150 caracteres | | Nombre científico. |
| common_name | varchar | 150 caracteres | | Nombre coloquial. |
| category | enum | — | | Categoría botánica. |
| light_requirement | enum | — | | Requerimientos de luz. |
| water_frequency_days | int | 4 bytes | | Días entre cada riego sugerido. |
| humidity_preference | enum | — | | Preferencia de humedad. |
| air_purification_score | int | 4 bytes | | Puntuación de purificación de aire. |
| min_temperature | int | 4 bytes | | Temperatura mínima tolerable (°C). |
| max_temperature | int | 4 bytes | | Temperatura máxima tolerable (°C). |
| created_at | timestamp | 8 bytes | | Fecha de registro en la base de datos. |

---

### user_plants

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único de la planta del usuario. |
| user_id | uuid | 16 bytes | FK | Referencia al dueño (users.id). |
| species_id | uuid | 16 bytes | FK | Referencia a la especie (plant_species.id). |
| nickname | varchar | 100 caracteres | | Apodo dado por el usuario. |
| health_status | enum | — | | Estado de salud actual. |
| acquired_at | timestamp | 8 bytes | | Fecha de adquisición. |
| last_watered_at | timestamp | 8 bytes | | Fecha del último riego. |
| created_at | timestamp | 8 bytes | | Fecha de registro en el sistema. |
| updated_at | timestamp | 8 bytes | | Última modificación de los datos. |
| deleted_at | timestamp | 8 bytes | | Eliminación lógica de la planta. |

---

### user_plant_tasks

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador de la tarea. |
| user_plant_id | uuid | 16 bytes | FK | Referencia a la planta (user_plants.id). |
| task_type | varchar | 50 caracteres | | Tipo de tarea (ej. riego, poda). |
| next_due_at | timestamp | 8 bytes | | Próxima fecha de vencimiento. |
| last_completed_at | timestamp | 8 bytes | | Fecha en que se completó por última vez. |
| frequency_days | int | 4 bytes | | Frecuencia en días de la tarea. |

---

### care_logs

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador del registro. |
| user_plant_id | uuid | 16 bytes | FK | Referencia a la planta (user_plants.id). |
| task_type | varchar | 50 caracteres | | Tipo de tarea realizada. |
| performed_at | timestamp | 8 bytes | | Fecha y hora exacta de la acción. |

---

## Gamificación y Economía

### user_progress

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| user_id | uuid | 16 bytes | PK, FK | Referencia al usuario (users.id). |
| xp | int | 4 bytes | | Puntos de experiencia acumulados. |
| level | int | 4 bytes | | Nivel actual del usuario. |
| streak_days | int | 4 bytes | | Racha de días consecutivos. |
| seeds | int | 4 bytes | | Moneda virtual disponible. |
| updated_at | timestamp | 8 bytes | | Fecha de última actualización. |

---

### xp_logs

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador del registro. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| action_type | varchar | 100 caracteres | | Acción que generó la experiencia. |
| xp_earned | int | 4 bytes | | Cantidad de experiencia obtenida. |
| created_at | timestamp | 8 bytes | | Fecha y hora de la obtención. |

---

### seed_transactions

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador de la transacción. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| amount | int | 4 bytes | | Cantidad de semillas (+ o −). |
| reason | varchar | 150 caracteres | | Motivo de la transacción. |
| created_at | timestamp | 8 bytes | | Fecha de la transacción. |

---

### achievements

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador del logro. |
| name | varchar | 100 caracteres | | Nombre del logro. |
| condition_type | varchar | 50 caracteres | | Tipo de métrica a evaluar. |
| condition_value | int | 4 bytes | | Valor requerido para desbloquear. |
| xp_reward | int | 4 bytes | | Recompensa en XP. |
| description | text | Variable (Ilimitado) | | Descripción detallada. |

---

### user_achievements

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único del desbloqueo. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| achievement_id | uuid | 16 bytes | FK | Referencia al logro (achievements.id). |
| unlocked_at | timestamp | 8 bytes | | Fecha en que se desbloqueó. |

---

### co2_logs

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador del registro. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| date | date | 4 bytes | | Fecha de la métrica. |
| co2_grams | float | 8 bytes (Double) | | Gramos de CO2 contabilizados. |
| created_at | timestamp | 8 bytes | | Marca de tiempo del registro. |

---

### store_items

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador del artículo. |
| name | varchar | 100 caracteres | | Nombre del artículo. |
| seed_cost | int | 4 bytes | | Precio en semillas. |
| item_type | varchar | 50 caracteres | | Tipo de artículo. |
| active | boolean | 1 byte | | Disponibilidad en la tienda. |

---

## Ambiente · IA · Notificaciones

### rooms

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador de la habitación. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| name | varchar | 100 caracteres | | Nombre de la habitación. |
| size_m2 | numeric | (6, 2) | | Tamaño en metros cuadrados. |
| light_level | varchar | 50 caracteres | | Nivel de iluminación general percibido. |
| created_at | timestamp | 8 bytes | | Fecha de creación. |
| deleted_at | timestamp | 8 bytes | | Eliminación lógica. |

---

### room_plants

Tabla de relación muchos a muchos entre `rooms` y `user_plants`.

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| room_id | uuid | 16 bytes | PK, FK | Referencia a la habitación (rooms.id). |
| user_plant_id | uuid | 16 bytes | PK, FK | Referencia a la planta (user_plants.id). |

---

### environment_snapshots

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador de la medición. |
| room_id | uuid | 16 bytes | FK | Referencia a la habitación (rooms.id). |
| temperature | float | 8 bytes (Double) | | Temperatura registrada. |
| humidity | float | 8 bytes (Double) | | Humedad registrada. |
| co2_level | float | 8 bytes (Double) | | Nivel de CO2 registrado. |
| created_at | timestamp | 8 bytes | | Fecha y hora de la captura. |

---

### environmental_scores

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador de la evaluación. |
| room_id | uuid | 16 bytes | FK | Referencia a la habitación (rooms.id). |
| score | float | 8 bytes (Double) | | Calificación ambiental obtenida. |
| calculated_at | timestamp | 8 bytes | | Momento del cálculo. |

---

### snapshot_scores

Tabla de relación entre `environment_snapshots` y `environmental_scores`.

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador único del registro. |
| snapshot_id | uuid | 16 bytes | FK | Referencia al snapshot ambiental (environment_snapshots.id). |
| score_id | uuid | 16 bytes | FK | Referencia a la puntuación ambiental (environmental_scores.id). |

---

### plant_identifications

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador del escaneo. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario (users.id). |
| image_url | text | Variable (Ilimitado) | | Enlace a la imagen subida. |
| identified_species_id | uuid | 16 bytes | FK | Especie detectada por la IA (plant_species.id). |
| confidence_score | float | 8 bytes (Double) | | Nivel de confianza de la predicción. |
| created_at | timestamp | 8 bytes | | Momento del análisis. |

---

### notifications

| Campo | Tipo de Dato | Longitud / Tamaño | Llaves | Descripción |
|---|---|---|---|---|
| id | uuid | 16 bytes | PK | Identificador de la notificación. |
| user_id | uuid | 16 bytes | FK | Referencia al usuario receptor (users.id). |
| type | varchar | 50 caracteres | | Tipo de alerta (ej. riego, sistema). |
| title | varchar | 255 caracteres | | Título del mensaje. |
| reference_id | uuid | 16 bytes | | ID genérico para relacionar entidades. |
| read_at | timestamp | 8 bytes | | Fecha y hora en que fue leída. |
| sent_at | timestamp | 8 bytes | | Fecha y hora en que fue enviada. |
