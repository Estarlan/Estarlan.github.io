-- =====================================================================
-- EJERCICIOS DE ÁLGEBRA RELACIONAL (2) — base de prueba y consultas en SQL
-- Bases de Datos 1 · Universidad El Bosque · Juan David Polo Herrera
-- Los datos son inventados, con casos límite a propósito (un producto que suma
-- exactamente 500 unidades, otro que pasa de 500 sumando varias ventas pequeñas,
-- un código igual a su descripción, un cliente sin compras, etc.).
-- =====================================================================
CREATE TABLE clientes (
    num_cliente INT PRIMARY KEY, nombre VARCHAR(40) NOT NULL, direccion VARCHAR(40), telefono VARCHAR(15), poblacion VARCHAR(30) NOT NULL);
CREATE TABLE producto (cod_producto VARCHAR(15) PRIMARY KEY, descripcion VARCHAR(40) NOT NULL, precio DECIMAL(10,2) NOT NULL);
CREATE TABLE venta (
    cod_producto VARCHAR(15) NOT NULL REFERENCES producto (cod_producto), num_cliente INT NOT NULL REFERENCES clientes (num_cliente),
    cantidad INT NOT NULL, id_venta INT PRIMARY KEY);
CREATE TABLE factura (
    num_factura INT PRIMARY KEY, fecha DATE NOT NULL, pagada INT NOT NULL CHECK (pagada IN (0, 1)),
    num_cliente INT NOT NULL REFERENCES clientes (num_cliente));

INSERT INTO clientes VALUES (1, 'Lucía Pérez',  'Calle Mayor 3',  '979111111', 'Palencia');
INSERT INTO clientes VALUES (2, 'Mario Gómez',  'Plaza Nueva 5',  '979222222', 'Palencia');
INSERT INTO clientes VALUES (3, 'Nuria Sanz',   'Av. Madrid 10',  '983333333', 'Valladolid');
INSERT INTO clientes VALUES (4, 'Óscar Ruiz',   'Calle Sol 7',    '983444444', 'Valladolid');
INSERT INTO clientes VALUES (5, 'Paula Díaz',   'Calle Luna 2',   '987555555', 'León');
INSERT INTO clientes VALUES (6, 'Raúl Vega',    'Calle Río 9',    '923666666', 'Salamanca');
INSERT INTO producto VALUES ('TORNILLO', 'TORNILLO',      0.10);
INSERT INTO producto VALUES ('TUERCA',   'Tuerca M8',     0.15);
INSERT INTO producto VALUES ('ARANDELA', 'Arandela',      0.05);
INSERT INTO producto VALUES ('MARTILLO', 'Martillo 500g', 9.50);
INSERT INTO producto VALUES ('SIERRA',   'Sierra manual', 12.00);
INSERT INTO producto VALUES ('CLAVO',    'Clavo',         0.02);
INSERT INTO venta VALUES ('TORNILLO', 1, 600, 11);
INSERT INTO venta VALUES ('TUERCA',   1,  20, 12);
INSERT INTO venta VALUES ('MARTILLO', 2,   5, 13);
INSERT INTO venta VALUES ('TORNILLO', 3, 500, 14);
INSERT INTO venta VALUES ('TUERCA',   3, 250, 15);
INSERT INTO venta VALUES ('ARANDELA', 3, 100, 16);
INSERT INTO venta VALUES ('MARTILLO', 3,   2, 17);
INSERT INTO venta VALUES ('ARANDELA', 2,  40, 18);
INSERT INTO venta VALUES ('SIERRA',   3,   3, 19);
INSERT INTO venta VALUES ('CLAVO',    3, 800, 20);
INSERT INTO venta VALUES ('TORNILLO', 4,  10, 21);
INSERT INTO venta VALUES ('TUERCA',   5, 230, 22);
INSERT INTO venta VALUES ('ARANDELA', 5, 400, 23);
INSERT INTO factura VALUES (101, '2026-03-01', 1, 1);
INSERT INTO factura VALUES (102, '2026-03-04', 1, 1);
INSERT INTO factura VALUES (103, '2026-03-06', 0, 2);
INSERT INTO factura VALUES (104, '2026-03-08', 1, 3);
INSERT INTO factura VALUES (105, '2026-03-10', 0, 3);
INSERT INTO factura VALUES (106, '2026-03-12', 1, 4);
INSERT INTO factura VALUES (107, '2026-03-15', 1, 5);

-- 1. Nombre de los clientes de Palencia
SELECT nombre FROM clientes WHERE poblacion = 'Palencia';

-- 2. Código y descripción de los productos cuyo código coincide con su descripción
SELECT cod_producto, descripcion FROM producto WHERE cod_producto = descripcion;

-- 3. Nombre del cliente, id de venta y cantidad vendida, de los productos de los que
--    se han vendido más de 500 unidades en total (sumando todas sus ventas)
SELECT c.nombre, v.id_venta, v.cantidad
FROM   venta v
JOIN   clientes c ON c.num_cliente = v.num_cliente
WHERE  v.cod_producto IN (SELECT cod_producto FROM venta GROUP BY cod_producto HAVING SUM(cantidad) > 500);

-- 4. Clientes que no aparecen en VENTA
SELECT nombre FROM clientes WHERE num_cliente NOT IN (SELECT num_cliente FROM venta);

-- 5. Clientes que han comprado todos los productos
SELECT c.nombre FROM clientes c
WHERE NOT EXISTS (SELECT 1 FROM producto p
                  WHERE NOT EXISTS (SELECT 1 FROM venta v WHERE v.num_cliente = c.num_cliente AND v.cod_producto = p.cod_producto));

-- 6. Ventas cuya cantidad supera la de la venta 18
SELECT DISTINCT v1.id_venta FROM venta v1, venta v2 WHERE v2.id_venta = 18 AND v1.cantidad > v2.cantidad;

-- 7. Productos que no se han comprado nunca en Palencia
SELECT cod_producto, descripcion FROM producto
WHERE cod_producto NOT IN (SELECT v.cod_producto FROM venta v JOIN clientes c ON c.num_cliente = v.num_cliente WHERE c.poblacion = 'Palencia');

-- 8. Productos vendidos tanto en Palencia como en Valladolid
SELECT p.cod_producto, p.descripcion FROM producto p
WHERE p.cod_producto IN (SELECT v.cod_producto FROM venta v JOIN clientes c ON c.num_cliente = v.num_cliente WHERE c.poblacion = 'Palencia')
  AND p.cod_producto IN (SELECT v.cod_producto FROM venta v JOIN clientes c ON c.num_cliente = v.num_cliente WHERE c.poblacion = 'Valladolid');

-- 9. Poblaciones a las que se han vendido todos los productos
SELECT DISTINCT c0.poblacion FROM clientes c0
WHERE NOT EXISTS (SELECT 1 FROM producto p
                  WHERE NOT EXISTS (SELECT 1 FROM venta v JOIN clientes c ON c.num_cliente = v.num_cliente
                                    WHERE c.poblacion = c0.poblacion AND v.cod_producto = p.cod_producto));

-- 10. Clientes con alguna factura sin pagar
SELECT DISTINCT c.nombre FROM clientes c JOIN factura f ON f.num_cliente = c.num_cliente WHERE f.pagada = 0;

-- 11. Clientes que han pagado todas sus facturas (con al menos una factura)
SELECT c.nombre FROM clientes c
WHERE EXISTS (SELECT 1 FROM factura f WHERE f.num_cliente = c.num_cliente)
  AND NOT EXISTS (SELECT 1 FROM factura f WHERE f.num_cliente = c.num_cliente AND f.pagada = 0);
