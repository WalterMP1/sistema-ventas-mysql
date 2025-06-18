-- CREACIÓN DE LA BASE DE DATOS Y TABLAS

CREATE DATABASE tienda_celulares;
USE tienda_celulares;

CREATE TABLE clientes
(
	id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(100)
);

CREATE TABLE proveedores
(
	id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(100)
);

CREATE TABLE marcas
(
	id_marca INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE productos
(
	id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    id_marca INT,
    precio_unitario DECIMAL(10,2),
    id_proveedor INT,
    FOREIGN KEY (id_marca) REFERENCES marcas(id_marca),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

CREATE TABLE ventas
(
	id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE detalle_venta
(
	id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    cantidad INT,
    precio_venta_unitario DECIMAL(10,2),
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);