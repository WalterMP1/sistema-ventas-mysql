-- CRUD --
-- Hacer un CRUD para registrar ventas (tabla venta y detalle) con una tabla temporal

CREATE TABLE carrito_venta_temp (
  id_producto INT,
  cantidad INT
);

-- PROCEDIMIENTO CON MANEJO DE STOCK

-- Agregar columna de stock
ALTER TABLE productos
ADD stock INT DEFAULT 10;

SET autocommit = 0;
SET SQL_SAFE_UPDATES = 0;

DELIMITER //

CREATE PROCEDURE insertar_venta_completa(
	IN p_id_cliente INT,
    IN p_fecha DATE
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE v_id_producto INT;
    DECLARE v_cantidad INT;
    DECLARE v_precio_unitario DECIMAL (10,2);
    DECLARE v_id_venta INT;
    DECLARE v_stock INT;
    
    DECLARE v_error_msg VARCHAR(255);

    DECLARE cur CURSOR FOR 
		SELECT id_producto, cantidad
        FROM carrito_venta_temp;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
        RESIGNAL;
	END;

    START TRANSACTION;
    
    OPEN cur;
		read_carrito_validacion: LOOP
			FETCH cur INTO v_id_producto, v_cantidad;
			IF done THEN
				LEAVE read_carrito_validacion;
			END IF;
            
            SELECT stock INTO v_stock
			FROM productos
			WHERE id_producto = v_id_producto;
			
			IF v_stock < v_cantidad THEN
				SET v_error_msg = CONCAT('Stock insuficiente para producto ID ', v_id_producto);
                CLOSE cur;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
			END IF;
            
		END LOOP;
	CLOSE cur;
    
    INSERT INTO ventas(id_cliente, fecha)
    VALUES(p_id_cliente, p_fecha);

    SET v_id_venta = LAST_INSERT_ID();
    
	SET done = 0;
    OPEN cur;
		read_carrito: LOOP
        
			FETCH cur INTO v_id_producto, v_cantidad;
			IF done THEN
				LEAVE read_carrito;
			END IF;

			SELECT precio_unitario INTO v_precio_unitario
			FROM productos
			WHERE id_producto = v_id_producto;
			
			IF v_precio_unitario IS NULL THEN
				ITERATE read_carrito;
			END IF;

			INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_venta_unitario)
			VALUES (v_id_venta, v_id_producto, v_cantidad, v_precio_unitario);
			
			UPDATE productos 
			SET stock = stock - v_cantidad
			WHERE id_producto = v_id_producto; 
            
		END LOOP;
	CLOSE cur;

	DELETE FROM carrito_venta_temp;

	COMMIT;
END //

DELIMITER ;


DELETE FROM carrito_venta_temp;
INSERT INTO carrito_venta_temp (id_producto, cantidad) VALUES
(1, 2),
(3, 5);

SELECT * FROM carrito_venta_temp;

CALL insertar_venta_completa(8, CURDATE());

SELECT * FROM productos;
SELECT * FROM ventas ORDER BY id_venta DESC;
SELECT * FROM detalle_venta WHERE id_venta = (SELECT MAX(id_venta) FROM ventas);