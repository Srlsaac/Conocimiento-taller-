#  BankSys - Sistema de Gestión para Servicios Financieros

##  Descripción General

BankSys es un sistema de base de datos diseñado para gestionar los servicios financieros de una entidad bancaria. Permite administrar sucursales, empleados, clientes, cuentas bancarias, tarjetas de crédito, créditos, garantías y transacciones.

---

##  Estructura del Repositorio

```
 repositorio
    sucursal.sql          -- Base de datos principal con tablas y datos
    procedimientos.sql    -- Procedimientos almacenados y vistas
    README.md             -- Documentación del proyecto
```

---

##  Base de Datos

El archivo `sucursal.sql` contiene la estructura completa de la base de datos con las siguientes tablas:

| Tabla | Descripción |
|-------|-------------|
| `empleado` | Información del personal del banco |
| `sucursal` | Datos de las sucursales bancarias |
| `cliente` | Información de clientes naturales y jurídicos |
| `producto` | Productos financieros disponibles |
| `garantia` | Garantías asociadas a créditos |
| `cuenta` | Cuentas bancarias de los clientes |
| `titular_adicional` | Titulares adicionales de cuentas |
| `tarjeta` | Tarjetas de crédito emitidas |
| `solicitud` | Solicitudes de crédito |
| `credito` | Créditos desembolsados |
| `credito_garantia` | Relación entre créditos y garantías |
| `transaccion` | Movimientos y transacciones bancarias |

---

##  Instrucciones de Uso

### Requisitos
- MySQL o MariaDB
- HeidiSQL u otro cliente SQL

### Pasos para ejecutar

1. Abrir HeidiSQL y conectarse al servidor
2. Abrir una pestaña de consulta con `Ctrl + T`
3. Cargar y ejecutar el archivo `sucursal.sql` para crear la base de datos
4. Ejecutar el archivo `procedimientos.sql` para crear los procedimientos y vistas
5. Verificar con `SHOW TABLES;` que todas las tablas fueron creadas

---

##  Módulos Implementados

### 1. Procedimientos Almacenados

| Procedimiento | Descripción |
|---------------|-------------|
| `sp_CrearCuentaBancaria` | Crea una nueva cuenta bancaria para un cliente |
| `sp_ProcesarSolicitudCredito` | Procesa una solicitud de crédito analizando el nivel de endeudamiento |
| `sp_EmitirTarjetaCredito` | Gestiona la emisión de una tarjeta de crédito asignando límites |
| `sp_RegistrarTransaccion` | Registra una transacción verificando fondos y permisos del empleado |
| `sp_ActualizarClasificacionCliente` | Actualiza la clasificación de riesgo de un cliente |

#### Ejemplo de uso
```sql
-- Crear una cuenta bancaria
CALL sp_CrearCuentaBancaria('001-123456-11', 'ahorros', 'COP', '2026-04-12', 0, 0, 3, '2026-04-12', 'activa', 1, 1);

-- Procesar una solicitud de crédito
CALL sp_ProcesarSolicitudCredito('SOL-2026-011', '2026-04-12', 10000000, 24, 'Compra muebles', 3500000, 'Desprendibles', 1400000, 30, 750, 'Buen historial', 'Cumple requisitos', 1, 1);
```

---

### 2. Vistas

| Vista | Descripción |
|-------|-------------|
| `cuenta_cliente` | Muestra todas las cuentas activas por cliente |
| `credito_vigente` | Detalla los créditos vigentes con su estado de pago |
| `movimientos` | Historial de movimientos por cuenta y periodo |
| `tarjeta_consumo` | Estado actual de tarjetas de crédito con límites y consumos |
| `garantias_constituidas` | Listado de garantías constituidas por tipo y valor |

#### Ejemplo de uso
```sql
-- Ver cuentas activas por cliente
SELECT * FROM cuenta_cliente;

-- Ver créditos vigentes
SELECT * FROM credito_vigente;
```

---

##  Autor

Estudiante: Isaac  
Curso: Base de Datos Avanzado  
Fecha: 2026
