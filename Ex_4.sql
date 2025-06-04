CREATE DATABASE directores;
USE directores;

CREATE TABLE directores (
DNI varchar(9) UNIQUE NOT NULL PRIMARY KEY ,
nombre_apellidos varchar(255) ,
DNI_jefe varchar(9) NOT NULL,
id_despacho int NOT NULL

);

ALTER TABLE directores MODIFY DNI_jefe varchar(9); 

DROP TABLE despacho;
CREATE TABLE despachos (
id_despacho int NOT NULL PRIMARY KEY AUTO_INCREMENT,
capacidad int NOT NULL
);

insert into directores values
("38888480P", "Peter Parker", "45588448L", 1), ("38554480O", "Bruce Wayne", "56788448L", 2), ("88888660P", "Clark Kent", "40088048L", 3), ("38888555M", "Selina Keyn", "45500048C", 2);

insert into directores values
("65678110P", "Mario Bros", "88888660P", 3), ("67778810P", "Mario Bros", "38554480O",4);

insert into directores values
("67895432N", "Lara Croft", null, 2);

insert into despachos (capacidad) values
(4), (2), (6), (10);

-- 1. Mostrar el DNI, nombre y apellidos de todos los directores.

SELECT DNI, nombre_apellidos as "Nombre y Apellidos" FROM directores;

-- 2. Mostrar los datos de los directores que no tienen jefes.

SELECT * FROM directores WHERE DNI_jefe is NULL;

-- 3. Mostrar el nombre y apellidos de cada director, junto con la capacidad del despacho en el que se
-- encuentra.

SELECT d.nombre_apellidos, de.capacidad as "Capacidad Despacho"
FROM directores d
JOIN despachos de
ON d.id_despacho = de.id_despacho;

-- 4. Mostrar el número de directores que hay en cada despacho.

SELECT id_despacho, COUNT(id_despacho) as "Número de directores"
FROM directores
GROUP BY  id_despacho
ORDER BY id_despacho ASC ;

-- 5. Mostrar los datos de los directores cuyos jefes no tienen jefes.



-- 6. Mostrar los nombres y apellidos de los directores junto con los de su jefe.

SELECT d.nombre_apellidos as "Nombre Director" , j.nombre_apellidos as "Nombre Jefe" 
FROM directores d 
JOIN directores j
ON  d.DNI_jefe = j.DNI;


-- 7. Mostrar el número de despachos que están sobre utilizados.

SELECT COUNT(d.id_despacho)
FROM directores d
WHERE id_despacho IN (
	SELECT d.id_despacho 
    FROM directores d
    JOIN despachos de
    ON d.id_despacho = de.id_despacho
    
    GROUP BY id_departamento HAVING COUNT(DNI)>2
    );
    


-- 8. Añadir un nuevo director llamado Paco Pérez, DNI 28301700, sin jefe, y situado en el despacho 124.
-- 9. Asignar a todos los empleados de apellido Pérez un nuevo jefe con DNI 74568521.
-- 10. Despedir a todos los directores, excepto a los que no 8enen jefe.