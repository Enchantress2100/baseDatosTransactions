--resetear
DROP DATABASE unidad2 IF EXISTS;

--crear base de datos
CREATE DATABASE unidad2;

--acceder
\c unidad2

--cargar el respaldo de la base de datos unidad2.sql
--psql -U postgres -d unidad2 < unidad2.sql

--visualizar tablas
--SELECT * FROM cliente;
--SELECT * FROM compra;
--SELECT * FROM detalle_compra;
--SELECT * FROM producto;


--realizar las conductas correspondientes para el requerimiento del usuario 01
BEGIN TRANSACTION;
INSERT INTO compra(cliente_id,fecha)
VALUES(1, '2021-12-11');
INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
VALUES(9,39, 5);
UPDATE producto SET stock = stock -5 WHERE id=9;
COMMIT;

--comprobar si se descontó del stock
SELECT * FROM producto
WHERE id=9;

--realizar las consultas correspondientes para los requerimientos del usuario 02 y consultar la tabla producto para que si alguno se quedo sin stock, no se haga la compra.

--primera transaccion
BEGIN TRANSACTION;
INSERT INTO compra(cliente_id,fecha)
VALUES(2, '2021-12-11');

--validar stock producto 1
SELECT * FROM producto
WHERE id=1;

--compra de tres productos id 1
INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
VALUES(1,40,3);
UPDATE producto SET stock = stock -3 WHERE id=2;
SAVEPOINT punto;

--validar stock producto 2
SELECT * FROM producto
WHERE id=2;

--compra de tres productos id 2
INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
VALUES(2,40,3);
UPDATE producto SET stock = stock -3 WHERE id=2;
--no hay stock, haremos rollback
ROLLBACK TO punto;


--validar stock producto 8
SELECT * FROM producto
WHERE id=8;

--compra de tres productos id 8
INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
VALUES(8,40,3);
UPDATE producto SET stock = stock -3 WHERE id=2;
--no hay stock, haremos rollback
ROLLBACK TO punto;
--validar stock de los productos
SELECT descripcion ,stock FROM producto
WHERE id in (1, 2, 8);
END TRANSACTION;

--consultas: deshabilitar autocommit
\set AUTOCOMMIT OFF

--insertar nuevo cliente
BEGIN TRANSACTION;
SAVEPOINT client;
INSERT INTO cliente(id, nombre, email)
VALUES(11, 'usuario011', 'usuario011@gmail.com');
--hacer rollback
ROLLBACK to client;
COMMIT;

--comprobar que el cliente nuevo fue borrado.
SELECT * FROM cliente
WHERE id=11;

--activar autocommit
\set AUTOCOMMIT

