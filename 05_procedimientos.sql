-- Procedimientods Almacenados --

-- 1. Registrar una venta (cliente, fecha, productos) para despues agregarle los detalles
DELIMITER //

CREATE PROCEDURE registrar_venta (
	IN p_id_cliente INT,
    IN p_fecha DATE,
    OUT p_id_venta INT
)
BEGIN
	INSERT INTO ventas (id_cliente, fecha)
    VALUES (p_id_cliente, p_fecha);
    
    SET p_id_venta = LAST_INSERT_ID();
END //

DELIMITER ;

-- 2: Agregar un producto al detalle de venta
DELIMITER //

CREATE PROCEDURE agregar_producto_a_venta (
	IN p_id_venta INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
	DECLARE v_precio DECIMAL(10,2);
    
    SELECT precio_unitario INTO v_precio
    FROM productos
    WHERE id_producto = p_id_producto;
    
    INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_venta_unitario)
    VALUES (p_id_venta, p_id_producto, p_cantidad, v_precio);
    
END //

DELIMITER ;

-- PRIMERO CREAR LA VENTA
SET @id_nueva_venta = 0;
CALL registrar_venta(5, '2025-05-30', @id_nueva_venta);

-- AGREGAR LOS DETALLES
CALL agregar_producto_a_venta(@id_nueva_venta, 3, 2);  -- Producto 3, cantidad 2
CALL agregar_producto_a_venta(@id_nueva_venta, 5, 1);  -- Producto 5, cantidad 1



-- 3. Calcular total de dinero gastado por cliente (OUT)
DELIMITER //

CREATE PROCEDURE total_ventas_cliente (
	IN p_id_cliente INT,
    OUT p_total DECIMAL(10,2)
)
BEGIN
	SELECT SUM(dv.cantidad * dv.precio_venta_unitario)
	INTO p_total
    FROM ventas v
    INNER JOIN detalle_venta dv ON dv.id_venta = v.id_venta
    WHERE v.id_cliente = p_id_cliente;
END//

DELIMITER ;

SET @total_ventas = 0;
CALL total_ventas_cliente(3, @total_ventas);
SELECT @total_ventas;


-- 4. Actualizar precio de productos según la marca
DELIMITER //
CREATE PROCEDURE actualizar_precios_marca (
	IN p_id_marca INT,
    IN p_incremento DECIMAL(10,2)
)
BEGIN
	UPDATE productos
    SET precio_unitario = precio_unitario + p_incremento
    WHERE id_marca = p_id_marca;
END //

DELIMITER ;


-- 1. IF – Verifica si un cliente es frecuente (más de 5 ventas)
DELIMITER //

CREATE PROCEDURE verificar_cliente_frecuente(
	IN p_id_cliente INT,
    OUT p_resultado VARCHAR(10)
)
BEGIN
	DECLARE v_ventas INT;
	
    SELECT COUNT(*) INTO v_ventas
    FROM ventas
    WHERE id_cliente = p_id_cliente;
    
    IF v_ventas >= 5 THEN
		SET p_resultado = 'Frecuente';
	ELSE
		SET p_resultado = 'Comun';
	END IF;
END//

DELIMITER ;

SET @tipo_cliente = '';
CALL verificar_cliente_frecuente(9,@tipo_cliente);
SELECT @tipo_cliente;


-- 2. CASE – Categorizar ventas según el total
DELIMITER //

CREATE PROCEDURE categorizar_venta (
	IN p_id_venta INT,
    OUT p_categoria VARCHAR(20)
)
BEGIN
	DECLARE v_total DECIMAL(10,2);
    
    SELECT SUM(cantidad * precio_venta_unitario) INTO v_total
    FROM detalle_venta
    WHERE id_venta = p_id_venta;
    
    CASE
		WHEN v_total >= 15000 THEN SET p_categoria = 'VENTA GRANDE';
        WHEN v_total >= 7500 THEN SET p_categoria = 'VENTA MEDIA';
        ELSE SET p_categoria = 'VENTA PEQUEÑA';
    END CASE;
END//

DELIMITER ;

SET @categoria = '';
CALL categorizar_venta(28, @categoria);
SELECT @categoria;


-- 3. WHILE – Mostrar los primeros N múltiplos de 3
DELIMITER //

CREATE PROCEDURE multiplos_de_tres (
    IN p_limite INT
)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE contador INT DEFAULT 0;

    WHILE contador < p_limite DO
        SELECT i * 3 AS multiplo;
        SET i = i + 1;
        SET contador = contador + 1;
    END WHILE;
END //

DELIMITER ;


-- 4. LOOP – Mostrar 5 productos con precios incrementados
DELIMITER //

CREATE PROCEDURE aumentar_precio (
    IN p_incremento DECIMAL(10,2)
)
BEGIN
    DECLARE v_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT id_producto FROM productos LIMIT 5;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE productos
        SET precio_unitario = precio_unitario + p_incremento
        WHERE id_producto = v_id;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL aumentar_precio(10);  -- Aumenta $10 a los primeros 5 productos