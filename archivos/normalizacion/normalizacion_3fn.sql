-- =====================================================================
-- TALLER DE NORMALIZACIÓN — esquemas finales en 3FN con datos de ejemplo
-- Bases de Datos 1 · Universidad El Bosque · Autor: Juan David Polo Herrera
-- SQL estándar (sirve en MySQL y Oracle; en Oracle se usa DATE 'AAAA-MM-DD').
-- Cada bloque termina con la consulta que RECONSTRUYE la tabla original del
-- enunciado a partir de las tablas normalizadas (descomposición sin pérdida).
-- =====================================================================

-- ---------------------------------------------------------------------
-- PUNTO 1 — Proyectos, empleados y horas (Tabla No. 1)
-- ---------------------------------------------------------------------
CREATE TABLE proyecto (
    cod_proyecto  INT          NOT NULL,
    nom_proyecto  VARCHAR(40)  NOT NULL,
    CONSTRAINT pk_proyecto PRIMARY KEY (cod_proyecto)
);
CREATE TABLE profesion (
    profesion  VARCHAR(30)  NOT NULL,
    vlr_hora   INT          NOT NULL,
    CONSTRAINT pk_profesion PRIMARY KEY (profesion)
);
CREATE TABLE empleado (
    cod_empleado  INT          NOT NULL,
    nom_empleado  VARCHAR(40)  NOT NULL,
    profesion     VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_empleado          PRIMARY KEY (cod_empleado),
    CONSTRAINT fk_empleado_profesion FOREIGN KEY (profesion) REFERENCES profesion (profesion)
);
CREATE TABLE asignacion (
    cod_proyecto   INT  NOT NULL,
    cod_empleado   INT  NOT NULL,
    hrs_asignadas  INT  NOT NULL,
    CONSTRAINT pk_asignacion          PRIMARY KEY (cod_proyecto, cod_empleado),
    CONSTRAINT fk_asignacion_proyecto FOREIGN KEY (cod_proyecto) REFERENCES proyecto (cod_proyecto),
    CONSTRAINT fk_asignacion_empleado FOREIGN KEY (cod_empleado) REFERENCES empleado (cod_empleado)
);
INSERT INTO proyecto VALUES (1010, 'ERP');
INSERT INTO proyecto VALUES (1020, 'CRM');
INSERT INTO proyecto VALUES (1030, 'BI');
INSERT INTO profesion VALUES ('Ingeniero',   100000);
INSERT INTO profesion VALUES ('Analista',     50000);
INSERT INTO profesion VALUES ('Programador',  20000);
INSERT INTO empleado VALUES (2010, 'Sandra',  'Ingeniero');
INSERT INTO empleado VALUES (2020, 'Claudia', 'Analista');
INSERT INTO empleado VALUES (2030, 'Yamile',  'Programador');
INSERT INTO empleado VALUES (2040, 'Andrea',  'Ingeniero');
INSERT INTO asignacion VALUES (1010, 2010, 20);
INSERT INTO asignacion VALUES (1010, 2020, 10);
INSERT INTO asignacion VALUES (1010, 2030, 10);
INSERT INTO asignacion VALUES (1020, 2010, 10);
INSERT INTO asignacion VALUES (1020, 2020, 15);
INSERT INTO asignacion VALUES (1020, 2030, 20);
INSERT INTO asignacion VALUES (1030, 2010, 10);
INSERT INTO asignacion VALUES (1030, 2020, 15);
INSERT INTO asignacion VALUES (1030, 2030, 10);
INSERT INTO asignacion VALUES (1010, 2040, 40);

-- Reconstrucción de la Tabla No. 1
SELECT p.cod_proyecto, p.nom_proyecto, e.cod_empleado, e.nom_empleado, e.profesion, f.vlr_hora, a.hrs_asignadas
FROM   asignacion a
JOIN   proyecto  p ON p.cod_proyecto = a.cod_proyecto
JOIN   empleado  e ON e.cod_empleado = a.cod_empleado
JOIN   profesion f ON f.profesion    = e.profesion;

