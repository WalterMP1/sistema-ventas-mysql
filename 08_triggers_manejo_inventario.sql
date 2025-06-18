-- Reporte para productos con stock bajo (< a 5)
CREATE VIEW productos_poco_stock AS
SELECT nombre as Producto, stock AS Stock
FROM productos 
WHERE stock < 5;

SELECT * FROM productos_poco_stock;

-- Trigger que manda alertas cuando hay menos de 3 productos en stock con una tabla de alertas
CREATE TABLE alertas_stock (
  id_alerta INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  stock_actual INT,
  fecha DATETIME,
  mensaje VARCHAR(255)
);	
	
SELECT * FROM alertas_stock

DELIMITER //

CREATE TRIGGER alerta_stock_bajo
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN 
	IF NEW.stock <= 5 AND NEW.stock < OLD.stock THEN
		INSERT INTO alertas_stock (id_producto, stock_actual, fecha, mensaje)
		VALUES(
			NEW.id_producto,
			NEW.stock,
			CURDATE(),
			CONCAT('El producto ', NEW.id_producto, 'es bajo ', NEW.stock)
		);
    END IF;
END //

DELIMITER ;


-- MOVIMIENTOS DE PRODUCTOS, ENTRADAS Y SALIDAS CON TABLA 

CREATE TABLE movimientos_inventario (
  id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  tipo_movimiento ENUM('ENTRADA', 'SALIDA'),
  cantidad INT,
  fecha DATETIME,
  descripcion VARCHAR(255)
);
	
SELECT * FROM movimientos_inventario

DELIMITER //

CREATE TRIGGER guardar_salidas_inventario
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
	IF NEW.stock < OLD.stock THEN
		INSERT INTO movimientos_inventario (id_producto, tipo_movimiento, cantidad, fecha, descripcion)
        VALUES (
			NEW.id_producto,
			'SALIDA',
			OLD.stock - NEW.stock,
			NOW(),
			'Salida por venta'
		);
    END IF;
END //

DELIMITER ; 


-- Procedimiento para registrar entrada de productos
DELIMITER //

CREATE PROCEDURE guardar_entradas_inventario (
	IN p_id_producto INT,
    IN p_cantidad INT,
    IN p_descripcion VARCHAR (255)
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
	
	UPDATE productos
    SET stock = stock + p_cantidad
    WHERE id_producto = p_id_producto;
    
    INSERT INTO movimientos_inventario (id_producto, tipo_movimiento, cantidad, fecha, descripcion)
        VALUES (
			p_id_producto,
			'ENTRADA',
			p_cantidad,
			NOW(),
			p_descripcion
		);
        
	COMMIT;
END //
DELIMITER ;

CALL guardar_entradas_inventario(1, 7, 'Resurtido de proveedor');
SELECT * FROM productos;