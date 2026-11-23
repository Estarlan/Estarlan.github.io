-- =====================================================================
-- GUÍA 1 DE ÁLGEBRA RELACIONAL — base de prueba y consultas en SQL
-- Bases de Datos 1 · Universidad El Bosque · Juan David Polo Herrera
-- Los datos son inventados: se armaron para que cada ejercicio tenga un
-- resultado interesante y aparezcan los casos límite (id = 100, un producto
-- que suma exactamente 500 unidades, otro que pasa de 500 sumando líneas
-- pequeñas, un cliente sin facturas, etc.).
-- Las consultas SQL son el equivalente de cada expresión de álgebra.
-- =====================================================================
CREATE TABLE localidad (id_localidad INT PRIMARY KEY, nombre VARCHAR(30) NOT NULL);
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY, nombre VARCHAR(40) NOT NULL, direccion VARCHAR(40), telefono VARCHAR(15),
    id_localidad INT NOT NULL REFERENCES localidad (id_localidad));
CREATE TABLE producto (id_producto INT PRIMARY KEY, descripcion VARCHAR(40) NOT NULL, precio DECIMAL(10,2) NOT NULL);
CREATE TABLE factura (
    id_factura INT PRIMARY KEY, id_cliente INT NOT NULL REFERENCES cliente (id_cliente),
    fecha DATE NOT NULL, pagada INT NOT NULL CHECK (pagada IN (0, 1)));
CREATE TABLE detalle (
    id_factura INT NOT NULL REFERENCES factura (id_factura), id_producto INT NOT NULL REFERENCES producto (id_producto),
    cantidad INT NOT NULL, precio_vta DECIMAL(10,2) NOT NULL, PRIMARY KEY (id_factura, id_producto));

INSERT INTO localidad VALUES (1, 'Luján');
INSERT INTO localidad VALUES (2, 'Cortines');
INSERT INTO localidad VALUES (3, 'Pilar');
INSERT INTO localidad VALUES (4, 'Escobar');
INSERT INTO producto VALUES (50,  'Teclado',   100.00);
INSERT INTO producto VALUES (100, 'Mouse',      50.00);
INSERT INTO producto VALUES (101, 'Monitor',   900.00);
INSERT INTO producto VALUES (150, 'Impresora', 700.00);
INSERT INTO producto VALUES (200, 'Parlantes', 120.00);
INSERT INTO cliente VALUES (1, 'Ana Torres',  'Calle 1', '3001111111', 1);
INSERT INTO cliente VALUES (2, 'Bruno Díaz',  'Calle 2', '3002222222', 1);
INSERT INTO cliente VALUES (3, 'Carla Ruiz',  'Calle 3', '3003333333', 2);
INSERT INTO cliente VALUES (4, 'Diego Paz',   'Calle 4', '3004444444', 2);
INSERT INTO cliente VALUES (5, 'Elena Soto',  'Calle 5', '3005555555', 3);
INSERT INTO cliente VALUES (6, 'Fabio Gil',   'Calle 6', '3006666666', 4);
INSERT INTO factura VALUES (10, 1, '2026-03-01', 1);
INSERT INTO factura VALUES (11, 1, '2026-03-05', 1);
INSERT INTO factura VALUES (12, 2, '2026-03-06', 0);
INSERT INTO factura VALUES (13, 3, '2026-03-07', 1);
INSERT INTO factura VALUES (14, 3, '2026-03-09', 0);
INSERT INTO factura VALUES (15, 4, '2026-03-10', 1);
INSERT INTO factura VALUES (16, 5, '2026-03-12', 1);
INSERT INTO factura VALUES (18, 2, '2026-03-15', 1);
INSERT INTO detalle VALUES (10, 50,   10, 100.00);
INSERT INTO detalle VALUES (10, 100,   5,  50.00);
INSERT INTO detalle VALUES (10, 101,   2, 900.00);
INSERT INTO detalle VALUES (11, 150,   1, 700.00);
INSERT INTO detalle VALUES (11, 101, 600, 880.00);
INSERT INTO detalle VALUES (12, 50,    3, 100.00);
INSERT INTO detalle VALUES (13, 50,    2, 100.00);
INSERT INTO detalle VALUES (13, 100,  20,  50.00);
INSERT INTO detalle VALUES (13, 101,   1, 900.00);
INSERT INTO detalle VALUES (14, 150,   4, 700.00);
INSERT INTO detalle VALUES (14, 200, 500, 120.00);
INSERT INTO detalle VALUES (15, 50,    7, 100.00);
INSERT INTO detalle VALUES (15, 101,   1, 900.00);
INSERT INTO detalle VALUES (15, 150, 750, 690.00);
INSERT INTO detalle VALUES (16, 150,   2, 700.00);
INSERT INTO detalle VALUES (16, 100, 450,  50.00);
INSERT INTO detalle VALUES (18, 100,  40,  50.00);

