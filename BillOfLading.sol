// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BillOfLading {
    // Estados posibles del envío
    enum ShipmentStatus { Pending, InTransit, Delivered }

    address public exporter;
    address public importer;
    string public cargoDetails;
    string public originPort;
    string public destinationPort;
    ShipmentStatus public status;
    uint256 public createdAt;
    uint256 public lastUpdatedAt;

    event StatusUpdated(ShipmentStatus newStatus, uint256 updatedAt);
    event OwnershipTransferred(address indexed previousImporter, address indexed newImporter, uint256 updatedAt);

    /**
     * @notice Constructor que inicializa un nuevo Bill of Lading.
     * @param _cargoDetails Detalles de la mercancía.
     * @param _originPort Puerto de origen.
     * @param _destinationPort Puerto de destino.
     * @param _exporter Dirección del exportador.
     * @param _importer Dirección del importador.
     */
    constructor(
        string memory _cargoDetails,
        string memory _originPort,
        string memory _destinationPort,
        address _exporter,
        address _importer
    ) {
        require(_exporter != address(0), "La direccion del exportador no puede ser cero");
        require(_importer != address(0), "La direccion del importador no puede ser cero");

        exporter = _exporter;
        importer = _importer;
        cargoDetails = _cargoDetails;
        originPort = _originPort;
        destinationPort = _destinationPort;
        status = ShipmentStatus.Pending;
        createdAt = block.timestamp;
        lastUpdatedAt = block.timestamp;
    }

    modifier onlyExporter() {
        require(msg.sender == exporter, "Solo el exportador puede ejecutar esta accion");
        _;
    }

    modifier onlyImporter() {
        require(msg.sender == importer, "Solo el importador puede ejecutar esta accion");
        _;
    }

    /**
     * @notice Actualiza el estado del envío, forzando una progresión lineal.
     * Solo el exportador puede actualizar el estado.
     * @param _newStatus Nuevo estado del envío.
     */
    function updateStatus(ShipmentStatus _newStatus) public onlyExporter {
        // Se permite avanzar únicamente al siguiente estado
        require(uint(_newStatus) == uint(status) + 1, "La actualizacion de estado debe ser progresiva");
        status = _newStatus;
        lastUpdatedAt = block.timestamp;
        emit StatusUpdated(_newStatus, lastUpdatedAt);
    }

    /**
     * @notice Permite al importador transferir la propiedad del BoL a una nueva dirección.
     * @param _newImporter Dirección del nuevo importador.
     */
    function transferOwnership(address _newImporter) public onlyImporter {
        require(_newImporter != address(0), "El nuevo importador no puede ser cero");
        address previousImporter = importer;
        importer = _newImporter;
        lastUpdatedAt = block.timestamp;
        emit OwnershipTransferred(previousImporter, _newImporter, lastUpdatedAt);
    }

    /**
     * @notice Retorna todos los detalles del Bill of Lading.
     * @return cargoDetails, originPort, destinationPort, exporter, importer, status, createdAt y lastUpdatedAt.
     */
    function getDetails() public view returns (
        string memory,
        string memory,
        string memory,
        address,
        address,
        ShipmentStatus,
        uint256,
        uint256
    ) {
        return (
            cargoDetails,
            originPort,
            destinationPort,
            exporter,
            importer,
            status,
            createdAt,
            lastUpdatedAt
        );
    }
}
