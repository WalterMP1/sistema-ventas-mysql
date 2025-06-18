-- INDICES PARA MEJORAS DE RENDIMIENTO
-- alertas_stock
CREATE INDEX idx_id_producto ON alertas_stock (id_producto);
CREATE INDEX idx_fecha ON alertas_stock (fecha);

-- carrito_venta_temp
CREATE INDEX idx_id_producto ON carrito_venta_temp (id_producto);

-- clientes_vip
CREATE INDEX idx_id_cliente ON clientes_vip (id_cliente);

-- detalle_venta
CREATE INDEX idx_venta_producto ON detalle_venta (id_venta, id_producto);

-- marcas
CREATE UNIQUE INDEX idx_nombre_marca ON marcas (nombre);

-- movimientos_inventario
CREATE INDEX idx_id_producto ON movimientos_inventario (id_producto);
CREATE INDEX idx_fecha ON movimientos_inventario (fecha);
CREATE INDEX idx_tipo_fecha ON movimientos_inventario (tipo_movimiento, fecha);

-- productos
CREATE INDEX idx_nombre ON productos (nombre);
CREATE INDEX idx_stock ON productos (stock);

-- resumen_ventas
CREATE INDEX idx_id_venta ON resumen_ventas (id_venta);

-- ventas
CREATE INDEX idx_fecha ON ventas (fecha);
CREATE INDEX idx_cliente_fecha ON ventas (id_cliente, fecha);