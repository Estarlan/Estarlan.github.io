-- =====================================================================
-- PRÁCTICA SQL SOBRE EL ESQUEMA HR DE ORACLE — 4 ejercicios
-- Bases de Datos 1 · Universidad El Bosque · Juan David Polo Herrera
-- Ejercicios de práctica propios (no son un taller del curso).
-- Solo leen el esquema HR (employees, departments, locations).
-- =====================================================================

-- Ejercicio 1: empleados del departamento 50 que ganan más de 3000,
--              del que más gana al que menos.
SELECT first_name, last_name, salary
FROM   employees
WHERE  department_id = 50
  AND  salary > 3000
ORDER  BY salary DESC;

-- Ejercicio 2: cuántos empleados tiene cada departamento y cuánto ganan en
--              promedio, solo para los departamentos con más de 3 empleados.
SELECT department_id,
       COUNT(*)              AS empleados,
       ROUND(AVG(salary), 2) AS salario_promedio
FROM   employees
WHERE  department_id IS NOT NULL
GROUP  BY department_id
HAVING COUNT(*) > 3
ORDER  BY department_id;

-- Ejercicio 3: nombre completo, departamento y ciudad de los empleados
--              contratados desde el 1 de enero de 2006.
SELECT e.first_name || ' ' || e.last_name AS empleado,
       d.department_name                  AS departamento,
       l.city                             AS ciudad
FROM   employees   e
JOIN   departments d ON d.department_id = e.department_id
JOIN   locations   l ON l.location_id   = d.location_id
WHERE  e.hire_date >= TO_DATE('2006-01-01', 'YYYY-MM-DD')
ORDER  BY e.hire_date;

-- Ejercicio 4: empleados que ganan más que el promedio de su propio departamento.
SELECT e.first_name, e.last_name, e.department_id, e.salary
FROM   employees e
WHERE  e.salary > (SELECT AVG(x.salary)
                   FROM   employees x
                   WHERE  x.department_id = e.department_id)
ORDER  BY e.department_id, e.salary DESC;
