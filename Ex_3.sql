CREATE DATABASE peliculas;
USE peliculas;

CREATE TABLE salas  (
id_sala INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_sala varchar(100) NOT NULL,
id_pelicula INT NOT NULL 
);
ALTER TABLE salas MODIFY id_pelicula INT;
CREATE TABLE peliculas (
id_pelicula INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
titulo_pelicula varchar(100) NOT NULL,
calificacion_edad int 
);

INSERT INTO peliculas (titulo_pelicula, calificacion_edad) VALUES
("Batman",12),("Bambi",18),("Tiburón",6),("El conclave",12);

INSERT INTO peliculas (titulo_pelicula, calificacion_edad) VALUES
("Shreck", null ), ("Scream", null);

INSERT INTO salas (nombre_sala,id_pelicula) VALUES
("Stucom",1),("SQL",3),("Vaticano",4);

INSERT INTO salas (nombre_sala,id_pelicula) VALUES
("HTML",null),("PHP",null);

-- 1. Mostrar el nombre de todas las películas.
SELECT titulo_pelicula FROM peliculas;

-- 2. Mostrar las dis8ntas calificaciones de edad que existen.
SELECT DISTINCT calificacion_edad FROM peliculas; 

-- 3. Mostrar todas las películas que no han sido calificadas.
SELECT titulo_pelicula FROM peliculas WHERE calificacion_edad is null;

-- 4. Mostrar todas las salas que no proyectan ninguna película.
SELECT nombre_sala FROM salas WHERE id_pelicula is NULL;

-- 5a. Mostrar la información de todas las salas y, si se proyecta alguna película en la sala, mostrar
-- también la información de la película.
SELECT *
FROM salas s
left JOIN peliculas p
ON s.id_pelicula = p.id_pelicula;

-- 5b. Mostrar el nombre de todas las salas y, si se proyecta alguna película en la sala, mostrar
-- también el titulo de la película.
SELECT s.nombre_sala, IFNULL(p.titulo_pelicula, "No hay pelicula todavia") as peliculas
FROM salas s
left JOIN peliculas p
ON s.id_pelicula = p.id_pelicula;

-- 6. Mostrar la información de todas las películas y, si se proyecta en alguna sala, mostrar también la
-- información de la sala.
 SELECT *
 FROM peliculas p
 LEFT JOIN salas s
 ON p.id_pelicula = s.id_pelicula;

-- 7. Mostrar los nombres de las películas que no se proyectan en ninguna sala.
SELECT p.titulo_pelicula
FROM peliculas p
LEFT JOIN salas s
ON p.id_pelicula = s.id_pelicula
WHERE s.id_pelicula IS NULL;

-- 8. Añadir una nueva pelıcula ‘Uno, Dos, Tres’, para mayores de 7 años.
-- Y después hacer que se proyecte al menos en 4 salas

INSERT INTO peliculas (titulo_pelicula, calificacion_edad)
 VALUES ("Uno, Dos, Tres",7);

SET @id_123 = (SELECT id_pelicula FROM peliculas
 where titulo_pelicula = "Uno, Dos, Tres");

SELECT @id_123;
 
INSERT INTO salas (nombre_sala,id_pelicula) VALUES
("Stucom",@id_123),("SQL",@id_123),("Vaticano",@id_123);

INSERT INTO salas (nombre_sala,id_pelicula) VALUES
("HTML",@id_123);


SELECT titulo_pelicula, COUNT(s.id_pelicula) as cantidad,
	CASE
		WHEN COUNT(cantidad) > 3 THEN " Pelicula muy popular"
        WHEN COUNT(cantidad) > 1 THEN " Bastante conocida"
        ELSE "no la ha visto nadie"
	END as popularidad
FROM salas s
RIGHT JOIN peliculas p
ON p.id_pelicula = s.id_pelicula
GROUP BY titulo_pelicula
ORDER BY cantidad desc;
 
-- 9. Hacer constar que todas las películas no calificadas han sido calificadas ‘no recomendables para
-- menores de 13 años’.

UPDATE peliculas SET calificacion_edad = 13
WHERE calificacion_edad IS NULL ;


-- 10. Eliminar todas las salas que proyectan películas recomendadas para todos los públicos.
DELETE FROM salas
WHERE id_pelicula IN (
	SELECT id_pelicula
    FROM peliculas
    WHERE calificacion_edad <12
    );