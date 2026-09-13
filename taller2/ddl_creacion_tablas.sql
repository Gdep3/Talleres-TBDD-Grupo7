CREATE TABLE Equipamiento (
    Id_equipamiento SERIAL PRIMARY KEY,
    Nombre_equipamiento VARCHAR(100) NOT NULL,
    Tipo_equipacion VARCHAR(50) NOT NULL,
    Sala_ubicacion VARCHAR(50) NOT NULL
);

CREATE TABLE Plan (
    Id_plan INT PRIMARY KEY,
    Costo INT NOT NULL CHECK (Costo >= 0),
    Fecha_inicio DATE NOT NULL,
    Vigencia INT NOT NULL CHECK (Vigencia > 0)
);

CREATE TABLE Entrenador (
    RUT_entrenador VARCHAR(12) PRIMARY KEY,
    Nombre_entrenador VARCHAR(50) NOT NULL,
    Apellido_entrenador VARCHAR(50) NOT NULL,
    Especialidad VARCHAR(50) NOT NULL,
    Fecha_contratacion DATE NOT NULL
);

CREATE TABLE Socio (
    RUT_socio VARCHAR(12) PRIMARY KEY,
    Nombre_socio VARCHAR(50) NOT NULL,
    Apellido_socio VARCHAR(50) NOT NULL,
    Fecha_nacimiento_soc DATE NOT NULL,
    Email_socio VARCHAR(100) NOT NULL UNIQUE,
    Telefono_socio BIGINT NOT NULL,
    Id_plan INT NOT NULL,
    FOREIGN KEY (Id_plan) REFERENCES Plan(Id_plan) ON DELETE RESTRICT
);

CREATE TABLE Ejercicio (
    Id_ejercicio INT PRIMARY KEY,
    Nombre_ejercicio VARCHAR(50) NOT NULL,
    Grupo_muscular VARCHAR(50) NOT NULL,
    Series_recomendadas INT NOT NULL CHECK (Series_recomendadas > 0),
    Repeticiones INT NOT NULL CHECK (Repeticiones > 0),
    Id_equipamiento INT NOT NULL,
    FOREIGN KEY (Id_equipamiento) REFERENCES Equipamiento(Id_equipamiento) ON DELETE RESTRICT
);

CREATE TABLE Clase (
    Id_clase SERIAL PRIMARY KEY,
    Nombre_clase VARCHAR(50) NOT NULL,
    Horario_inicio VARCHAR(10) NOT NULL,
    Horario_fin VARCHAR(10) NOT NULL,
    Capacidad_maxima INT NOT NULL CHECK (Capacidad_maxima > 0),
    RUT_entrenador VARCHAR(12) NOT NULL,
    FOREIGN KEY (RUT_entrenador) REFERENCES Entrenador(RUT_entrenador) ON DELETE RESTRICT
);

CREATE TABLE Rutina (
    Id_rutina SERIAL PRIMARY KEY,
    Nombre_rutina VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NOT NULL,
    Duracion_estimada INT NOT NULL CHECK (Duracion_estimada > 0),
    Fec_creacion DATE NOT NULL,
    Nivel_dificultad VARCHAR(50) NOT NULL
);

CREATE TABLE RutinaPropia (
    Id_rutina INT PRIMARY KEY,
    Notas_personales TEXT,
    FOREIGN KEY (Id_rutina) REFERENCES Rutina(Id_rutina) ON DELETE CASCADE
);

CREATE TABLE PlanEntrenamiento (
    Id_rutina INT PRIMARY KEY,
    Nombre_plan VARCHAR(100) NOT NULL,
    Objetivo VARCHAR(100) NOT NULL,
    Duracion_semanas INT NOT NULL CHECK (Duracion_semanas > 0),
    RUT_entrenador VARCHAR(12) NOT NULL,
    RUT_socio VARCHAR(12) NOT NULL,
    FOREIGN KEY (Id_rutina) REFERENCES Rutina(Id_rutina) ON DELETE CASCADE,
    FOREIGN KEY (RUT_entrenador) REFERENCES Entrenador(RUT_entrenador) ON DELETE RESTRICT,
    FOREIGN KEY (RUT_socio) REFERENCES Socio(RUT_socio) ON DELETE CASCADE
);

CREATE TABLE SocioClase (
    RUT_socio VARCHAR(12) NOT NULL,
    Id_clase INT NOT NULL,
    PRIMARY KEY (RUT_socio, Id_clase),
    FOREIGN KEY (RUT_socio) REFERENCES Socio(RUT_socio) ON DELETE CASCADE,
    FOREIGN KEY (Id_clase) REFERENCES Clase(Id_clase) ON DELETE CASCADE
);

CREATE TABLE AyudaCon (
    RUT_entrenador VARCHAR(12) NOT NULL,
    Id_ejercicio INT NOT NULL,
    PRIMARY KEY (RUT_entrenador, Id_ejercicio),
    FOREIGN KEY (RUT_entrenador) REFERENCES Entrenador(RUT_entrenador) ON DELETE CASCADE,
    FOREIGN KEY (Id_ejercicio) REFERENCES Ejercicio(Id_ejercicio) ON DELETE CASCADE
);

CREATE TABLE RutinaEjercicio (
    Id_rutina INT NOT NULL,
    Id_ejercicio INT NOT NULL,
    PRIMARY KEY (Id_rutina, Id_ejercicio),
    FOREIGN KEY (Id_rutina) REFERENCES Rutina(Id_rutina) ON DELETE CASCADE,
    FOREIGN KEY (Id_ejercicio) REFERENCES Ejercicio(Id_ejercicio) ON DELETE CASCADE
);
