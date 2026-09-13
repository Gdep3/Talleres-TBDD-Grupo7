# Taller 3 — Consultas Básicas
## Sistema de Gestión de Gimnasio · Grupo 7

---

## Contexto del proyecto

La base de datos modela un gimnasio con socios, entrenadores, clases grupales, planes de membresía, rutinas y ejercicios. Las tablas principales son:

| Tabla | Descripción |
|---|---|
| `Equipamiento` | Material físico del gimnasio (pesas, máquinas, accesorios) |
| `Plan` | Planes de membresía con costo y vigencia |
| `Entrenador` | Entrenadores con especialidad y fecha de contratación |
| `Socio` | Miembros del gimnasio, cada uno asociado a un plan |
| `Ejercicio` | Ejercicios con grupo muscular y equipamiento requerido |
| `Clase` | Clases grupales con horario y entrenador asignado |
| `Rutina` | Rutinas con nivel de dificultad y duración estimada |
| `RutinaPropia` | Subclase de rutina creada por el propio socio (con notas) |
| `PlanEntrenamiento` | Subclase de rutina asignada por un entrenador a un socio |
| `SocioClase` | Relación N:M entre socios y clases |
| `AyudaCon` | Relación N:M entre entrenadores y ejercicios |
| `RutinaEjercicio` | Relación N:M entre rutinas y ejercicios |

---

## Consultas desarrolladas

### Consulta 1 — Socios cuyo nombre contiene la letra 'a'
**Técnicas:** `WHERE`, `ILIKE`, alias de columnas y tabla

**Descripción:** Recupera socios cuyo nombre contiene la letra 'a', sin importar mayúsculas o minúsculas. Útil para búsquedas rápidas en recepción cuando el operador no recuerda la escritura exacta del nombre.

```sql
SELECT 
    s.RUT_socio        AS "RUT",
    s.Nombre_socio     AS "Nombre",
    s.Apellido_socio   AS "Apellido",
    s.Email_socio      AS "Correo Electrónico"
FROM Socio s
WHERE s.Nombre_socio ILIKE '%a%';
```

---

### Consulta 2 — Ejercicios del grupo muscular 'Pecho' o 'Espalda'
**Técnicas:** `WHERE`, `LIKE`, alias de columnas y tabla

**Descripción:** Filtra los ejercicios orientados al tren superior (pecho y espalda). Permite al entrenador seleccionar rápidamente ejercicios para armar rutinas de torso.

```sql
SELECT 
    ej.Id_ejercicio        AS "ID Ejercicio",
    ej.Nombre_ejercicio    AS "Ejercicio",
    ej.Grupo_muscular      AS "Grupo Muscular",
    ej.Series_recomendadas AS "Series",
    ej.Repeticiones        AS "Repeticiones"
FROM Ejercicio ej
WHERE ej.Grupo_muscular LIKE 'Pecho'
   OR ej.Grupo_muscular LIKE 'Espalda';
```

---

### Consulta 3 — Entrenadores con especialidad en fuerza
**Técnicas:** `WHERE`, `ILIKE`, `ORDER BY`, alias de columnas y tabla

**Descripción:** Lista los entrenadores cuya especialidad está relacionada con "fuerza" (incluye "Fuerza" y "Powerlifting"), ordenados alfabéticamente por apellido. Facilita la asignación de entrenadores a planes de fuerza.

```sql
SELECT 
    e.RUT_entrenador        AS "RUT",
    e.Nombre_entrenador     AS "Nombre",
    e.Apellido_entrenador   AS "Apellido",
    e.Especialidad          AS "Especialidad",
    e.Fecha_contratacion    AS "Fecha Contratación"
FROM Entrenador e
WHERE e.Especialidad ILIKE '%fuerza%'
ORDER BY e.Apellido_entrenador ASC;
```

---

### Consulta 4 — Planes de 90 días ordenados por costo
**Técnicas:** `WHERE`, `ORDER BY`, alias de columnas y tabla

**Descripción:** Muestra todos los planes de membresía trimestrales (90 días de vigencia), ordenados de mayor a menor costo. Útil para el área comercial al ofrecer opciones de largo plazo.

