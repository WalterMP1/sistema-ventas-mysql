-- Cursores --

-- Cursor simple con registro en log
-- Objetivo:
-- Recorrer ventas y guardar en otra tabla el total por venta.

SET SQL_SAFE_UPDATES = 0;
CREATE TABLE resumen_ventas (
    id_venta INT,
    total FLOAT
);


DELIMITER //

CREATE PROCEDURE procesar_ventas()
BEGIN 
	DECLARE done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_total DECIMAL(10,2);
    
    DECLARE cur CURSOR FOR
		SELECT v.id_cliente, SUM(dv.cantidad * dv.precio_venta_unitario)
        FROM detalle_venta dv
        INNER JOIN ventas v ON dv.id_venta = v.id_venta
        GROUP BY v.id_cliente;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    DELETE FROM resumen_ventas;
    
    OPEN cur;
    
    read_loop: LOOP
		FETCH cur INTO v_id, v_total;
        IF done THEN
			LEAVE read_loop;
        END IF;
		
        
		INSERT INTO resumen_ventas (id_venta, total)
        VALUES (v_id, v_total);
    END LOOP;
    
    CLOSE cur;
END //

DELIMITER ;

CALL procesar_ventas();
SELECT * FROM resumen_ventas;
	


-- Cursor con lógica condicional y errores
-- Objetivo:
-- Detectar clientes que han comprado más de $25,000 y guardarlos en una tabla VIP.

CREATE TABLE clientes_vip (
    id_cliente INT,
    nombre_cliente VARCHAR(100),
    total_comprado FLOAT
);

DELIMITER //

CREATE PROCEDURE detectar_clientes_vip()
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_nombre VARCHAR(40);
    DECLARE v_total DECIMAL(10,2);
    
    DECLARE cur CURSOR FOR
		SELECT c.id_cliente, c.nombre, SUM(dv.cantidad * dv.precio_venta_unitario)
        FROM clientes c
        INNER JOIN ventas v ON c.id_cliente = v.id_cliente
		INNER JOIN detalle_venta dv ON v.id_venta = dv.id_venta
        GROUP BY c.id_cliente;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	DELETE FROM clientes_vip;
    
    OPEN cur;
    
    read_loop: LOOP
		FETCH cur INTO v_id, v_nombre, v_total;
        IF done THEN
			LEAVE read_loop;
        END IF;
        
        IF v_total > 25000 THEN
			INSERT clientes_vip (id_cliente, nombre_cliente, total_comprado)
            VALUES (v_id, v_nombre, v_total);
        END IF;
                
    END LOOP;
    
    CLOSE cur;
	
END //

DELIMITER ;

CALL detectar_clientes_vip();
SELECT * FROM clientes_vip;

