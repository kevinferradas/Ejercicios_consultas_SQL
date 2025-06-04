CREATE DATABASE tienda;
USE tienda;

CREATE TABLE productos (
id_producto int auto_increment primary key,
nombre_producto varchar(50) not null,
precio decimal(8, 2) not null,
stock_actual int not null,
ventas_producto int not null,
id_proveedor int not null
);

ALTER TABLE productos
MODIFY COLUMN ventas_producto int DEFAULT 0;

CREATE TABLE proveedores (
id_proveedor int auto_increment primary key,
nombre_proveedor varchar(50) not null
);

CREATE TABLE clientes (
id_cliente int auto_increment primary key, 
nombre_cliente varchar(50) not null,
apellido_cliente varchar(100) not null,
id_pais int
);

CREATE TABLE paises (
id_pais int auto_increment primary key, 
nombre_pais varchar(50)
);

CREATE TABLE facturas (
id_factura int auto_increment primary key,
id_cliente int not null,
id_producto int not null,
cantidad int not null, 
fecha_compra datetime default current_timestamp
);

DROP PROCEDURE IF EXISTS insertar_productos;

DELIMITER $$
CREATE PROCEDURE insertar_productos (
p_nombre_producto VARCHAR(50),
p_precio decimal(8,2),
p_stock int,
p_nombre_proveedor VARCHAR (50) )
BEGIN
-- Variable para guardar el id del proveedor si existe
DECLARE v_id_proveedor int;
DECLARE v_id_producto int;

SELECT id_proveedor INTO v_id_proveedor
FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;

IF v_id_proveedor IS NULL THEN
	INSERT INTO proveedores (nombre_proveedor) VALUES (p_nombre_proveedor);
    SELECT id_proveedor INTO v_id_proveedor
	FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;
    END IF;

SELECT id_producto INTO v_id_producto
FROM productos WHERE nombre_producto = p_nombre_producto;
IF v_id_producto IS NULL THEN
-- Si v_id_producto es nulo significa que no estaba 
-- y por eso hay que añadir el producto a la tabla
	INSERT INTO productos(nombre_producto, precio, stock_actual, id_proveedor)
    VALUES (p_nombre_producto, p_precio, p_stock, v_id_proveedor);
    SELECT concat_ws(" ", "Producto", p_nombre_producto, "añadido a la tabla");
ELSE 
	UPDATE productos set precio = p_precio, stock_actual = stock_actual + p_stock
    WHERE id_producto = v_id_producto;
    SELECT concat_ws(" ", "Producto", p_nombre_producto, "actualizado");
END IF;
END $$
DELIMITER ;

CALL insertar_productos("Iphone 27", 5000.75, 2, "Apple");
CALL insertar_productos("Iphone 27", 6000.75, 3, "Apple");
CALL insertar_productos("S35", 1000, 5, "Samsung");

DROP TRIGGER IF EXISTS tr_verificar_stock;
DELIMITER //
CREATE TRIGGER tr_verificar_stock
BEFORE INSERT ON facturas
FOR EACH ROW
BEGIN
	DECLARE v_stock int;
    SELECT stock_actual INTO v_stock
    FROM productos WHERE id_producto = NEW.id_producto;
    IF v_stock < NEW.cantidad THEN
		SIGNAL SQLSTATE "45000" 
        SET MESSAGE_TEXT = "NO hay suficiente stock";
	ELSE 
		UPDATE productos set stock_actual = stock_actual - NEW.cantidad,
        ventas_producto = ventas_producto + NEW.cantidad
        WHERE id_producto = NEW.id_producto;     
    END IF;    
END //
DELIMITER ;

INSERT INTO clientes(nombre_cliente, apellido_cliente) VALUES
("Peter", "Parker"), ("Beyoncé", "Pérez");