```sql
SELECT 
    p.Id_plan       AS "ID Plan",
    p.Costo         AS "Costo (CLP)",
    p.Fecha_inicio  AS "Fecha Inicio",
    p.Vigencia      AS "Días de Vigencia"
FROM Plan p
WHERE p.Vigencia = 90
ORDER BY p.Costo DESC;
```

---

### Consulta 5 — Rutinas avanzadas de más de 60 minutos
**Técnicas:** `WHERE`, alias de columnas y tabla

**Descripción:** Filtra rutinas de nivel 'Avanzado' con una duración estimada superior a 60 minutos. Permite identificar las sesiones más exigentes para asignarlas solo a usuarios con experiencia suficiente.

```sql
SELECT 
    r.Id_rutina          AS "ID Rutina",
    r.Nombre_rutina      AS "Nombre Rutina",
    r.Descripcion        AS "Descripción",
    r.Duracion_estimada  AS "Duración (min)",
    r.Nivel_dificultad   AS "Nivel"
FROM Rutina r
WHERE r.Nivel_dificultad = 'Avanzado'
  AND r.Duracion_estimada > 60;
```

---

### Consulta 6 — Clases con gran capacidad, ordenadas por horario
**Técnicas:** `WHERE`, `ORDER BY`, alias de columnas y tabla

**Descripción:** Lista las clases grupales con capacidad máxima de 20 o más personas, ordenadas cronológicamente. Permite organizar los horarios del gimnasio priorizando las clases más concurridas.

```sql
SELECT 
    c.Id_clase          AS "ID Clase",
    c.Nombre_clase      AS "Nombre Clase",
    c.Horario_inicio    AS "Hora Inicio",
    c.Horario_fin       AS "Hora Fin",
    c.Capacidad_maxima  AS "Capacidad Máxima"
FROM Clase c
WHERE c.Capacidad_maxima >= 20
ORDER BY c.Horario_inicio ASC;
```

---

### Consulta 7 — Socios inscritos en clases de alta intensidad
**Técnicas:** `WHERE`, `ILIKE`, `INNER JOIN` (3 tablas), alias, `ORDER BY`

**Descripción:** Obtiene los socios que asisten a clases de Spinning o CrossFit. Permite segmentar usuarios de alta intensidad para ofrecerles planes o suplementación específica.

```sql
SELECT DISTINCT
    s.Nombre_socio   AS "Nombre",
    s.Apellido_socio AS "Apellido",
    s.Email_socio    AS "Correo"
FROM Socio s
INNER JOIN SocioClase sc ON s.RUT_socio = sc.RUT_socio
INNER JOIN Clase c ON sc.Id_clase = c.Id_clase
WHERE c.Nombre_clase ILIKE '%spinning%'
   OR c.Nombre_clase ILIKE '%crossfit%'
ORDER BY s.Apellido_socio ASC;
```

---

### Consulta 8 — Socios con información de su plan de membresía
**Técnicas:** `INNER JOIN` (2 tablas), alias de columnas y tablas

**Descripción:** Relaciona cada socio con el plan de membresía que tiene contratado, mostrando el costo y la vigencia. Permite verificar qué beneficios corresponden a cada usuario.

```sql
SELECT 
    s.RUT_socio      AS "RUT Socio",
    s.Nombre_socio   AS "Nombre",
    s.Apellido_socio AS "Apellido",
    p.Id_plan        AS "ID Plan",
    p.Costo          AS "Costo (CLP)",
    p.Vigencia       AS "Días Vigencia"
FROM Socio s
INNER JOIN Plan p ON s.Id_plan = p.Id_plan;
```

---

### Consulta 9 — Clases con el nombre completo de su entrenador
**Técnicas:** `INNER JOIN` (2 tablas), alias de columnas y tablas, concatenación

**Descripción:** Muestra todas las clases junto con el nombre completo y especialidad del entrenador responsable. Facilita la publicación de horarios para los socios.

```sql
SELECT 
    c.Id_clase                                                    AS "ID Clase",
    c.Nombre_clase                                                AS "Clase",
    c.Horario_inicio                                              AS "Inicio",
    c.Horario_fin                                                 AS "Fin",
    e.Nombre_entrenador || ' ' || e.Apellido_entrenador           AS "Entrenador",
    e.Especialidad                                                AS "Especialidad"
FROM Clase c
INNER JOIN Entrenador e ON c.RUT_entrenador = e.RUT_entrenador;
```