-- ---------------------------------------------------------------------
-- PUNTO 2 — Estudiantes con varios cursos (1FN)
-- ---------------------------------------------------------------------
CREATE TABLE estudiante (
    cod    INT          NOT NULL,
    name   VARCHAR(40)  NOT NULL,
    email  VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_estudiante       PRIMARY KEY (cod),
    CONSTRAINT uq_estudiante_email UNIQUE (email)
);
CREATE TABLE inscripcion (
    cod           INT         NOT NULL,
    course        VARCHAR(10) NOT NULL,
    grade_points  INT         NOT NULL,
    CONSTRAINT pk_inscripcion            PRIMARY KEY (cod, course),
    CONSTRAINT fk_inscripcion_estudiante FOREIGN KEY (cod) REFERENCES estudiante (cod)
);
INSERT INTO estudiante VALUES (100111, 'John Doe',       'doe@usna.edu');
INSERT INTO estudiante VALUES (092244, 'Matt Smith',     'smith@usna.edu');
INSERT INTO estudiante VALUES (113221, 'Melinda Black',  'black@usna.edu');
INSERT INTO estudiante VALUES (090112, 'Tom Johnson',    'Johnson@usna.edu');
INSERT INTO inscripcion VALUES (100111, 'NN204', 2);
INSERT INTO inscripcion VALUES (100111, 'SI204', 3);
INSERT INTO inscripcion VALUES (100111, 'IT221', 3);
INSERT INTO inscripcion VALUES (092244, 'SM223', 4);
INSERT INTO inscripcion VALUES (092244, 'EE301', 4);
INSERT INTO inscripcion VALUES (113221, 'SI204', 3);
INSERT INTO inscripcion VALUES (090112, 'NN204', 4);
INSERT INTO inscripcion VALUES (090112, 'SI204', 2);
INSERT INTO inscripcion VALUES (090112, 'IT221', 3);

-- Reconstrucción: una fila por estudiante y curso (la tabla original las agrupaba en una celda)
SELECT e.cod, e.name, e.email, i.course, i.grade_points
FROM   estudiante e
JOIN   inscripcion i ON i.cod = e.cod;

-- ---------------------------------------------------------------------
-- PUNTO 3 — Cenas de un restaurante (Member_Dinner)
-- ---------------------------------------------------------------------
CREATE TABLE member (
    member_num      INT          NOT NULL,
    member_name     VARCHAR(40)  NOT NULL,
    member_address  VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_member PRIMARY KEY (member_num)
);
CREATE TABLE venue (
    venue_code         VARCHAR(5)   NOT NULL,
    venue_description  VARCHAR(40)  NOT NULL,
    CONSTRAINT pk_venue PRIMARY KEY (venue_code)
);
CREATE TABLE dinner (
    dinner_num   VARCHAR(6)  NOT NULL,
    dinner_date  DATE        NOT NULL,
    venue_code   VARCHAR(5)  NOT NULL,
    CONSTRAINT pk_dinner       PRIMARY KEY (dinner_num),
    CONSTRAINT fk_dinner_venue FOREIGN KEY (venue_code) REFERENCES venue (venue_code)
);
CREATE TABLE food (
    food_code         VARCHAR(5)   NOT NULL,
    food_description  VARCHAR(40)  NOT NULL,
    CONSTRAINT pk_food PRIMARY KEY (food_code)
);
CREATE TABLE attendance (
    member_num  INT         NOT NULL,
    dinner_num  VARCHAR(6)  NOT NULL,
    CONSTRAINT pk_attendance        PRIMARY KEY (member_num, dinner_num),
    CONSTRAINT fk_attendance_member FOREIGN KEY (member_num) REFERENCES member (member_num),
    CONSTRAINT fk_attendance_dinner FOREIGN KEY (dinner_num) REFERENCES dinner (dinner_num)
);
CREATE TABLE menu (
    dinner_num  VARCHAR(6)  NOT NULL,
    food_code   VARCHAR(5)  NOT NULL,
    CONSTRAINT pk_menu        PRIMARY KEY (dinner_num, food_code),
    CONSTRAINT fk_menu_dinner FOREIGN KEY (dinner_num) REFERENCES dinner (dinner_num),
    CONSTRAINT fk_menu_food   FOREIGN KEY (food_code)  REFERENCES food (food_code)
);
INSERT INTO member VALUES (214, 'Peter Wong', '325 Meadow Park');
INSERT INTO member VALUES (235, 'Mary Lee',   '123 Rose Court');
INSERT INTO member VALUES (250, 'Peter Wong', '9 Nine Ave');
INSERT INTO member VALUES (300, 'Paul Lee',   '123 Rose Court');
INSERT INTO venue VALUES ('B01', 'Grand Ball Room');
INSERT INTO venue VALUES ('B02', 'Petit Ball Room');
INSERT INTO venue VALUES ('C01', 'Café');
INSERT INTO venue VALUES ('E10', 'Petit Ball Room');
INSERT INTO dinner VALUES ('D0001', DATE '2010-03-15', 'B01');
INSERT INTO dinner VALUES ('D0002', DATE '2010-03-15', 'B02');
INSERT INTO dinner VALUES ('D0003', DATE '2010-03-20', 'C01');
INSERT INTO dinner VALUES ('D0004', DATE '2010-03-20', 'E10');
INSERT INTO food VALUES ('EN3', 'Stuffed crab');
INSERT INTO food VALUES ('DE8', 'Chocolate mousse');
INSERT INTO food VALUES ('EN5', 'Marinated steak');
INSERT INTO food VALUES ('SO1', 'Pumpkin soup');
INSERT INTO food VALUES ('DE2', 'Apple pie');
INSERT INTO food VALUES ('SA2', 'Apple pie');
INSERT INTO attendance VALUES (214, 'D0001');
INSERT INTO attendance VALUES (235, 'D0002');
INSERT INTO attendance VALUES (250, 'D0003');
INSERT INTO attendance VALUES (235, 'D0003');
INSERT INTO attendance VALUES (300, 'D0004');
INSERT INTO menu VALUES ('D0001', 'EN3');
INSERT INTO menu VALUES ('D0001', 'DE8');
INSERT INTO menu VALUES ('D0002', 'EN5');
INSERT INTO menu VALUES ('D0002', 'DE8');
INSERT INTO menu VALUES ('D0003', 'SO1');
INSERT INTO menu VALUES ('D0003', 'EN5');
INSERT INTO menu VALUES ('D0003', 'DE2');
INSERT INTO menu VALUES ('D0004', 'SA2');

