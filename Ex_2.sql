CREATE DATABASE almacenes;
USE almacenes;
CREATE TABLE almacenes (
id_almacen INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
lugar varchar(100) not null,
capacidad INT NOT NULL
);

CREATE TABLE cajas (
num_referencia varchar(5) NOT NULL PRIMARY KEY ,
contenido varchar(100) NOT NULL,
valor decimal (6,2) NOT NULL,
id_almacen INT not null );

INSERT INTO almacenes (lugar, capacidad) 
VALUES ("Barcelona", 100),
("Cornellà", 5),
("Hospitalet", 20),
("Badalona", 3);

INSERT INTO cajas (num_referencia, contenido, valor, id_almacen) 
VALUES ("TECL1", "teclados",100,1),
("RAT1", "ratones",200,2),
("TECL2", "teclados",100,4),
("RAT2", "ratones",200,4);



-- 1. Obtener todos los almacenes.
SELECT * from almacenes;

-- 2. Obtener todas las cajas cuyo contenido tenga un valor superior a 150 Bs.
SELECT * FROM cajas WHERE valor > 150;

-- 3. Obtener los tipos de contenidos de las cajas.
SELECT DISTINCT contenido FROM cajas;

-- 4. Obtener el valor medio de todas las cajas.
SELECT AVG(valor) FROM cajas;

-- 5. Obtener el valor medio de las cajas de cada almacén.
SELECT id_almacen, AVG(valor)
FROM cajas 
GROUP BY id_almacen;

-- 6. Obtener los códigos de los almacenes en los cuales el valor medio de las cajas sea superior a 150 Bs.
SELECT id_almacen,AVG(valor)
FROM cajas 
GROUP BY id_almacen
HAVING AVG(valor)>150;

-- 7. Obtener el número de referencia de cada caja junto con el nombre de la ciudad en el que se encuentra.
SELECT c.num_referencia , a.lugar
FROM cajas c
natural join almacenes a;

-- 8. Obtener el número de cajas que hay en cada almacén.
SELECT id_almacen, COUNT(num_referencia)
FROM cajas
GROUP BY id_almacen;

SELECT a.id_almacen, COUNT(a.id_almacen)
FROM almacenes a
LEFT JOIN cajas c
ON a.id_almacen = c.id_almacen
GROUP BY a.id_almacen;

 
