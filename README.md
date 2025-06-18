# Sistema de Ventas de Celulares en MySQL

Este proyecto implementa un sistema de ventas para una tienda de celulares. Todo está desarrollado usando SQL puro sobre MySQL.

## Funcionalidades Principales

- Registro de ventas y productos con control de stock
- Reportes detallados por cliente, producto y fecha
- Vistas optimizadas para análisis de datos
- Cursores y manejo de errores
- Triggers para control de inventario y alertas
- Funciones SQL y procedimientos almacenados reutilizables

## Estructura de Archivos

| Archivo                     | Descripción |
|-----------------------------|-------------|
| `01_esquema_base.sql`       | Creación de base de datos, tablas, relaciones e índices principales |
| `02_datos_iniciales.sql`    | Población inicial de marcas, proveedores, clientes, productos y ventas |
| `03_consultas_reportes.sql` | Consultas complejas: ventas, totales, combinaciones, subconsultas |
| `04_vistas_funciones.sql`   | Vistas, funciones personalizadas y CTEs |
| `05_procedimientos.sql`     | Procedimientos almacenados: registrar venta, calcular totales, actualizar precios, etc... |
| `06_cursores_errores_loops.sql` | Cursores con lógica condicional y manejo de errores |
| `07_crud_con_stock.sql`     | CRUD completo con carrito temporal y validación de stock |
| `08_triggers_manejo_inventario.sql`| Triggers para control de inventario y movimientos de stock |
| `09_indices.sql`            | Índices para optimización del rendimiento de consultas |

## Requisitos

- MySQL Server (v8 recomendado)
- MySQL Workbench o DBeaver para ejecutar los scripts

## Cómo usar este sistema

1. Abre tu cliente de MySQL (Workbench, DBeaver, etc).
2. Ejecuta los archivos en orden:
   ```
   01_esquema_base.sql
   02_datos_iniciales.sql
   03_consultas_reportes.sql
   04_vistas_funciones.sql
   05_procedimientos.sql
   06_cursores_y_errores.sql
   07_crud_con_stock.sql
   08_triggers_inventario.sql
   09_indices.sql
   ```

3. Explora las funcionalidades:
   - Ejecuta los procedimientos
   - Consulta las vistas y funciones
   - Revisa las alertas y movimientos automáticos de stock

## Créditos

Autor: Walter Martinez Perales
Fecha de creación: 17/06/2025  
Portafolio Profesional
