CREATE DATABASE ejercicio_07;
USE ejercicio_07;

CREATE TABLE provincias (
cod_pro char(2) not null primary key,
nombre_provincia varchar(50)
);
CREATE TABLE pueblos (
cod_pue char(3) not null primary key,
nombre_pueblo varchar(50),
cod_pro char(2) not null
);

INSERT INTO pueblos (cod_pue, nombre_pueblo, cod_pro)
VALUES ("HOS", "Hospitalet", 1) , ("COR", "Cornellà", 1) , ("ESP", "Esplugues", 1) , ("COL", "Santa Coloma", 1)
, ("Cun", "Cunit", 3) , ("Van", "Vandellòs", 3) , 
("Ser", "Seròs",4), ("Tre", "Tremp",4),
("Ban", "Banyolès",2) , ("Tos", "Tossa",2) 
; 

CREATE TABLE clientes (
cod_cli int not null primary key auto_increment,
nombre_cliente varchar(100) not null,
direccion_cli varchar(100) not null,
codpostal_cli char(5),
cod_pue char(3)
);

INSERT INTO clientes (nombre_cliente , direccion_cli , codpostal_cli , cod_pue)
VALUES ("Peter Parker", "Corsega 400" , "08045", "COR" ) ,
("RobinHood", "C/ Del Chorizo" , "08999", "COL" ),
("Anibal Lecter", "C/ Del Vegano " , "18300", "TOS" ),
("Aitana Bonmatí", "C/ Gamper" , "40666", "TRE" ) ;

CREATE TABLE vendedores (
cod_ven int not null primary key auto_increment,
nombre_vendedor varchar(100) not null,
direccion_ven varchar(100) not null,
codpostal_ven char(5),
cod_pue char(3)
);

INSERT INTO vendedores (nombre_vendedor , direccion_ven , codpostal_ven , cod_pue)
VALUES ("Jan Laporta", "C/ Gamper" , "40666", "TRE" ) ,
("Florentino", "C/ Del Chorizo" , "08999", "COL" ) ;

CREATE TABLE articulos (
cod_art int not null primary key auto_increment,
descripcion_art varchar(100) not null,
precio_art decimal(8,2),
stock_art int,
stock_min int
);

Insert into articulos (descripcion_art, precio_art, stock_art , stock_min)
VALUES ("Teclados", 20, 10, 5), ("Monitor Samsung" , 200, 3, 0), ("Monitor LG" , 300, 1, 0), ("SSD WD" ,100, 5, 5)  ;

CREATE TABLE facturas (
cod_fac int not null primary key auto_increment,
fecha_fac datetime,
cod_ven int,
cod_cli int,
iva int,
descuento_fac decimal(5,2)
);

alter table facturas MODIFY iva decimal(5,2);

INSERT INTO facturas (fecha_fac, cod_ven, cod_cli , iva, descuento_fac) VALUES
("2025-05-30",1,2,0.21,5), ("2025-05-15",1,1,0.21,10),
("2025-05-30",1,2,0.21,5), ("2025-05-12",2,4,0.21,20) ;


CREATE TABLE lineas_fac (
cod_lin_fac int not null primary key auto_increment,
cod_fac int,
cant_lin decimal(8,2),
cod_art int,
precio decimal(8,2),
descuento_lin decimal(5,2)
);

INSERT INTO lineas_fac (cod_fac, cant_lin, cod_art , precio, descuento_lin) VALUES
(1,2,2,250,.1), (2,2,1,30,.05),
(3,3,3,400,.1), (3,2,1,30,.05)  ;

insert into provincias (cod_pro, nombre_provincia) VALUES
("BA", "Barcelona"), ("GI", "Girona"), ("TA", "Tarragona"), ("LL", "Lleida");
SELECT nombre_provincia FROM provincias;






-- Nota: L as claves foráneas en los modelos relacionales presentes en este documento se representan en cursiva y negrita. 
 -- 1. Mostrar las provincias 
-- 2. Nombre y código de las provincias. 

-- 3. Mostrar el código de los arYculos y el doble del precio de cada arYculo. 

