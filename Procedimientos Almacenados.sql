-- Sistema 16: BankSys (Sistema de gestión para servicios financieros) – 
-- Procedimientos Almacenados:

-- 1.	CrearCuentaBancaria: Crea una nueva cuenta bancaria para un cliente verificando requisitos.

DELIMITER //

CREATE PROCEDURE sp_CrearCuentaBancaria(
    IN p_numero                   VARCHAR(255),
    IN p_tipo                     VARCHAR(255),
    IN p_moneda                   VARCHAR(255),
    IN p_fecha_apertura           VARCHAR(255),
    IN p_saldo                    INT,
    IN p_saldo_promedio           INT,
    IN p_tasa_interes             INT,
    IN p_fecha_ultima_transaccion VARCHAR(255),
    IN p_estado                   VARCHAR(255),
    IN p_id_cliente               INT,
    IN p_id_sucursal              INT
)
BEGIN
    INSERT INTO cuenta (
        numero, tipo, moneda, fecha_apertura, saldo,
        saldo_promedio, tasa_interes, fecha_ultima_transaccion,
        estado, id_cliente, id_sucursal
    )
    VALUES (
        p_numero, p_tipo, p_moneda, p_fecha_apertura, p_saldo,
        p_saldo_promedio, p_tasa_interes, p_fecha_ultima_transaccion,
        p_estado, p_id_cliente, p_id_sucursal
    );
  
END //

DELIMITER ;

CALL sp_CrearCuentaBancaria(
    '001-123456-11',
    'ahorros',
    'COP',
    '2026-04-12',
    0, 0, 3,
    '2026-04-12',
    'activa',
    1, 1
);

SELECT * FROM cuenta 
WHERE numero='001-123456-11';

-- 2.	ProcesarSolicitudCredito: Procesa una solicitud de crédito analizando condiciones del cliente.

DROP PROCEDURE sp_ProcesarSolicitudCredito;
DELIMITER //
CREATE PROCEDURE sp_ProcesarSolicitudCredito
(IN p_numero              VARCHAR(255),
    IN p_fecha               VARCHAR(255),
    IN p_monto               INT,
    IN p_plazo               INT,
    IN p_destino             VARCHAR(255),
    IN p_ingresos            INT,
    IN p_respaldos           VARCHAR(255),
    IN p_capacidad_pago      INT,
    IN p_nivel_endeudamiento INT,
    IN p_puntuacion          INT,
    IN p_recomendacion       VARCHAR(255),
    IN p_motivo              VARCHAR(255),
    IN p_id_cliente          INT,
    IN p_id_producto         INT)
BEGIN

    DECLARE v_decision VARCHAR(255);

    IF p_nivel_endeudamiento < 40 then 
        SET v_decision = 'aprobado';
    ELSE
        SET v_decision = 'rechazado';
    END IF;

    INSERT INTO solicitud (
        numero, fecha, monto, plazo, destino, ingresos,
        respaldos, capacidad_pago, nivel_endeudamiento,
        puntuacion, recomendacion, decision, motivo,
        id_cliente, id_producto
    )
    VALUES (
        p_numero, p_fecha, p_monto, p_plazo, p_destino, p_ingresos,
        p_respaldos, p_capacidad_pago, p_nivel_endeudamiento,
        p_puntuacion, p_recomendacion, v_decision, p_motivo,
        p_id_cliente, p_id_producto
    );

    SELECT v_decision AS decision, 'Solicitud procesada' AS mensaje;
END //
DELIMITER ;

CALL sp_ProcesarSolicitudCredito(
    'SOL-2026-011', '2026-04-12', 10000000, 24,
    'Compra muebles', 3500000, 'Desprendibles',
    1400000, 30, 750, 'Buen historial',
    'Cumple requisitos', 1, 1
);

-- 3.	EmitirTarjetaCredito: Gestiona la emisión de una tarjeta de crédito asignando límites.
SELECT * FROM tarjeta;
DELIMITER //

CREATE PROCEDURE sp_EmitirTarjetaCredito
(IN p_numero             VARCHAR(255),
    IN p_tipo               VARCHAR(255),
    IN p_red                VARCHAR(255),
    IN p_linea_credito      INT,
    IN p_fecha_emision      VARCHAR(255),
    IN p_fecha_vencimiento  VARCHAR(255),
    IN p_limite_avances     INT,
    IN p_tasa_rotatoria     INT,
    IN p_tasa_avances       INT,
    IN p_ciclo_facturacion  INT,
    IN p_estado             VARCHAR(255),
    IN p_id_cliente         INT)

