-- =====================================================================
-- CLASE 9 — ÁLGEBRA RELACIONAL: ejercicios de repaso (EMPLEADOS y Banco)
-- Bases de Datos 1 · Universidad El Bosque · Juan David Polo Herrera
-- Los datos son inventados. Las consultas SQL son el equivalente de cada
-- expresión de álgebra (sin tildes en los nombres de tablas y columnas).
-- =====================================================================
-- ---------- Base de datos EMPLEADOS ----------
CREATE TABLE empleado (nombre_empleado VARCHAR(30) PRIMARY KEY, calle VARCHAR(30), ciudad VARCHAR(30));
CREATE TABLE empresa  (nombre_empresa VARCHAR(30) PRIMARY KEY, ciudad VARCHAR(30));
CREATE TABLE trabaja  (nombre_empleado VARCHAR(30) PRIMARY KEY REFERENCES empleado (nombre_empleado),
                       nombre_empresa VARCHAR(30) NOT NULL REFERENCES empresa (nombre_empresa), sueldo INT NOT NULL);
CREATE TABLE jefe     (nombre_empleado VARCHAR(30) PRIMARY KEY REFERENCES empleado (nombre_empleado), nombre_jefe VARCHAR(30) NOT NULL);

INSERT INTO empleado VALUES ('Ana López',   'Calle 1', 'Xalapa');
INSERT INTO empleado VALUES ('Beto Cruz',   'Calle 2', 'Veracruz');
INSERT INTO empleado VALUES ('Carla Díaz',  'Calle 3', 'Xalapa');
INSERT INTO empleado VALUES ('Dani Ríos',   'Calle 4', 'Xalapa');
INSERT INTO empleado VALUES ('Eva Mora',    'Calle 5', 'Coatepec');
INSERT INTO empleado VALUES ('Fer Gil',     'Calle 6', 'Veracruz');
INSERT INTO empleado VALUES ('Gus Paz',     'Calle 7', 'Veracruz');
INSERT INTO empleado VALUES ('Hugo Sosa',   'Calle 8', 'Coatepec');
INSERT INTO empresa VALUES ('BANAMEX', 'Xalapa');
INSERT INTO empresa VALUES ('Soriana', 'Veracruz');
INSERT INTO trabaja VALUES ('Ana López',  'BANAMEX', 12000);
INSERT INTO trabaja VALUES ('Beto Cruz',  'BANAMEX',  9000);
INSERT INTO trabaja VALUES ('Carla Díaz', 'Soriana', 15000);
INSERT INTO trabaja VALUES ('Dani Ríos',  'BANAMEX', 10000);
INSERT INTO trabaja VALUES ('Eva Mora',   'Soriana', 11000);
INSERT INTO trabaja VALUES ('Fer Gil',    'BANAMEX', 20000);
INSERT INTO trabaja VALUES ('Gus Paz',    'Soriana',  8000);
INSERT INTO trabaja VALUES ('Hugo Sosa',  'Soriana',  9500);
INSERT INTO jefe VALUES ('Ana López',  'Fer Gil');
INSERT INTO jefe VALUES ('Beto Cruz',  'Fer Gil');
INSERT INTO jefe VALUES ('Carla Díaz', 'Gus Paz');
INSERT INTO jefe VALUES ('Dani Ríos',  'Gus Paz');
INSERT INTO jefe VALUES ('Eva Mora',   'Gus Paz');
INSERT INTO jefe VALUES ('Hugo Sosa',  'Mia Vega');

-- E1. Nombre y ciudad de residencia de los empleados que trabajan en BANAMEX
SELECT e.nombre_empleado, e.ciudad FROM empleado e, trabaja t
WHERE e.nombre_empleado = t.nombre_empleado AND t.nombre_empresa = 'BANAMEX';

-- E2. Nombre, domicilio y ciudad de los empleados que ganan más de 10.000
SELECT e.nombre_empleado, e.calle, e.ciudad FROM empleado e, trabaja t
WHERE e.nombre_empleado = t.nombre_empleado AND t.sueldo > 10000;

-- E3. Nombre, domicilio y ciudad de los que trabajan en BANAMEX y ganan más de 10.000
SELECT e.nombre_empleado, e.calle, e.ciudad FROM empleado e, trabaja t
WHERE e.nombre_empleado = t.nombre_empleado AND t.nombre_empresa = 'BANAMEX' AND t.sueldo > 10000;

-- E4. Nombre de los jefes con empleados en la ciudad de Xalapa
SELECT DISTINCT j.nombre_jefe FROM jefe j, empleado e
WHERE j.nombre_empleado = e.nombre_empleado AND e.ciudad = 'Xalapa';