--  VENTAS DE PRODUCTOS
INSERT INTO facturas(id_cliente, id_producto, cantidad)
VALUES (1, 1, 1);
INSERT INTO facturas(id_cliente, id_producto, cantidad)
VALUES (2, 2, 20);

-- CREAR SP PARA VENDER PRODUCTOS
-- Si el cliente no está, lo añadimos a la tabla
-- Si el producto no lo tenemos, mostramos un mensaje de error
-- La salida final será nombre_cliente apellido_cliente 
-- nombre_producto cantidad precio importe
-- ("Robin", "Hood", "Iphone 27", 2)

DROP PROCEDURE IF EXISTS vender_productos;

DELIMITER $$
CREATE PROCEDURE vender_productos (
p_nombre_cliente VARCHAR (50),
p_apellido_cliente VARCHAR (100),
p_nombre_producto VARCHAR(50),
p_cantidad int)
BEGIN
-- Variable para guardar el id del proveedor si existe
DECLARE v_id_cliente int;
DECLARE v_id_producto int;

SELECT id_cliente INTO v_id_cliente
FROM clientes WHERE nombre_cliente = p_nombre_cliente AND apellido_cliente = p_apellido_cliente ;

-- Si el cliente no está, lo añadimos a la tabla
IF v_id_cliente IS NULL THEN
	INSERT INTO clientes (nombre_cliente,apellido_cliente) VALUES (p_nombre_cliente, p_apellido_cliente);
    SELECT id_cliente INTO v_id_cliente
	FROM clientes WHERE nombre_cliente = p_nombre_cliente;
END IF;


SELECT id_producto INTO v_id_producto
FROM productos WHERE nombre_producto = p_nombre_producto;
-- Si el producto no lo tenemos, mostramos un mensaje de error

IF v_id_producto IS NULL THEN
		SIGNAL SQLSTATE "45001" 
        SET MESSAGE_TEXT = "No tenemos el producto solicitado";
	ELSE 
		UPDATE productos set stock_actual = stock_actual - p_cantidad,
        ventas_producto = ventas_producto + p_cantidad
        WHERE id_producto = v_id_producto;
        SELECT concat_ws(" ", "Producto", p_nombre_producto, "actualizado");
END IF;
END $$
DELIMITER ;

CALL vender_productos("Peter", "Parker", "S35", 1);

SELECT SUM(f.cantidad * p.precio) as "Total vendido"
FROM facturas f
NATURAL JOIN productos p
WHERE YEAR(f.fecha_compra) = 2023 ;

DROP FUNCTION IF EXISTS facturacion_anual;

DELIMITER $$
CREATE FUNCTION facturacion_anual (p_year_fact year)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE v_valor decimal(10, 2);
SELECT SUM(f.cantidad * p.precio) as "Total vendido" INTO v_valor
FROM facturas f
NATURAL JOIN productos p
WHERE YEAR(f.fecha_compra) = p_year_fact ;

IF v_valor IS NULL THEN
	RETURN concat_ws(" ", "El año", p_year_fact, "no ha habido facturación");
ELSE
	RETURN concat_ws(" ", "El año", p_year_fact, "la facturación ha sido", v_valor, "€");
END IF;
END $$
DELIMITER ;


-- 04/06/2025

DROP PROCEDURE insertar_productos_2;
DELIMITER $$
CREATE PROCEDURE insertar_productos_2 (
IN p_nombre_producto VARCHAR(50),
IN p_precio decimal(8,2),
IN p_stock int,
IN p_nombre_proveedor VARCHAR (50),
OUT p_stock_actualizado int )
BEGIN
-- Variable para guardar el id del proveedor si existe
DECLARE v_id_proveedor int;
DECLARE v_id_producto int;

SELECT id_proveedor INTO v_id_proveedor
FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;

IF v_id_proveedor IS NULL THEN
	INSERT INTO proveedores (nombre_proveedor) VALUES (p_nombre_proveedor);
    SELECT id_proveedor INTO v_id_proveedor
	FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;
