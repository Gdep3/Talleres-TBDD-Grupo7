-- ============================================================
-- Taller 3 - Consultas Básicas
-- Taller de Base de Datos - Grupo 7
-- Base de datos: Sistema de Gestión de Gimnasio
-- ============================================================

-- ============================================================
-- CONSULTAS CON WHERE (incluyendo LIKE e ILIKE)
-- ============================================================

-- Consulta 1: Socios cuyo nombre contiene la letra 'a' (sin distinción de mayúsculas)
-- Permite buscar socios de forma flexible por nombre, útil para recepción.
SELECT
    s.RUT_socio        AS "RUT",
    s.Nombre_socio     AS "Nombre",
    s.Apellido_socio   AS "Apellido",
    s.Email_socio      AS "Correo Electrónico"
FROM Socio s
WHERE s.Nombre_socio ILIKE '%a%';

-- ============================================================

-- Consulta 2: Ejercicios del grupo muscular 'Pecho' o 'Espalda'
-- Útil para armar rutinas orientadas al tren superior.
SELECT
    ej.Id_ejercicio        AS "ID Ejercicio",
    ej.Nombre_ejercicio    AS "Ejercicio",
    ej.Grupo_muscular      AS "Grupo Muscular",
    ej.Series_recomendadas AS "Series",
    ej.Repeticiones        AS "Repeticiones"
FROM Ejercicio ej
WHERE ej.Grupo_muscular LIKE 'Pecho'
   OR ej.Grupo_muscular LIKE 'Espalda';

-- ============================================================

-- Consulta 3: Entrenadores con especialidad relacionada a 'fuerza', ordenados por apellido
-- Facilita encontrar entrenadores para asignar planes de fuerza.
SELECT
    e.RUT_entrenador        AS "RUT",
    e.Nombre_entrenador     AS "Nombre",
    e.Apellido_entrenador   AS "Apellido",
    e.Especialidad          AS "Especialidad",
    e.Fecha_contratacion    AS "Fecha Contratación"
FROM Entrenador e
WHERE e.Especialidad ILIKE '%fuerza%'
ORDER BY e.Apellido_entrenador ASC;

-- ============================================================

-- Consulta 4: Planes de membresía de 90 días de vigencia, ordenados por costo descendente
-- Permite identificar los planes trimestrales y su rango de precios.
SELECT
    p.Id_plan       AS "ID Plan",
    p.Costo         AS "Costo (CLP)",
    p.Fecha_inicio  AS "Fecha Inicio",
    p.Vigencia      AS "Días de Vigencia"
FROM Plan p
WHERE p.Vigencia = 90
ORDER BY p.Costo DESC;

-- ============================================================

-- Consulta 5: Rutinas de nivel 'Avanzado' con duración mayor a 60 minutos
-- Filtra las rutinas más exigentes y largas para usuarios de alto rendimiento.
SELECT
    r.Id_rutina          AS "ID Rutina",
    r.Nombre_rutina      AS "Nombre Rutina",
    r.Descripcion        AS "Descripción",
    r.Duracion_estimada  AS "Duración (min)",
    r.Nivel_dificultad   AS "Nivel"
FROM Rutina r
WHERE r.Nivel_dificultad = 'Avanzado'
  AND r.Duracion_estimada > 60;

-- ============================================================

-- Consulta 6: Clases con capacidad máxima mayor o igual a 20, ordenadas por horario de inicio
-- Muestra las clases con mayor aforo disponible para planificación de horarios.
SELECT
    c.Id_clase          AS "ID Clase",
    c.Nombre_clase      AS "Nombre Clase",
    c.Horario_inicio    AS "Hora Inicio",
    c.Horario_fin       AS "Hora Fin",
    c.Capacidad_maxima  AS "Capacidad Máxima"
FROM Clase c
WHERE c.Capacidad_maxima >= 20
ORDER BY c.Horario_inicio ASC;

-- ============================================================

-- Consulta 7: Socios con nombre de clase que contenga 'Spinning' o 'CrossFit'
-- Busca socios inscritos en clases de alta intensidad.
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

-- ============================================================
-- CONSULTAS CON JOIN
-- ============================================================

