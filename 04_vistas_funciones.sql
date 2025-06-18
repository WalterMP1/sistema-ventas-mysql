-- Vistas, CTE y funciones --

-- 1. Vista de ventas por cliente
CREATE VIEW vista_ventas_por_cliente AS
SELECT c.nombre, COUNT(v.id_venta) AS total_ventas
FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente;

SELECT * FROM vista_ventas_por_cliente;


-- 2. Vista de productos más vendidos
CREATE VIEW vista_productos_mas_vendidos AS
SELECT p.nombre AS Producto, SUM(dv.cantidad) AS Cantidad
FROM productos p
INNER JOIN detalle_venta dv ON dv.id_producto = p.id_producto
GROUP BY p.id_producto
ORDER BY SUM(dv.cantidad) DESC;

SELECT * FROM vista_productos_mas_vendidos;


-- 3. Vista de ingresos por día
CREATE VIEW vista_ingresos_por_dia AS
SELECT v.fecha as Fecha, SUM(dv.cantidad * dv.precio_venta_unitario) AS Total_Diario
FROM detalle_venta dv
INNER JOIN ventas v ON v.id_venta = dv.id_venta
GROUP BY v.fecha
ORDER BY v.fecha;

SELECT * FROM vista_ingresos_por_dia;


-- 1. Función que calcula total de una venta
DELIMITER //

CREATE FUNCTION total_venta_por_id(id_venta INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(cantidad * precio_venta_unitario)
  INTO total
  FROM detalle_venta
  WHERE detalle_venta.id_venta = id_venta;
  RETURN total;
END //

DELIMITER ;

SELECT total_venta_por_id(9);


-- 2. Función que devuelve el total comprado por un cliente
DELIMITER //

CREATE FUNCTION total_comprado_cliente(id_cliente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE total DECIMAL(10,2);
    
	SELECT SUM(dv.cantidad * dv.precio_venta_unitario)
	INTO total
	FROM detalle_venta dv
	INNER JOIN ventas v ON v.id_venta = dv.id_venta
	WHERE v.id_cliente = id_cliente;
    
	RETURN total;
END //

DELIMITER ;

SELECT total_comprado_cliente(9);


-- Ejercicio 1: Total de dinero gastado por cliente

WITH total_cliente AS (
SELECT v.id_cliente, SUM(dv.cantidad * dv.precio_venta_unitario) AS Total
FROM detalle_venta dv
INNER JOIN ventas v ON v.id_venta = dv.id_venta
INNER JOIN clientes c ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente
)
SELECT c.nombre AS Cliente, t.Total
FROM clientes c
INNER JOIN total_cliente t ON t.id_cliente = c.id_cliente
ORDER BY t.Total DESC;


-- Ejercicio 2: Productos más vendidos y su marca
WITH ventas_por_producto AS (
SELECT id_producto, SUM(cantidad) as Cantidad
FROM detalle_venta
GROUP BY id_producto
)
SELECT p.nombre AS Producto, m.nombre AS Marca, vp.Cantidad
FROM productos p
INNER JOIN marcas m ON m.id_marca = p.id_marca
INNER JOIN ventas_por_producto vp ON vp.id_producto = p.id_producto
ORDER BY vp.Cantidad DESC