SELECT cod_art, (precio_art*2) as "precio doble" FROM articulos; 

-- 4. Mostrar el código de la factura, número de línea e importe de cada línea (sin considerar impuestos ni descuentos. 

SELECT cod_lin_fac, cod_fac, precio FROM lineas_fac;

-- 5. Mostrar los dis8ntos 8pos de IVA aplicados en las facturas. 

SELECT DISTINCT iva FROM facturas;

-- 6. Mostrar el código y nombre de aquellas provincias cuyo código es menor a 20. 



-- 7. Mostrar los distintos tipos de descuento  aplicados por los vendedores  cuyos códigos no superan el valor 50. 
 
 
-- 8. Mostrar el código y descripción de aquellos articulos cuyo stock es igual o supera las 2 unidades.

SELECT cod_art as CODIGO, descripcion_art as DESCRIPCION FROM articulos WHERE stock_art > 2;
 


-- 9. Mostrar el código y fechas de las facturas con IVA 21  y que pertenecen al cliente de código 2. 

SELECT cod_fac,fecha_fac FROM facturas WHERE iva = 0.21 AND cod_cli =2;

-- 10. Mostrar el código  y fechas de las facturas con IVA 21 
-- o con descuento 10% y que pertenecen al cliente de código 1.

SELECT cod_fac, fecha_fac FROM facturas WHERE (iva = 0.21 or descuento_fac = 10) AND cod_cli =1;

-- 11.  Mostrar el código de la factura y el número de línea de las facturas 
-- cuyas líneas superan 100 euros sin considerar descuentos ni impuestos.






-- 12. Importe medio por factura, sin considerar descuentos ni impuestos. El importe de una factura se 
-- calcula sumando el producto de la cantidad por el precio de sus líneas. 

SELECT cod_fac, AVG(precio* cant_lin) as media FROM lineas_fac GROUP BY cod_fac;

-- 13. Stock medio, máximo, y mínimo de los artículos que contienen la letra o en la segunda posición 
-- de su descripción y cuyo stock mínimo es superior a la mitad de su stock actual. 

SELECT descripcion_art, AVG(stock_art) as media, MAX(stock_art) as maximo, MIN(stock_art) as minimo
FROM articulos
where descripcion_art LIKE "_O%" AND stock_min > (stock_art/2)
GROUP BY descripcion_art;

-- 14. Número de facturas para cada año. Junto con el año debe aparecer el número de facturas de ese año.
 SELECT YEAR(fecha_fac);
 
-- 15. Número de facturas de cada cliente, pero sólo se deben mostrar aquellos clientes que tienen menos de 2 facturas.

SELECT cod_cli, COUNT(*) as cantidad_fac FROM facturas GROUP BY cod_cli HAVING cantidad_fac < 2 ; 
 
-- 16. Cantidades totales vendidas para cada artículo cuyo descripción empiece por “M”. La cantidad total 
-- vendida de un artículo se calcula sumando las cantidades de todas sus líneas de factura.

SELECT a.cod_art, a.descripcion_art, SUM(l.cant_lin)
FROM articulos a
JOIN lineas_fac l
ON a.cod_art = l.cod_art
WHERE a.descripcion_art LIKE "M%"
GROUP BY l.cod_art;
 


-- 17. Código de aquellos arYculos de los que se ha facturado más de 6000 euros. 
 
18. Número de facturas de cada uno de los clientes cuyo código está entre 241 y 250, con cada IVA 
dis8nto que se les ha aplicado. En cada línea del resultado se debe mostrar un código de cliente, 
un IVA y el número de facturas de ese cliente con ese IVA. 
19. Vendedores y clientes cuyo nombre coincide (vendedores que a su vez han comprado algo a la 
empresa) 
 
20. Creación de una vista que muestre únicamente los códigos postales de los clientes que inicien con 
el número 12. 
21. Mostrar el código y el nombre de los clientes de Castellón (posee código 12) que han realizado 
facturas con vendedores de más de dos provincias dis8ntas. El resultado debe quedar ordenado 
ascendentemente respecto del nombre del cliente.
