-- Consultas Complejas --

 -- 1. Productos vendidos junto con su marca y proveedor y de cual venta fueron
SELECT v.id_venta, p.nombre as Producto, m.nombre as Marca, pr.nombre as Proveedor
FROM detalle_venta dv
INNER JOIN productos p ON p.id_producto = dv.id_producto
INNER JOIN marcas m ON m.id_marca = p.id_marca
INNER JOIN proveedores pr ON pr.id_proveedor = p.id_proveedor
INNER JOIN ventas v ON v.id_venta = dv.id_venta
ORDER BY id_venta;


-- 2. Ventas con nombre del cliente y fecha
SELECT c.nombre AS Cliente, v.fecha AS Fecha_Venta
FROM ventas v
INNER JOIN clientes c ON c.id_cliente = v.id_cliente;


-- 3. Total recaudado por cada venta (JOIN + SUM + GROUP BY)
SELECT v.id_venta AS Numero_Venta, SUM(dv.cantidad * dv.precio_venta_unitario) AS Total
FROM ventas v
INNER JOIN detalle_venta dv ON dv.id_venta = v.id_venta
GROUP BY v.id_venta;


-- 4. Clientes que han comprado más de 2 productos distintos (HAVING)
SELECT c.nombre as Cliente, COUNT(DISTINCT dv.id_producto) as Productos_Diferentes
FROM clientes c
INNER JOIN ventas v ON v.id_cliente = c.id_cliente
INNER JOIN detalle_venta dv ON dv.id_venta = v.id_venta
GROUP BY c.id_cliente
HAVING COUNT(DISTINCT dv.id_producto) > 2;


 -- 5. Promedio de precio por marca (JOIN + AVG)
SELECT m.nombre as Marca, AVG(p.precio_unitario) as Precio_Promedio
FROM marcas m
INNER JOIN productos p ON p.id_marca = m.id_marca
GROUP BY m.id_marca;


-- 6. Producto más caro vendido (SUBCONSULTA + MAX)
SELECT DISTINCT p.nombre AS Producto, dv.precio_venta_unitario
FROM detalle_venta dv
INNER JOIN productos p ON dv.id_producto = p.id_producto
WHERE dv.precio_venta_unitario = (
	SELECT MAX(precio_venta_unitario) FROM detalle_venta
);


-- 7. Clientes que compraron productos Huawei y cuantos
SELECT DISTINCT c.nombre AS Cliente, COUNT(*) as Cantidad
FROM clientes c
INNER JOIN ventas v ON v.id_cliente = c.id_cliente
INNER JOIN detalle_venta dv ON dv.id_venta = v.id_venta
INNER JOIN productos p ON p.id_producto = dv.id_producto
INNER JOIN marcas m ON m.id_marca = p.id_marca
WHERE m.nombre = 'Huawei'
GROUP BY c.id_cliente;


-- 8. Ventas donde se compraron más de 2 celulares
SELECT v.id_venta AS Venta, c.nombre AS Cliente, COUNT(*) AS Celulares_Vendidos
FROM ventas v
INNER JOIN clientes c ON c.id_cliente = v.id_cliente
INNER JOIN detalle_venta dv ON dv.id_venta = v.id_venta
GROUP BY v.id_venta
HAVING COUNT(*) > 2
ORDER BY v.id_venta;


-- 9. CROSS JOIN: combinación de todos los productos con proveedores
SELECT p.nombre AS producto, pr.nombre AS proveedor
FROM productos p
CROSS JOIN proveedores pr;


-- 10. Subconsulta correlacionada: productos más caros que el promedio de su marca
SELECT p.nombre as Producto, p.precio_unitario as Precio
FROM productos p
WHERE p.precio_unitario > (
	SELECT AVG(p2.precio_unitario)
    FROM productos p2
    WHERE p2.id_marca = p.id_marca
);