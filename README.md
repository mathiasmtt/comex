# Sistema de Gestión de Documentos de Comercio Internacional

Este proyecto implementa un sistema de contratos inteligentes en Solidity para la gestión de documentos de comercio internacional, incluyendo Bill of Lading (B/L) e Incoterms.

## Contratos Implementados

### 1. BillOfLading.sol
Contrato que gestiona los documentos de embarque (Bill of Lading) en la blockchain.

#### Características principales:
- Registro de exportador e importador
- Gestión de detalles de la carga
- Control de puertos de origen y destino
- Seguimiento del estado del envío (Pending, InTransit, Delivered)
- Sistema de transferencia de propiedad

#### Ejemplo de uso:
```solidity
// Crear un nuevo Bill of Lading
BillOfLading bl = new BillOfLading(
    "10 contenedores de café",
    "Puerto de Santos",
    "Puerto de Barcelona",
    0x123...789, // dirección del exportador
    0x456...012  // dirección del importador
);
```

### 2. Incoterms.sol
Contrato que gestiona los términos de comercio internacional (Incoterms) estableciendo las responsabilidades entre compradores y vendedores.

#### Tipos de Incoterms soportados:
- **EXW** (Ex Works): Responsabilidad mínima del vendedor
- **FCA** (Free Carrier): Entrega en punto acordado
- **CPT** (Carriage Paid To): Vendedor paga transporte principal
- **CIP** (Carriage and Insurance Paid): Vendedor paga transporte y seguro
- **DAP** (Delivered At Place): Vendedor responsable hasta punto de entrega
- **DDP** (Delivered Duty Paid): Máxima responsabilidad del vendedor
- **CIF** (Cost, Insurance and Freight): Vendedor cubre costos, seguro y flete hasta puerto de destino

#### Ejemplo de uso:
```solidity
// Crear un nuevo acuerdo Incoterm
Incoterms incoterms = new Incoterms();
bytes32 incotermId = incoterms.createIncoterm(
    Incoterms.IncotermType.CIP,
    0x123...789, // dirección del vendedor
    0x456...012  // dirección del comprador
);

// Consultar responsabilidades
bool isSellerResponsibleForInsurance = incoterms.isSellerResponsibleForInsurance(incotermId);
```

## Funcionalidades Principales

### En BillOfLading:
1. Creación de nuevos B/L
2. Actualización del estado del envío
3. Transferencia de propiedad
4. Registro de eventos en la blockchain

### En Incoterms:
1. Creación de acuerdos Incoterm
2. Consulta de responsabilidades del vendedor/comprador
3. Verificación de obligaciones de transporte
4. Verificación de obligaciones de seguro
5. Verificación de responsabilidades de despacho

## Requisitos Técnicos

- Solidity ^0.8.19
- Compatible con EVM (Ethereum Virtual Machine)
- Herramientas recomendadas:
  - Hardhat o Truffle para desarrollo y pruebas
  - MetaMask para interacción con los contratos

## Seguridad

Los contratos implementan:
- Verificaciones de direcciones nulas
- Control de acceso mediante modificadores
- Validaciones de estado
- Eventos para seguimiento de cambios importantes

## Uso en Producción

Para implementar estos contratos en producción:

1. Desplegar primero el contrato `Incoterms.sol`
2. Desplegar el contrato `BillOfLading.sol`
3. Para cada nueva transacción comercial:
   - Crear un nuevo acuerdo Incoterm
   - Crear el correspondiente Bill of Lading
   - Gestionar el ciclo de vida del envío actualizando los estados

## Contribución

Las contribuciones son bienvenidas. Por favor, asegúrese de:
1. Seguir el estilo de código existente
2. Agregar pruebas para nuevas funcionalidades
3. Actualizar la documentación según sea necesario