-- Consulta 8: Socios con la información de su plan de membresía (INNER JOIN)
-- Relaciona cada socio con el plan que tiene contratado.
SELECT
    s.RUT_socio      AS "RUT Socio",
    s.Nombre_socio   AS "Nombre",
    s.Apellido_socio AS "Apellido",
    p.Id_plan        AS "ID Plan",
    p.Costo          AS "Costo (CLP)",
    p.Vigencia       AS "Días Vigencia"
FROM Socio s
INNER JOIN Plan p ON s.Id_plan = p.Id_plan;

-- ============================================================

-- Consulta 9: Clases con el nombre completo de su entrenador asignado (INNER JOIN)
-- Muestra el responsable de cada clase para facilitar la gestión de horarios.
SELECT
    c.Id_clase                                                    AS "ID Clase",
    c.Nombre_clase                                                AS "Clase",
    c.Horario_inicio                                              AS "Inicio",
    c.Horario_fin                                                 AS "Fin",
    e.Nombre_entrenador || ' ' || e.Apellido_entrenador           AS "Entrenador",
    e.Especialidad                                                AS "Especialidad"
FROM Clase c
INNER JOIN Entrenador e ON c.RUT_entrenador = e.RUT_entrenador;

-- ============================================================

-- Consulta 10: Todo el equipamiento y los ejercicios que lo utilizan (LEFT JOIN)
-- Incluye equipamiento sin ejercicio asignado para detectar material sin uso.
SELECT
    eq.Id_equipamiento      AS "ID Equipo",
    eq.Nombre_equipamiento  AS "Equipamiento",
    eq.Tipo_equipacion      AS "Tipo",
    eq.Sala_ubicacion       AS "Sala",
    ej.Nombre_ejercicio     AS "Ejercicio Asociado"
FROM Equipamiento eq
LEFT JOIN Ejercicio ej ON eq.Id_equipamiento = ej.Id_equipamiento;

-- ============================================================

-- Consulta 11: Todos los entrenadores y los planes de entrenamiento que tienen asignados (RIGHT JOIN)
-- Muestra entrenadores sin planes asignados, útil para detectar capacidad ociosa.
SELECT
    e.Nombre_entrenador || ' ' || e.Apellido_entrenador  AS "Entrenador",
    e.Especialidad                                        AS "Especialidad",
    pe.Nombre_plan                                        AS "Plan Asignado",
    pe.Objetivo                                           AS "Objetivo"
FROM PlanEntrenamiento pe
RIGHT JOIN Entrenador e ON pe.RUT_entrenador = e.RUT_entrenador
ORDER BY e.Apellido_entrenador ASC;

-- ============================================================

-- Consulta 12: Socios con las clases que asisten y su entrenador (INNER JOIN - 4 tablas)
-- Permite ver la relación completa: socio → clase → entrenador.
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

-- ============================================================

-- Consulta 13: Planes de entrenamiento con socio, entrenador y rutina asignada (INNER JOIN - 4 tablas)
-- Visión global de cada plan personalizado: quién lo hace, quién lo diseñó y qué rutina usa.
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

-- ============================================================

-- Consulta 14: Rutinas con sus ejercicios y el equipamiento requerido (INNER JOIN - 4 tablas)
-- Permite planificar qué materiales se necesitan para ejecutar cada rutina.
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

-- ============================================================

-- Consulta 15: Planes de entrenamiento cuyo objetivo está relacionado con 'fuerza'
-- Filtra planes personalizados orientados a fuerza para análisis de demanda.
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

-- ============================================================

-- Consulta 16 (BONUS): Socios que no están inscritos en ninguna clase (LEFT JOIN + WHERE NULL)
-- Detecta socios sin participación en clases grupales para incentivar inscripciones.
SELECT
    s.RUT_socio      AS "RUT",
    s.Nombre_socio   AS "Nombre",
    s.Apellido_socio AS "Apellido",
    s.Email_socio    AS "Correo"
FROM Socio s
LEFT JOIN SocioClase sc ON s.RUT_socio = sc.RUT_socio
WHERE sc.Id_clase IS NULL
ORDER BY s.Apellido_socio ASC;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