BEGIN


 DECLARE v_decision VARCHAR(255);

    IF p_limite_avances < 3000000 then 
        SET v_decision = 'aprobado';
    ELSE
        SET v_decision = 'rechazado';
    END IF;
	 
	     INSERT INTO tarjeta (
        numero,
        tipo,
        red,
        linea_credito,
        fecha_emision,
        fecha_vencimiento,
        limite_avances,
        tasa_rotatoria,
        tasa_avances,
        ciclo_facturacion,
        estado,
        id_cliente
    )
    VALUES (
        p_numero,
        p_tipo,
        p_red,
        p_linea_credito,
        p_fecha_emision,
        p_fecha_vencimiento,
        p_limite_avances,
        p_tasa_rotatoria,
        p_tasa_avances,
        p_ciclo_facturacion,
        p_estado,
        p_id_cliente
    );

   SELECT v_decision AS decision, 'Tarjeta emitida exitosamente' AS mensaje;
END //

DELIMITER ;

CALL sp_EmitirTarjetaCredito(
    '4321-****-****-0011',  
    'gold',                
    'visa',              
    8000000,                
    '2026-04-12',           
    '2029-04-12',            
    2400000,               
    22,                    
    29,                      
    15,                     
    'activa',               
    1              
);

-- 4.	RegistrarTransaccion: Registra una transacción verificando fondos y permisos.
SELECT * FROM transaccion;
DELIMITER //
CREATE PROCEDURE sp_RegistrarTransaccion(
    IN p_codigo             VARCHAR(255),
    IN p_fecha_hora         VARCHAR(255),
    IN p_tipo               VARCHAR(255),
    IN p_monto              DECIMAL(14,2),
    IN p_concepto           VARCHAR(255),
    IN p_canal              VARCHAR(255),
    IN p_comprobante        VARCHAR(255),
    IN p_estado             VARCHAR(255),
    IN p_id_cuenta_origen   INT,
    IN p_id_cuenta_destino  INT,
    IN p_id_empleado        INT
)
BEGIN
    DECLARE v_saldo_origen INT;
    DECLARE v_permiso      VARCHAR(255);
    
    SELECT saldo INTO v_saldo_origen 
	 FROM cuenta 
	 WHERE id_cuenta = p_id_cuenta_origen;
	 
    SELECT permisos INTO v_permiso 
	 FROM empleado 
	 WHERE id_empleado = p_id_empleado;
	 
    IF v_saldo_origen >= p_monto AND v_permiso = 'caja' THEN 
	 
	 INSERT INTO transaccion (codigo, fecha_hora, tipo, monto, concepto, canal, comprobante, estado, id_cuenta_origen, id_cuenta_destino, id_empleado) 
	 VALUES (p_codigo, p_fecha_hora, p_tipo, p_monto, p_concepto, p_canal, p_comprobante, p_estado, p_id_cuenta_origen, p_id_cuenta_destino, p_id_empleado); 
	 
	 SELECT 'Transaccion registrada exitosamente' AS mensaje; 
	 ELSE 
	 SELECT 'Transaccion rechazada: fondos insuficientes o sin permisos' AS mensaje; 
	 END IF; 
	 END //
DELIMITER ;

CALL sp_RegistrarTransaccion(
    'TRX-2026-011',        
    '2026-04-12 10:00:00',  
    'deposito',              
    500000,                  
    'Deposito en ventanilla',
    'ventanilla',            
    'COMP-011',              
    'completada',           
    1,                       
    2,                      
    8                        
);
SELECT * FROM transaccion;

-- 5.	ActualizarClasificacionCliente: Actualiza la clasificación de riesgo de un cliente.
SELECT * FROM cliente 
DELIMITER //
CREATE PROCEDURE sp_ActualizarClasificacionCliente(
    IN p_id_cliente    INT,
    IN p_nivel_riesgo  VARCHAR(255),
    IN p_clasificacion VARCHAR(255)
)
BEGIN

UPDATE cliente 
SET nivel_riesgo = p_nivel_riesgo
WHERE id_cliente=p_id_cliente;

UPDATE cliente 
SET clasificacion = p_clasificacion
WHERE id_cliente=p_id_cliente;

END // 
DELIMITER ;

CALL sp_ActualizarClasificacionCliente( 1,'alto','C ');