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
	FROM proveedores WHERE nombre_producto = p_nombre_producto;
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
-- La salida final será nombre_cliente apellido_cliente  nombre_producto cantidad

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
