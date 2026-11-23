-- =====================================================================
-- LABORATORIO DE ÁLGEBRA RELACIONAL — Fútbol: LIGA, EQUIPO y JUGADOR
-- Bases de Datos 1 · Universidad El Bosque
-- Autor: Juan David Polo Herrera
-- Motor: Oracle Database (script para Oracle SQL Developer)
-- Todos los datos son de ejemplo (los jugadores son ficticios).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. Limpieza (opcional, para poder volver a ejecutar el script)
-- ---------------------------------------------------------------------
-- DROP TABLE jugador;
-- DROP TABLE equipo;
-- DROP TABLE liga;

-- ---------------------------------------------------------------------
-- 1. CREACIÓN DE TABLAS (3 tablas interrelacionadas)
--    LIGA (1) ──< EQUIPO (1) ──< JUGADOR
-- ---------------------------------------------------------------------
CREATE TABLE liga (
    id_liga          NUMBER(3)      NOT NULL,
    nombre           VARCHAR2(60)   NOT NULL,
    pais             VARCHAR2(40)   NOT NULL,
    anio_fundacion   NUMBER(4)      NOT NULL,
    CONSTRAINT pk_liga        PRIMARY KEY (id_liga),
    CONSTRAINT uq_liga_nombre UNIQUE (nombre),
    CONSTRAINT ck_liga_anio   CHECK (anio_fundacion BETWEEN 1850 AND 2100)
);

CREATE TABLE equipo (
    id_equipo        NUMBER(4)      NOT NULL,
    nombre           VARCHAR2(60)   NOT NULL,
    ciudad           VARCHAR2(40)   NOT NULL,
    estadio          VARCHAR2(60),
    anio_fundacion   NUMBER(4)      NOT NULL,
    id_liga          NUMBER(3)      NOT NULL,
    CONSTRAINT pk_equipo      PRIMARY KEY (id_equipo),
    CONSTRAINT uq_equipo_nom  UNIQUE (nombre),
    CONSTRAINT fk_equipo_liga FOREIGN KEY (id_liga) REFERENCES liga (id_liga),
    CONSTRAINT ck_equipo_anio CHECK (anio_fundacion BETWEEN 1850 AND 2100)
);

CREATE TABLE jugador (
    id_jugador        NUMBER(6)      NOT NULL,
    nombre            VARCHAR2(50)   NOT NULL,
    apellido          VARCHAR2(50)   NOT NULL,
    fecha_nacimiento  DATE           NOT NULL,
    nacionalidad      VARCHAR2(40)   NOT NULL,
    posicion          VARCHAR2(15)   NOT NULL,
    dorsal            NUMBER(2)      NOT NULL,
    goles             NUMBER(4)      DEFAULT 0 NOT NULL,
    id_equipo         NUMBER(4)      NOT NULL,
    CONSTRAINT pk_jugador        PRIMARY KEY (id_jugador),
    CONSTRAINT fk_jugador_equipo FOREIGN KEY (id_equipo) REFERENCES equipo (id_equipo),
    CONSTRAINT uq_jugador_dorsal UNIQUE (id_equipo, dorsal),
    CONSTRAINT ck_jugador_pos    CHECK (posicion IN ('Portero','Defensa','Mediocampista','Delantero')),
    CONSTRAINT ck_jugador_dorsal CHECK (dorsal BETWEEN 1 AND 99),
    CONSTRAINT ck_jugador_goles  CHECK (goles >= 0)
);

-- ---------------------------------------------------------------------
-- 2. DATOS DE EJEMPLO
-- ---------------------------------------------------------------------
INSERT INTO liga VALUES (1, 'Liga BetPlay',    'Colombia',   1948);
INSERT INTO liga VALUES (2, 'LaLiga',          'España',     1929);
INSERT INTO liga VALUES (3, 'Premier League',  'Inglaterra', 1992);

INSERT INTO equipo VALUES (1, 'Atlético Nacional',  'Medellín',  'Atanasio Girardot',  1947, 1);
INSERT INTO equipo VALUES (2, 'Millonarios FC',     'Bogotá',    'El Campín',          1946, 1);
INSERT INTO equipo VALUES (3, 'Junior de Barranquilla', 'Barranquilla', 'Metropolitano Roberto Meléndez', 1924, 1);
INSERT INTO equipo VALUES (4, 'Real Madrid CF',     'Madrid',    'Santiago Bernabéu',  1902, 2);
INSERT INTO equipo VALUES (5, 'FC Barcelona',       'Barcelona', 'Spotify Camp Nou',   1899, 2);
INSERT INTO equipo VALUES (6, 'Liverpool FC',       'Liverpool', 'Anfield',            1892, 3);
INSERT INTO equipo VALUES (7, 'Deportivo Nuevo FC', 'Bogotá',    NULL,                 2026, 1);  -- recién inscrito, sin plantilla

