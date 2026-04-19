-- 
1.	V_CuentasActivasCliente: Muestra todas las cuentas activas por cliente.
DROP VIEW cuenta_cliente
CREATE VIEW cuenta_cliente AS 
SELECT c.nombre ,cu.estado,cu.numero 
FROM cuenta cu 
INNER JOIN cliente c ON  c.id_cliente=cu.id_cliente
WHERE cu.estado= 'activa';

SELECT  * FROM cuenta_cliente;

-- 2.	V_CreditosVigentes: Detalla los créditos vigentes con su estado de pago.

SELECT * FROM credito 

SELECT * FROM solicitud

SELECT * FROM cliente

DROP VIEW credito_vigente;

CREATE VIEW credito_vigente AS 
SELECT cl.nombre,cr.numero,cr.monto,cr.saldo_actual,cr.proximo_vencimiento,cr.estado
FROM solicitud s
INNER JOIN cliente cl ON cl.id_cliente= s.id_cliente
INNER JOIN credito cr ON cr.id_solicitud = s.id_solicitud
WHERE cr.estado = 'vigente';

SELECT * FROM credito_vigente;

-- 3.	V_MovimientosPorCuenta: Historial de movimientos por cuenta y periodo.

CREATE VIEW movimientos AS 
SELECT c.numero, t.codigo, t.fecha_hora,t.tipo,t.monto, t.estado
FROM transaccion t
INNER JOIN cuenta c ON t.id_cuenta_origen = c.id_cuenta;

SELECT * FROM movimientos;

-- 4.	V_TarjetasCreditoEstado: Estado actual de tarjetas de crédito con límites y consumos.

CREATE VIEW tarjeta_consumo AS 
SELECT c.nombre,t.numero,t.tipo,t.estado,t.tasa_rotatoria,t.linea_credito,t.limite_avances, t.red
FROM tarjeta t 
INNER JOIN cliente c ON c.id_cliente = t.id_cliente;

SELECT * FROM tarjeta_consumo;


-- 5.	V_GarantiasConstituidas: Listado de garantías constituidas por tipo y valor.

SELECT * FROM garantia;
SELECT * FROM credito;

DROP VIEW garantías_constituidas;

CREATE VIEW garantías_constituidas AS 
SELECT g.codigo , g.tipo , g.descripcion , g.valor_comercial , g.valor_respaldo , g.estado , c.numero
FROM garantia g
INNER JOIN credito_garantia cre ON cre.id_garantia=g.id_garantia
INNER JOIN credito c ON c.id_credito=cre.id_credito
WHERE g.estado= 'vigente';

SELECT * FROM garantías_constituidas;









