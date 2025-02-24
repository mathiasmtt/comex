// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Incoterms
 * @dev Contrato para manejar los términos de comercio internacional (Incoterms)
 */
contract Incoterms {
    enum IncotermType {
        EXW,    // Ex Works
        FCA,    // Free Carrier
        CPT,    // Carriage Paid To
        CIP,    // Carriage and Insurance Paid To
        DAP,    // Delivered At Place
        DDP,    // Delivered Duty Paid
        CIF     // Cost, Insurance and Freight
    }

    struct IncotermDetails {
        IncotermType incotermType;
        address seller;
        address buyer;
        bool sellerResponsibleForMainCarriage;
        bool sellerResponsibleForImportClearance;
        bool sellerResponsibleForInsurance;
        bool isActive;
        uint256 createdAt;
    }

    mapping(bytes32 => IncotermDetails) public incoterms;
    
    event IncotermCreated(
        bytes32 indexed incotermId,
        IncotermType incotermType,
        address indexed seller,
        address indexed buyer
    );

    /**
     * @dev Crea un nuevo acuerdo Incoterm
     * @param _incotermType Tipo de Incoterm a utilizar
     * @param _seller Dirección del vendedor
     * @param _buyer Dirección del comprador
     * @return incotermId ID único del acuerdo Incoterm creado
     */
    function createIncoterm(
        IncotermType _incotermType,
        address _seller,
        address _buyer
    ) external returns (bytes32) {
        require(_seller != address(0), "Direccion del vendedor invalida");
        require(_buyer != address(0), "Direccion del comprador invalida");

        bytes32 incotermId = keccak256(
            abi.encodePacked(
                _incotermType,
                _seller,
                _buyer,
                block.timestamp
            )
        );

        bool sellerResponsibleForMainCarriage;
        bool sellerResponsibleForImportClearance;
        bool sellerResponsibleForInsurance;

        // Configurar responsabilidades según el tipo de Incoterm
        if (_incotermType == IncotermType.EXW) {
            // En EXW, el vendedor tiene responsabilidad mínima
            sellerResponsibleForMainCarriage = false;
            sellerResponsibleForImportClearance = false;
            sellerResponsibleForInsurance = false;
        } else if (_incotermType == IncotermType.CIP) {
            // En CIP, el vendedor es responsable del transporte principal y seguro
            sellerResponsibleForMainCarriage = true;
            sellerResponsibleForImportClearance = false;
            sellerResponsibleForInsurance = true;
        } else if (_incotermType == IncotermType.DDP) {
            // En DDP, el vendedor tiene la máxima responsabilidad
            sellerResponsibleForMainCarriage = true;
            sellerResponsibleForImportClearance = true;
            sellerResponsibleForInsurance = true;
        } else if (_incotermType == IncotermType.DAP) {
            // En DAP, el vendedor es responsable del transporte pero no del despacho
            sellerResponsibleForMainCarriage = true;
            sellerResponsibleForImportClearance = false;
            sellerResponsibleForInsurance = false;
        } else if (_incotermType == IncotermType.CPT) {
            // En CPT, el vendedor paga el transporte pero no es responsable del seguro
            sellerResponsibleForMainCarriage = true;
            sellerResponsibleForImportClearance = false;
            sellerResponsibleForInsurance = false;
        } else if (_incotermType == IncotermType.FCA) {
            // En FCA, el vendedor entrega en un punto acordado
            sellerResponsibleForMainCarriage = false;
            sellerResponsibleForImportClearance = false;
            sellerResponsibleForInsurance = false;
        } else if (_incotermType == IncotermType.CIF) {
            // En CIF, el vendedor paga el transporte principal y seguro hasta puerto de destino
            sellerResponsibleForMainCarriage = true;
            sellerResponsibleForImportClearance = false;
            sellerResponsibleForInsurance = true;
        }

        incoterms[incotermId] = IncotermDetails({
            incotermType: _incotermType,
            seller: _seller,
            buyer: _buyer,
            sellerResponsibleForMainCarriage: sellerResponsibleForMainCarriage,
            sellerResponsibleForImportClearance: sellerResponsibleForImportClearance,
            sellerResponsibleForInsurance: sellerResponsibleForInsurance,
            isActive: true,
            createdAt: block.timestamp
        });

        emit IncotermCreated(incotermId, _incotermType, _seller, _buyer);
        return incotermId;
    }

    /**
     * @dev Obtiene los detalles de un acuerdo Incoterm
     * @param _incotermId ID del acuerdo Incoterm
     * @return Detalles completos del Incoterm
     */
    function getIncotermDetails(bytes32 _incotermId) 
        external 
        view 
        returns (IncotermDetails memory) 
    {
        require(incoterms[_incotermId].isActive, "Incoterm no existe o no esta activo");
        return incoterms[_incotermId];
    }

    /**
     * @dev Verifica si el vendedor es responsable del transporte principal
     * @param _incotermId ID del acuerdo Incoterm
     * @return bool indicando si el vendedor es responsable
     */
    function isSellerResponsibleForMainCarriage(bytes32 _incotermId) 
        external 
        view 
        returns (bool) 
    {
        require(incoterms[_incotermId].isActive, "Incoterm no existe o no esta activo");
        return incoterms[_incotermId].sellerResponsibleForMainCarriage;
    }

    /**
     * @dev Verifica si el vendedor es responsable del despacho de importación
     * @param _incotermId ID del acuerdo Incoterm
     * @return bool indicando si el vendedor es responsable
     */
    function isSellerResponsibleForImportClearance(bytes32 _incotermId) 
        external 
        view 
        returns (bool) 
    {
        require(incoterms[_incotermId].isActive, "Incoterm no existe o no esta activo");
        return incoterms[_incotermId].sellerResponsibleForImportClearance;
    }

    /**
     * @dev Verifica si el vendedor es responsable del seguro
     * @param _incotermId ID del acuerdo Incoterm
     * @return bool indicando si el vendedor es responsable
     */
    function isSellerResponsibleForInsurance(bytes32 _incotermId) 
        external 
        view 
        returns (bool) 
    {
        require(incoterms[_incotermId].isActive, "Incoterm no existe o no esta activo");
        return incoterms[_incotermId].sellerResponsibleForInsurance;
    }
}