---

### Consulta 10 — Equipamiento y sus ejercicios asociados
**Técnicas:** `LEFT JOIN` (2 tablas), alias de columnas y tablas

**Descripción:** Lista todo el equipamiento del gimnasio y los ejercicios que lo utilizan. El uso de `LEFT JOIN` permite incluir equipamiento que aún no tiene ningún ejercicio asignado, lo que ayuda a detectar material sin uso.

```sql
SELECT 
    eq.Id_equipamiento      AS "ID Equipo",
    eq.Nombre_equipamiento  AS "Equipamiento",
    eq.Tipo_equipacion      AS "Tipo",
    eq.Sala_ubicacion       AS "Sala",
    ej.Nombre_ejercicio     AS "Ejercicio Asociado"
FROM Equipamiento eq
LEFT JOIN Ejercicio ej ON eq.Id_equipamiento = ej.Id_equipamiento;
```

---

### Consulta 11 — Entrenadores y sus planes de entrenamiento asignados
**Técnicas:** `RIGHT JOIN` (2 tablas), alias de columnas y tablas, `ORDER BY`

**Descripción:** Lista todos los entrenadores junto a los planes de entrenamiento que tienen asignados. El `RIGHT JOIN` garantiza que aparezcan todos los entrenadores, incluso aquellos sin planes asignados actualmente, revelando capacidad disponible.

```sql
SELECT 
    e.Nombre_entrenador || ' ' || e.Apellido_entrenador  AS "Entrenador",
    e.Especialidad                                        AS "Especialidad",
    pe.Nombre_plan                                        AS "Plan Asignado",
    pe.Objetivo                                           AS "Objetivo"
FROM PlanEntrenamiento pe
RIGHT JOIN Entrenador e ON pe.RUT_entrenador = e.RUT_entrenador
ORDER BY e.Apellido_entrenador ASC;
```

---

### Consulta 12 — Socios, clases que asisten y entrenador a cargo *(4 tablas)*
**Técnicas:** `INNER JOIN` (4 tablas), alias de columnas y tablas

**Descripción:** Muestra la relación completa entre socios, sus clases inscritas y el entrenador de cada clase. Reúne cuatro tablas: `Socio`, `SocioClase`, `Clase` y `Entrenador`. Útil para auditorías de inscripciones y control de asistencia.

```sql
SELECT 
    s.Nombre_socio || ' ' || s.Apellido_socio            AS "Socio",
    c.Nombre_clase                                        AS "Clase",
    c.Horario_inicio                                      AS "Hora Inicio",
    c.Horario_fin                                         AS "Hora Fin",
    e.Nombre_entrenador || ' ' || e.Apellido_entrenador   AS "Entrenador",
    e.Especialidad                                        AS "Especialidad"
FROM Socio s
INNER JOIN SocioClase sc ON s.RUT_socio = sc.RUT_socio
INNER JOIN Clase c ON sc.Id_clase = c.Id_clase
INNER JOIN Entrenador e ON c.RUT_entrenador = e.RUT_entrenador;
```

---

### Consulta 13 — Planes de entrenamiento personalizados completos *(4 tablas)*
**Técnicas:** `INNER JOIN` (4 tablas), alias de columnas y tablas

**Descripción:** Presenta una visión integral de cada plan de entrenamiento personalizado: el socio que lo sigue, el entrenador que lo diseñó, la rutina base y su nivel de dificultad. Reúne `PlanEntrenamiento`, `Socio`, `Entrenador` y `Rutina`. Esencial para la gestión de seguimiento individual.

```sql
SELECT 
    s.Nombre_socio || ' ' || s.Apellido_socio            AS "Socio",
    pe.Nombre_plan                                        AS "Plan Entrenamiento",
    pe.Objetivo                                           AS "Objetivo",
    pe.Duracion_semanas                                   AS "Duración (semanas)",
    e.Nombre_entrenador || ' ' || e.Apellido_entrenador   AS "Entrenador",
    r.Nombre_rutina                                       AS "Rutina",
    r.Nivel_dificultad                                    AS "Nivel"
FROM PlanEntrenamiento pe
INNER JOIN Socio s ON pe.RUT_socio = s.RUT_socio
INNER JOIN Entrenador e ON pe.RUT_entrenador = e.RUT_entrenador
INNER JOIN Rutina r ON pe.Id_rutina = r.Id_rutina;
```

