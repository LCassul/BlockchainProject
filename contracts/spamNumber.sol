// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SpamNumber {
    address public owner;
    
    struct Node {
        uint256 reputation;
        bool isBlocked;
    }

    mapping(string => bool) private spamList;
    mapping(address => mapping(address => uint256)) public reputation; // Rij: visão do nó i sobre o vizinho j
    mapping(address => Node) public nodes;
    mapping(address => uint256) public rewards;

    event SpamDetected(string number, address reportedBy);
    event ReputationUpdated(address indexed nodeI, address indexed nodeJ, uint256 newReputation);
    event NodeBlocked(address indexed node);

    modifier onlyOwner() {
        require(msg.sender == owner, "Apenas o proprietario pode executar isto");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // 1 - Função Verificar: Verifica se o número é spam
    function verificar(string memory _numero) public view returns (bool) {
        return spamList[_numero];
    }

    // 2 - Função Reputação: O nó i atualiza a reputação do vizinho j
    // A probabilidade de verificar uma transação deve ser tratada no front-end/lógica do nó com base neste valor
    function atualizarReputacao(address _vizinho, uint256 _valorComportamento) public {
        // Lógica simples: aumenta ou diminui com base no comportamento (0 a 100)
        reputation[msg.sender][_vizinho] = _valorComportamento;
        
        emit ReputationUpdated(msg.sender, _vizinho, _valorComportamento);
    }

    // 3 - Função Incentivo: Atribui recompensas para manter a reputação alta
    // Nós que verificam corretamente ganham "pontos" de incentivo
    function incentivo(address _verificador, string memory _numero, bool _confirmadoSpam) public onlyOwner {
        if (_confirmadoSpam) {
            spamList[_numero] = true;
            rewards[_verificador] += 10; // Recompensa por verificação correta
            nodes[_verificador].reputation += 5;
        } else {
            // Penalidade por falso positivo
            nodes[_verificador].reputation = nodes[_verificador].reputation > 10 ? nodes[_verificador].reputation - 10 : 0;
        }
    }

    // 4 - Função Bloqueio: Bloqueia transações/nós antes de chegarem aos mineradores
    function bloqueio(address _usuarioMalicioso) public {
        // Se a reputação cair abaixo de um limite, o nó é bloqueado
        require(nodes[_usuarioMalicioso].reputation < 20, "Reputacao ainda aceitavel");
        
        nodes[_usuarioMalicioso].isBlocked = true;
        emit NodeBlocked(_usuarioMalicioso);
    }

    // Função para reportar um número (alimenta o sistema)
    function reportarSpam(string memory _numero) public {
        require(!nodes[msg.sender].isBlocked, "O seu no esta bloqueado");
        emit SpamDetected(_numero, msg.sender);
    }
}
