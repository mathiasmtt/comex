// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BillOfLading.sol";

contract BoLFactory {
    address public owner;
    BillOfLading[] public bolContracts;

    event BoLCreated(address indexed bolAddress, address indexed exporter, address indexed importer);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Crea un nuevo contrato BillOfLading.
     * @param _cargoDetails Detalles de la mercancía.
     * @param _originPort Puerto de origen.
     * @param _destinationPort Puerto de destino.
     * @param _exporter Dirección del exportador.
     * @param _importer Dirección del importador.
     * @return La dirección del nuevo contrato BillOfLading.
     */
    function createBoL(
        string memory _cargoDetails,
        string memory _originPort,
        string memory _destinationPort,
        address _exporter,
        address _importer
    ) public returns (address) {
        // Validamos que las direcciones no sean la dirección cero.
        require(_exporter != address(0), "La direccion del exportador no puede ser cero");
        require(_importer != address(0), "La direccion del importador no puede ser cero");

        BillOfLading newBoL = new BillOfLading(
            _cargoDetails,
            _originPort,
            _destinationPort,
            _exporter,
            _importer
        );
        bolContracts.push(newBoL);
        emit BoLCreated(address(newBoL), _exporter, _importer);
        return address(newBoL);
    }

    /**
     * @notice Retorna el número total de BoL creados.
     */
    function getBoLCount() public view returns (uint256) {
        return bolContracts.length;
    }

    /**
     * @notice Retorna la dirección de un BoL dado su índice en el array.
     * @param index Índice del BoL en el array.
     */
    function getBoL(uint256 index) public view returns (address) {
        require(index < bolContracts.length, "Indice fuera de rango");
        return address(bolContracts[index]);
    }
}