-- Reconstrucción de Member_Dinner (una fila por miembro, cena y plato)
SELECT m.member_num, m.member_name, m.member_address, d.dinner_num, d.dinner_date,
       v.venue_code, v.venue_description, f.food_code, f.food_description
FROM   attendance a
JOIN   member m ON m.member_num = a.member_num
JOIN   dinner d ON d.dinner_num = a.dinner_num
JOIN   venue  v ON v.venue_code = d.venue_code
JOIN   menu   u ON u.dinner_num = d.dinner_num
JOIN   food   f ON f.food_code  = u.food_code;

-- ---------------------------------------------------------------------
-- PUNTO 4 — Visitas médicas (Tabla No. 2)
-- ---------------------------------------------------------------------
CREATE TABLE paciente (
    pac_no      VARCHAR(5)   NOT NULL,
    pac_edad    INT          NOT NULL,
    pac_ciudad  VARCHAR(30)  NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (pac_no)
);
CREATE TABLE proveedor (
    prov_no            VARCHAR(5)   NOT NULL,
    prov_especialidad  VARCHAR(40)  NOT NULL,
    CONSTRAINT pk_proveedor PRIMARY KEY (prov_no)
);
CREATE TABLE visita (
    visita_no   VARCHAR(8)  NOT NULL,
    dia_visita  DATE        NOT NULL,
    pac_no      VARCHAR(5)  NOT NULL,
    CONSTRAINT pk_visita          PRIMARY KEY (visita_no),
    CONSTRAINT fk_visita_paciente FOREIGN KEY (pac_no) REFERENCES paciente (pac_no)
);
CREATE TABLE atencion (
    visita_no    VARCHAR(8)   NOT NULL,
    prov_no      VARCHAR(5)   NOT NULL,
    diagnostico  VARCHAR(40)  NOT NULL,
    CONSTRAINT pk_atencion           PRIMARY KEY (visita_no, prov_no),
    CONSTRAINT fk_atencion_visita    FOREIGN KEY (visita_no) REFERENCES visita (visita_no),
    CONSTRAINT fk_atencion_proveedor FOREIGN KEY (prov_no)   REFERENCES proveedor (prov_no)
);
INSERT INTO paciente VALUES ('P1', 35, 'BOGOTA');
INSERT INTO paciente VALUES ('P2', 60, 'CUCUTA');
INSERT INTO paciente VALUES ('P3', 17, 'CALI');
INSERT INTO proveedor VALUES ('D1', 'INTERNISTA');
INSERT INTO proveedor VALUES ('D2', 'PRACTICANTE ENFERMERÍA');
INSERT INTO proveedor VALUES ('D3', 'CARDIÓLOGO');
INSERT INTO visita VALUES ('V10020', DATE '2019-01-13', 'P1');
INSERT INTO visita VALUES ('V93030', DATE '2019-01-20', 'P3');
INSERT INTO visita VALUES ('V82110', DATE '2019-01-18', 'P2');
INSERT INTO atencion VALUES ('V10020', 'D1', 'INFECCIÓN DE OÍDO');
INSERT INTO atencion VALUES ('V10020', 'D2', 'INFLUENZA');
INSERT INTO atencion VALUES ('V93030', 'D2', 'EMBARAZO');
INSERT INTO atencion VALUES ('V82110', 'D3', 'SOPLO CARDIACO');