---

### Consulta 14 — Rutinas con sus ejercicios y el equipamiento requerido *(4 tablas)*
**Técnicas:** `INNER JOIN` (4 tablas), alias de columnas y tablas, `ORDER BY`

**Descripción:** Detalla cada rutina junto a los ejercicios que la componen y el equipamiento necesario para realizarlos. Reúne `Rutina`, `RutinaEjercicio`, `Ejercicio` y `Equipamiento`. Permite planificar la disponibilidad de material antes de una sesión.

```sql
SELECT 
    r.Nombre_rutina        AS "Rutina",
    r.Nivel_dificultad     AS "Nivel",
    ej.Nombre_ejercicio    AS "Ejercicio",
    ej.Grupo_muscular      AS "Músculo",
    eq.Nombre_equipamiento AS "Equipamiento",
    eq.Sala_ubicacion      AS "Sala"
FROM Rutina r
INNER JOIN RutinaEjercicio re ON r.Id_rutina = re.Id_rutina
INNER JOIN Ejercicio ej ON re.Id_ejercicio = ej.Id_ejercicio
INNER JOIN Equipamiento eq ON ej.Id_equipamiento = eq.Id_equipamiento
ORDER BY r.Nombre_rutina ASC, ej.Nombre_ejercicio ASC;
```

---

### Consulta 15 — Planes de entrenamiento orientados a la fuerza
**Técnicas:** `INNER JOIN` (3 tablas), `WHERE`, `ILIKE`, alias de columnas y tablas

**Descripción:** Filtra los planes de entrenamiento personalizados cuyo objetivo menciona la palabra "fuerza". Permite al área de análisis conocer la demanda de este tipo de entrenamiento y asignar entrenadores especializados.

```sql
SELECT 
    s.Nombre_socio || ' ' || s.Apellido_socio            AS "Socio",
    pe.Nombre_plan                                        AS "Plan",
    pe.Objetivo                                           AS "Objetivo",
    pe.Duracion_semanas                                   AS "Semanas",
    e.Nombre_entrenador || ' ' || e.Apellido_entrenador   AS "Entrenador"
FROM PlanEntrenamiento pe
INNER JOIN Socio s ON pe.RUT_socio = s.RUT_socio
INNER JOIN Entrenador e ON pe.RUT_entrenador = e.RUT_entrenador
WHERE pe.Objetivo ILIKE '%fuerza%';
```

---

### Consulta 16 — Socios sin clases inscritas *(BONUS)*
**Técnicas:** `LEFT JOIN`, `WHERE` con `IS NULL`, `ORDER BY`, alias de columnas y tabla

**Descripción:** Identifica socios que no están inscritos en ninguna clase grupal. Esta consulta es de valor para el área de retención, ya que permite contactar a socios con baja participación y ofrecerles clases adecuadas a su perfil.

```sql
SELECT 
    s.RUT_socio      AS "RUT",
    s.Nombre_socio   AS "Nombre",
    s.Apellido_socio AS "Apellido",
    s.Email_socio    AS "Correo"
FROM Socio s
LEFT JOIN SocioClase sc ON s.RUT_socio = sc.RUT_socio
WHERE sc.Id_clase IS NULL
ORDER BY s.Apellido_socio ASC;
```

---

## Resumen de cobertura de requisitos

| Requisito | Mínimo | Consultas que lo cubren |
|---|---|---|
| Total de consultas | 12 | **16** (1–16) |
| `WHERE` | 6 | **9** (1, 2, 3, 4, 5, 6, 7, 15, 16) |
| `LIKE` o `ILIKE` | 3 | **5** (1, 2, 3, 7, 15) |
| `ORDER BY` | 3 | **5** (3, 4, 6, 11, 14) |
| Alias columnas/tablas | 6 | **Todas** (1–16) |
| `JOIN` en total | 6 | **9** (7–16) |
| Tipos distintos de `JOIN` | 3 | `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` |
| `JOIN` con 4+ tablas | 2 | **3** (12, 13, 14) |
