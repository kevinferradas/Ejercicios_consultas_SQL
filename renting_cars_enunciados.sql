use renting_cars_simulacro;

INSERT INTO alquileres (id_cliente,id_modelo, fecha_recogida,fecha_entrega,facturacion)
VALUES (2, 3, '2023-12-25', '2023-12-31', 1309);

# Quitar temporalmente la restricción de consultas y evitar error 1055
# SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

-- max(), min(), count(), sum(), avg()

-- 1. ¿Cuál es el modelo (o modelos) más caro y su precio? ¿Y los más baratos?
-- 1a. El más caro

SELECT nombre_modelo as "Modelo más caro", precioDia as "Precio"
FROM modelos
WHERE precioDia in (
SELECT  MAX(precioDia) as "precio" 
FROM modelos
);




-- 1b. El más barato

SELECT nombre_modelo as "Modelo más barato", precioDia as "Precio"
FROM modelos
WHERE precioDia in (
SELECT  MIN(precioDia) as "precio" 
FROM modelos
);
-- 2. ¿Quien fue el primer cliente de la empresa?
-- nombre, apellido, tipo, fecha

SELECT c.nombre , c.apellido, m.tipo , a.fecha_recogida
FROM clientes c
JOIN alquileres a ON c.id_cliente= a.id_cliente
JOIN modelos m ON a.id_modelo = m.id_modelo
ORDER BY a.fecha_recogida ASC
LIMIT 1;

SELECT c.nombre , c.apellido, m.tipo , a.fecha_recogida
FROM clientes c
JOIN alquileres a ON c.id_cliente= a.id_cliente
JOIN modelos m ON a.id_modelo = m.id_modelo
WHERE a.fecha_recogida = (SELECT MIN(fecha_recogida) FROM alquileres);


-- 3. Actualizar tabla de alquileres 

SELECT (datediff(a.fecha_entrega, a.fecha_recogida) +1)*m.precioDia , id_alquiler
FROM alquileres a
NATURAL JOIN modelos m;

UPDATE alquileres a
NATURAL JOIN modelos m 
SET facturacion = (datediff(a.fecha_entrega, a.fecha_recogida) +1)*m.precioDia;

-- 4. Facturación total de 2024 por clientes
-- Nota: se cobra en el momento de la devolución

SELECT SUM(facturacion) as "Facturación total"
FROM alquileres
WHERE YEAR(fecha_entrega)=2024;


-- 5. Promedio de los precios/dia de los coches de cada concesionario
-- Mostrar nombre de concesionario y promedio

-- NO HACER


-- 6. ¿Cuanto ha gastado cada cliente en cada alquiler? ¿Y cuanto ha gastado en total?
# 6A. En cada alquiler

SELECT concat_ws(" ",c.nombre,c.apellido) as cliente, a.facturacion
FROM  clientes c
NATURAL JOIN alquileres a ;


# 6B. En total
SELECT concat_ws(" ",c.nombre,c.apellido) as cliente, SUM(a.facturacion)
FROM  clientes c
NATURAL JOIN alquileres a 
GROUP BY a.id_cliente;


-- 7. Queremos que aparezcan estos mensajes:
-- -- si ha gastado más de 4000 -> "muy buen cliente"
-- -- si ha gastado más de 2000 -> "buen cliente"
-- -- si ha gastado más de 1000 -> "cliente medio"
-- -- si ha gastado igual o menos de 1000 -> "factura poco"

SELECT concat_ws(" ",c.nombre,c.apellido) as cliente, 
CASE
	WHEN SUM(a.facturacion) > 4000 THEN "muy buen cliente"
    WHEN SUM(a.facturacion) > 2000 THEN "buen cliente"
    WHEN SUM(a.facturacion) > 1000 THEN "cliente medio"
    ELSE "factura poco"
END as valoracion
FROM  clientes c
NATURAL




 JOIN alquileres a 
GROUP BY a.id_cliente;

-- 8. Mostrar nombre de cliente, y el importe total gastado
-- Ordenado por importe de más a menos



-- 9. Mostrar nombre de cliente, dias de alquiler, marca, modelo, importe gastado, nombre del concesionario
-- Ordenado por importe de más a menos


-- 10. Tenemos un nuevo cliente, con estos datos:
--  Steve Ballmer, dni y carnet 666666666, email steve@ballmer.com, teléfono 666666666, vive en Roma, password 1234
-- Hay que obtener el id del pais mediante un select, no ponerlo directamente


-- 11. ¿Qué clientes no han alquilado nunca un vehículo?

-- 12. Crea un SP (llamado cars_no_rent) para mostrar los modelos que no se han alquilado nunca.

-- 13. Crea una función (llamada count_city) que, dado el nombre de una población 
-- nos devuelva el número de clientes que viven en esa población.

-- 14. Crea un SP (llamado miising_information) que devuelva el nombre y apellidos de 
-- los clientes que no tienen todos los datos completos (dni, email, teléfono, población, password).
-- Solo con que falte uno de estos datos ya deben aparecer en la lista