END IF;

SELECT id_producto INTO v_id_producto
FROM productos WHERE nombre_producto = p_nombre_producto;
IF v_id_producto IS NULL THEN
-- Si v_id_producto es nulo significa que no estaba 
-- y por eso hay que añadir el producto a la tabla
	INSERT INTO productos(nombre_producto, precio, stock_actual, id_proveedor)
    VALUES (p_nombre_producto, p_precio, p_stock, v_id_proveedor);
    SELECT concat_ws(" ", "Producto", p_nombre_producto, "añadido a la tabla");
	SET p_stock_actualizado = p_stock;

ELSE 
	UPDATE productos set precio = p_precio, stock_actual = stock_actual + p_stock
    WHERE id_producto = v_id_producto;
    SELECT concat_ws(" ", "Producto", p_nombre_producto, "actualizado");
	SET p_stock_actualizado = (SELECT stock_actual FROM productos WHERE id_producto = v_id_producto);
END IF;
END $$
DELIMITER ;


SET @stock_producto_actualizado = 0;
CALL insertar_productos_2("MacBook", 2000, 5, "Apple", @stock_producto_actualizado);
CALL insertar_productos_2("Teclado Logitech", 50, 5, "Logitech", @stock_producto_actualizado);


SELECT @stock_producto_actualizado;

-- Necesitamos la información completa de la base de datos:
  -- los clientes , qué han comprado, la fecha de la factura y  quien era el proveedor
  -- Pero no hay que poner los "ids"

DROP VIEW IF EXISTS datos_totales;
CREATE VIEW datos_totales as
SELECT c.nombre_cliente , p.nombre_producto , f.fecha_compra, pr.nombre_proveedor,p.precio,p.stock_actual,p.ventas_producto
FROM clientes c
LEFT JOIN facturas f ON c.id_cliente = f.id_cliente
JOIN productos p ON f.id_producto = p.id_producto
JOIN proveedores pr ON p.id_proveedor = pr.id_proveedor
ORDER BY f.fecha_compra ;

SELECT * FROM datos_totales;
SELECT nombre_cliente as nombre FROM datos_totales;

ALTER TABLE clientes
MODIFY id_pais int DEFAULT 1 ;

INSERT INTO clientes (nombre_cliente, apellido_cliente, id_pais)
VALUES ("Michael","Corleone",2) , ("Jean-Luc","Piccard",3) , ("Luc","Skywalker",2),
	   ("Jules","Verne",3) , ("Clark","Kent",2) , ("Leia","Skywalker",2) ;
       
-- Queremos saber qué clientes son del mismo país y que código de país es.ALTER

SELECT concat_ws(" ", A.nombre_cliente, A.apellido_cliente) as cliente1,
concat_ws(B.nombre_cliente," ", B.apellido_cliente) as cliente2, A.id_pais
FROM clientes A, clientes B
WHERE A.id_pais = B.id_pais AND A.id_cliente <> B.id_cliente 
ORDER BY A.id_pais; 

-- Ver los usuarios actuales
SELECT * FROM mysql.user;

-- CREAR USUARIO
CREATE USER "admin_tienda"@"127.0.0.1" identified by "1234";
CREATE USER "admin_tienda"@"%" identified by "1234";
GRANT SELECT ON tienda.* TO "admin_tienda"@"127.0.0.1";
GRANT INSERT, UPDATE, DELETE ON tienda.* TO "admin_tienda"@"127.0.0.1";
GRANT ALL PRIVILEGES ON tienda.* TO "admin_tienda"@"127.0.0.1" WITH GRANT OPTION;
GRANT CREATE ROUTINE, EXECUTE ON tienda.* TO "admin_tienda"@"127.0.0.1" WITH GRANT OPTION;




SHOW GRANTS FOR "admin_tienda"@"127.0.0.1";
SHOW GRANTS FOR "root"@"localhost";