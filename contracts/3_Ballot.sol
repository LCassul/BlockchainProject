// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.34;

contract Enquete{
    // Atributos composto
    struct opcaoVoto{
        string descricao;
        uint256 quantidade;
    }

    // Atributos simples
    struct EnqueteInfo{
        string titulo;
        address criador;
        bool activa;
        opcaoVoto[] opcoes;
        mapping(address => bool) jaVotou;
    }  
    
    mapping(uint256 => EnqueteInfo) private enquetes;
    uint256 private  contadorEnquete;



    // Enquete é criada
    event EnqueteCriada(uint256 idEnquete, string titulo, address criador);
    // Um voto é regitado
    event VotoRegistado(uint256 idEnquete, uint256 indiceOpcao, address votante);
    // Enquete é finalizada
    event EnqueteEncerrada(uint256 idEnquete, address criador);

    function criarEnquete(string memory _titulo, string[] memory _opcoes) external {
        
    }


  }