-- Reconstrucción de la Tabla No. 2
SELECT v.visita_no, v.dia_visita, p.pac_no, p.pac_edad, p.pac_ciudad, r.prov_no, r.prov_especialidad, a.diagnostico
FROM   atencion a
JOIN   visita    v ON v.visita_no = a.visita_no
JOIN   paciente  p ON p.pac_no    = v.pac_no
JOIN   proveedor r ON r.prov_no   = a.prov_no;

-- ---------------------------------------------------------------------
-- PUNTO 5 — Alquiler de DVD por correo (Rentals), en 3FN y BCNF
-- ---------------------------------------------------------------------
CREATE TABLE category (
    movie_category  VARCHAR(10)  NOT NULL,
    price           DECIMAL(5,2) NOT NULL,
    CONSTRAINT pk_category PRIMARY KEY (movie_category)
);
CREATE TABLE movie (
    title           VARCHAR(40)  NOT NULL,
    director        VARCHAR(40)  NOT NULL,
    movie_category  VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_movie          PRIMARY KEY (title),
    CONSTRAINT fk_movie_category FOREIGN KEY (movie_category) REFERENCES category (movie_category)
);
CREATE TABLE rental (
    rental_id        INT   NOT NULL,
    customer_id      INT   NOT NULL,
    mailed_out_date  DATE  NOT NULL,
    CONSTRAINT pk_rental PRIMARY KEY (rental_id)
);
CREATE TABLE rental_movie (
    rental_id  INT          NOT NULL,
    title      VARCHAR(40)  NOT NULL,
    CONSTRAINT pk_rental_movie        PRIMARY KEY (rental_id, title),
    CONSTRAINT fk_rental_movie_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id),
    CONSTRAINT fk_rental_movie_movie  FOREIGN KEY (title)     REFERENCES movie (title)
);
INSERT INTO category VALUES ('Old', 4.25);
INSERT INTO category VALUES ('New', 5.50);
INSERT INTO movie VALUES ('Die Hard',            'John McTiernan',         'Old');
INSERT INTO movie VALUES ('The last man standing','Walter Hill',           'Old');
INSERT INTO movie VALUES ('Wedding Crashers',    'David Dobkin',           'New');
INSERT INTO movie VALUES ('Dodgeball',           'Rawson Marshall Thurber','New');
INSERT INTO movie VALUES ('As good as it gets',  'James Brooks',           'Old');
INSERT INTO movie VALUES ('Forest Gump',         'Robert Zemeckis',        'Old');
INSERT INTO rental VALUES (1, 1001, DATE '2010-03-03');
INSERT INTO rental VALUES (2, 1002, DATE '2010-03-04');
INSERT INTO rental VALUES (3, 1003, DATE '2011-01-07');
INSERT INTO rental VALUES (4, 1001, DATE '2011-01-07');
INSERT INTO rental_movie VALUES (1, 'Die Hard');
INSERT INTO rental_movie VALUES (1, 'The last man standing');
INSERT INTO rental_movie VALUES (1, 'Wedding Crashers');
INSERT INTO rental_movie VALUES (2, 'Dodgeball');
INSERT INTO rental_movie VALUES (2, 'Die Hard');
INSERT INTO rental_movie VALUES (3, 'As good as it gets');
INSERT INTO rental_movie VALUES (4, 'Forest Gump');

-- Reconstrucción de la Tabla No. 4
SELECT r.rental_id, m.title, r.customer_id, r.mailed_out_date, m.director, m.movie_category, c.price
FROM   rental_movie rm
JOIN   rental   r ON r.rental_id = rm.rental_id
JOIN   movie    m ON m.title     = rm.title
JOIN   category c ON c.movie_category = m.movie_category;