-- 1. Id y descripción de los productos con Id mayor a 100
SELECT id_producto, descripcion FROM producto WHERE id_producto > 100;

-- 2. Nombres de los clientes de Luján
SELECT c.nombre FROM cliente c JOIN localidad l ON l.id_localidad = c.id_localidad WHERE l.nombre = 'Luján';

-- 3. Cliente, factura, producto y cantidad de las ventas de los productos de los que
--    se han vendido más de 500 unidades en total (sumando todas sus líneas de detalle)
SELECT c.nombre, d.id_factura, d.id_producto, d.cantidad
FROM detalle d JOIN factura f ON f.id_factura = d.id_factura JOIN cliente c ON c.id_cliente = f.id_cliente
WHERE d.id_producto IN (SELECT id_producto FROM detalle GROUP BY id_producto HAVING SUM(cantidad) > 500);

-- 4. Clientes que no aparecen en FACTURA
SELECT nombre FROM cliente WHERE id_cliente NOT IN (SELECT id_cliente FROM factura);

-- 5. Clientes que han comprado todos los productos
SELECT c.nombre FROM cliente c
WHERE NOT EXISTS (SELECT 1 FROM producto p
                  WHERE NOT EXISTS (SELECT 1 FROM factura f JOIN detalle d ON d.id_factura = f.id_factura
                                    WHERE f.id_cliente = c.id_cliente AND d.id_producto = p.id_producto));

-- 6. Facturas con una cantidad mayor a la cantidad vendida en la factura 18
SELECT DISTINCT d1.id_factura FROM detalle d1, detalle d2 WHERE d2.id_factura = 18 AND d1.cantidad > d2.cantidad;

-- 7. Productos que no se han comprado en Luján
SELECT id_producto, descripcion FROM producto
WHERE id_producto NOT IN (SELECT d.id_producto FROM detalle d JOIN factura f ON f.id_factura = d.id_factura
                          JOIN cliente c ON c.id_cliente = f.id_cliente JOIN localidad l ON l.id_localidad = c.id_localidad
                          WHERE l.nombre = 'Luján');

-- 8. Productos vendidos tanto en Luján como en Cortines
SELECT p.id_producto, p.descripcion FROM producto p
WHERE p.id_producto IN (SELECT d.id_producto FROM detalle d JOIN factura f ON f.id_factura = d.id_factura JOIN cliente c ON c.id_cliente = f.id_cliente
                        JOIN localidad l ON l.id_localidad = c.id_localidad WHERE l.nombre = 'Luján')
  AND p.id_producto IN (SELECT d.id_producto FROM detalle d JOIN factura f ON f.id_factura = d.id_factura JOIN cliente c ON c.id_cliente = f.id_cliente
                        JOIN localidad l ON l.id_localidad = c.id_localidad WHERE l.nombre = 'Cortines');

-- 9. Localidades a las que se han vendido todos los productos
SELECT l.nombre FROM localidad l
WHERE NOT EXISTS (SELECT 1 FROM producto p
                  WHERE NOT EXISTS (SELECT 1 FROM cliente c JOIN factura f ON f.id_cliente = c.id_cliente JOIN detalle d ON d.id_factura = f.id_factura
                                    WHERE c.id_localidad = l.id_localidad AND d.id_producto = p.id_producto));

-- 10. Clientes con alguna factura sin pagar
SELECT DISTINCT c.nombre FROM cliente c JOIN factura f ON f.id_cliente = c.id_cliente WHERE f.pagada = 0;

-- 11. Clientes que han pagado todas sus facturas (con al menos una factura)
SELECT c.nombre FROM cliente c
WHERE EXISTS (SELECT 1 FROM factura f WHERE f.id_cliente = c.id_cliente)
  AND NOT EXISTS (SELECT 1 FROM factura f WHERE f.id_cliente = c.id_cliente AND f.pagada = 0);