-- ---------- Base de datos Banco ----------
CREATE TABLE sucursal   (nombre_sucursal VARCHAR(30) PRIMARY KEY, ciudad_sucursal VARCHAR(30) NOT NULL, activos INT NOT NULL);
CREATE TABLE cliente    (nombre_cliente VARCHAR(30) PRIMARY KEY, calle_cliente VARCHAR(30), ciudad_cliente VARCHAR(30));
CREATE TABLE cuenta     (numero_cuenta VARCHAR(10) PRIMARY KEY, nombre_sucursal VARCHAR(30) NOT NULL REFERENCES sucursal (nombre_sucursal), saldo INT NOT NULL);
CREATE TABLE impositor  (nombre_cliente VARCHAR(30) NOT NULL REFERENCES cliente (nombre_cliente), numero_cuenta VARCHAR(10) NOT NULL REFERENCES cuenta (numero_cuenta),
                         PRIMARY KEY (nombre_cliente, numero_cuenta));
CREATE TABLE prestamo   (numero_prestamo VARCHAR(10) PRIMARY KEY, nombre_sucursal VARCHAR(30) NOT NULL REFERENCES sucursal (nombre_sucursal), importe INT NOT NULL);
CREATE TABLE prestatario(nombre_cliente VARCHAR(30) NOT NULL REFERENCES cliente (nombre_cliente), numero_prestamo VARCHAR(10) NOT NULL REFERENCES prestamo (numero_prestamo),
                         PRIMARY KEY (nombre_cliente, numero_prestamo));

INSERT INTO sucursal VALUES ('Centro',      'Madrid',      9000000);
INSERT INTO sucursal VALUES ('Navacerrada', 'Navacerrada', 1700000);
INSERT INTO sucursal VALUES ('Xalapa Sur',  'Xalapa',      4000000);
INSERT INTO sucursal VALUES ('Veracruz',    'Veracruz',    2100000);
INSERT INTO cliente VALUES ('Ana',   'Calle 1', 'Xalapa');
INSERT INTO cliente VALUES ('Bruno', 'Calle 2', 'Veracruz');
INSERT INTO cliente VALUES ('Carla', 'Calle 3', 'Xalapa');
INSERT INTO cliente VALUES ('Diego', 'Calle 4', 'Madrid');
INSERT INTO cliente VALUES ('Elena', 'Calle 5', 'Madrid');
INSERT INTO cliente VALUES ('Fabio', 'Calle 6', 'Xalapa');
INSERT INTO cuenta VALUES ('C-101', 'Centro',        500);
INSERT INTO cuenta VALUES ('C-102', 'Navacerrada', 60000);
INSERT INTO cuenta VALUES ('C-103', 'Xalapa Sur',   75000);
INSERT INTO cuenta VALUES ('C-104', 'Veracruz',     45000);
INSERT INTO cuenta VALUES ('C-105', 'Centro',       52000);
INSERT INTO impositor VALUES ('Ana',   'C-101');
INSERT INTO impositor VALUES ('Bruno', 'C-102');
INSERT INTO impositor VALUES ('Carla', 'C-103');
INSERT INTO impositor VALUES ('Diego', 'C-104');
INSERT INTO impositor VALUES ('Elena', 'C-105');
INSERT INTO prestamo VALUES ('L-11', 'Centro',        900);
INSERT INTO prestamo VALUES ('L-12', 'Navacerrada',  1500);
INSERT INTO prestamo VALUES ('L-13', 'Xalapa Sur',   1000);
INSERT INTO prestamo VALUES ('L-14', 'Veracruz',     2500);
INSERT INTO prestamo VALUES ('L-15', 'Centro',       1200);
INSERT INTO prestatario VALUES ('Ana',   'L-11');
INSERT INTO prestatario VALUES ('Bruno', 'L-12');
INSERT INTO prestatario VALUES ('Carla', 'L-13');
INSERT INTO prestatario VALUES ('Diego', 'L-14');
INSERT INTO prestatario VALUES ('Elena', 'L-15');

-- B1. nombre_sucursal y ciudad_sucursal de las sucursales con préstamos de importe mayor a 1000
SELECT DISTINCT s.nombre_sucursal, s.ciudad_sucursal FROM sucursal s, prestamo p
WHERE s.nombre_sucursal = p.nombre_sucursal AND p.importe > 1000;

-- B2. Nombre, ciudad y número de cuenta de los clientes con una cuenta abierta
SELECT c.nombre_cliente, c.ciudad_cliente, i.numero_cuenta FROM cliente c, impositor i
WHERE c.nombre_cliente = i.nombre_cliente;

-- B3. Nombre de la sucursal y activos de las que tienen cuentas con saldo mayor a 50000
SELECT DISTINCT s.nombre_sucursal, s.activos FROM sucursal s, cuenta c
WHERE s.nombre_sucursal = c.nombre_sucursal AND c.saldo > 50000;