INSERT INTO jugador VALUES (1,  'Andrés',   'Moreno',    TO_DATE('1998-03-14','YYYY-MM-DD'), 'Colombia',  'Delantero',     9,  14, 1);
INSERT INTO jugador VALUES (2,  'Felipe',   'Rojas',     TO_DATE('2001-07-02','YYYY-MM-DD'), 'Colombia',  'Mediocampista', 8,   5, 1);
INSERT INTO jugador VALUES (3,  'Camilo',   'Vargas',    TO_DATE('1995-11-20','YYYY-MM-DD'), 'Colombia',  'Portero',       1,   0, 1);
INSERT INTO jugador VALUES (4,  'Daniel',   'Quintero',  TO_DATE('1999-01-30','YYYY-MM-DD'), 'Colombia',  'Delantero',    11,  11, 2);
INSERT INTO jugador VALUES (5,  'Sebastián','Peña',      TO_DATE('1997-09-09','YYYY-MM-DD'), 'Argentina', 'Delantero',     7,  17, 2);
INSERT INTO jugador VALUES (6,  'Mateo',    'Ríos',      TO_DATE('2000-05-25','YYYY-MM-DD'), 'Colombia',  'Defensa',       4,   2, 2);
INSERT INTO jugador VALUES (7,  'Jhon',     'Caicedo',   TO_DATE('1996-12-12','YYYY-MM-DD'), 'Colombia',  'Delantero',     9,   8, 3);
INSERT INTO jugador VALUES (8,  'Luis',     'Barrios',   TO_DATE('1994-04-18','YYYY-MM-DD'), 'Colombia',  'Mediocampista', 10,  6, 3);
INSERT INTO jugador VALUES (9,  'Carlos',   'Medina',    TO_DATE('1993-08-03','YYYY-MM-DD'), 'España',    'Defensa',       2,   1, 4);
INSERT INTO jugador VALUES (10, 'Iván',     'Duarte',    TO_DATE('2002-02-14','YYYY-MM-DD'), 'Brasil',    'Delantero',    10,  19, 4);
INSERT INTO jugador VALUES (11, 'Pablo',    'Serrano',   TO_DATE('1999-06-21','YYYY-MM-DD'), 'España',    'Mediocampista', 8,   7, 5);
INSERT INTO jugador VALUES (12, 'Marcos',   'Lemos',     TO_DATE('1998-10-05','YYYY-MM-DD'), 'Uruguay',   'Delantero',     9,  15, 5);
INSERT INTO jugador VALUES (13, 'Harry',    'Collins',   TO_DATE('1996-03-29','YYYY-MM-DD'), 'Inglaterra','Delantero',    11,  21, 6);
INSERT INTO jugador VALUES (14, 'Tomás',    'Villa',     TO_DATE('2003-01-17','YYYY-MM-DD'), 'Colombia',  'Portero',       1,   0, 6);

COMMIT;

-- ---------------------------------------------------------------------
-- 3. EXPRESIONES DE ÁLGEBRA RELACIONAL Y SU EQUIVALENTE EN SQL
-- ---------------------------------------------------------------------

-- Expresión 1 — Selección y proyección
--   Nombre, apellido y goles de los DELANTEROS COLOMBIANOS con 10 o más goles.
--
--   π nombre, apellido, goles ( σ posicion='Delantero' ∧ nacionalidad='Colombia' ∧ goles ≥ 10 ( JUGADOR ) )
SELECT nombre, apellido, goles
FROM   jugador
WHERE  posicion = 'Delantero'
  AND  nacionalidad = 'Colombia'
  AND  goles >= 10;

-- Expresión 2 — Reunión de las tres tablas (producto cartesiano + selección)
--   Apellido del jugador, equipo y liga, solo para los jugadores de la 'Liga BetPlay'.
--
--   π J.apellido, E.nombre, L.nombre (
--       σ J.id_equipo = E.id_equipo ∧ E.id_liga = L.id_liga ∧ L.nombre = 'Liga BetPlay'
--         ( ρJ(JUGADOR) × ρE(EQUIPO) × ρL(LIGA) ) )
SELECT j.apellido, e.nombre AS equipo, l.nombre AS liga
FROM   jugador j, equipo e, liga l
WHERE  j.id_equipo = e.id_equipo
  AND  e.id_liga   = l.id_liga
  AND  l.nombre    = 'Liga BetPlay';

-- Expresión 3 — Diferencia
--   Equipos que NO tienen ningún jugador registrado.
--
--   π nombre, ciudad ( EQUIPO ⋈ ( π id_equipo (EQUIPO)  −  π id_equipo (JUGADOR) ) )
SELECT nombre, ciudad
FROM   equipo
WHERE  id_equipo IN (SELECT id_equipo FROM equipo
                     MINUS
                     SELECT id_equipo FROM jugador);
