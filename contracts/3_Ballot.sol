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
        require(_opcoes.length >= 2 && _opcoes.length <= 10, unicode"Deve-se definir, no minimo 2 e maximo 10pelo menos 2 opções");
        contadorEnquete++;
        EnqueteInfo storage novaEnquete = enquetes[contadorEnquete];
        novaEnquete.titulo = _titulo;
        novaEnquete.criador = msg.sender;
        novaEnquete.activa = true;  

        for(uint256 i = 0; i < _opcoes.length; i++){
            novaEnquete.opcoes.push(opcaoVoto({descricao: _opcoes[i], quantidade:0}));
        }

        emit EnqueteCriada(contadorEnquete, _titulo, msg.sender);
        
    }

    function votar(uint256 _idEnquete, uint256 _indiceOpcao) external {
        EnqueteInfo storage enquete = enquetes[_idEnquete];
        require(enquete.activa, unicode"Enquete não está activa");
        require(enquete.criador != msg.sender, unicode"Não pode votar na sua propria enquete");
        require(_indiceOpcao < enquete.opcoes.length, unicode"Opção invalida");
        require(!enquete.jaVotou[msg.sender], unicode"Já votaste nesta enquete");

            enquete.opcoes[_indiceOpcao].quantidade++;
            enquete.jaVotou[msg.sender] = true;
            emit VotoRegistado(_idEnquete, _indiceOpcao, msg.sender);

  }

    function fecharEnquete(uint256 _idEnquete) external {
        EnqueteInfo storage enquete = enquetes[_idEnquete];
        require(enquete.activa, unicode"Enquete já está fechada");
        require(enquete.criador == msg.sender, unicode"Não és o criador");
        

        enquete.activa = false;
        
        emit Enquetefechada(_idEnquete, msg.sender);

    }  
    
    function getEnquete(uint256 _idEnquete) external view returns (EnqueteInfo memory) {
        string memory titulo,
        bool activa,
        string[] memory nomesOpcoes,
        uint256[] memory votosOpcoes,
        address criador,
    ) {
        EnqueteInfo storage enquete = enquetes[_idEnquete];
        uint256 totalOpcoes = enquete.opcoes.length;

        nomesOpcoes = new string[](totalOpcoes);
        qvotosOpcoes = new uint256[](totalOpcoes);

        for(uint256 i = 0; i < totalOpcoes; i++){
            nomesOpcoes[i] = enquete.opcoes[i].descricao;
            votosOpcoes[i] = enquete.opcoes[i].votos;
        }
        
    }
        return (enquete.titulo, enquete.ativa, nomesOpcoes, votosOpcoes, enquete.criador);
    }      
}   