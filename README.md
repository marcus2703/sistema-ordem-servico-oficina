# Sistema de Controle e Gerenciamento de Execução de Ordens de Serviço em uma Oficina Mecânica

## Narrativa

- Clientes levam veículos à oficina mecânica para serem consertados ou para passarem por revisões periódicas.
- Cada veículo é designado a uma equipe de mecânicos que identifica os serviços a serem executados e preenche uma Ordem de Serviço (OS) com data de entrega.
- A partir da OS, calcula-se o valor de cada serviço, consultando-se uma tabela de referência de mão-de-obra. O valor de cada peça também irá compor a OS.
- O cliente autoriza a execução dos serviços.
- A mesma equipe avalia e executa os serviços.
- Os mecânicos possuem código, nome, endereço e especialidade.
- Cada OS possui: número, data de emissão, um valor, status e uma data para conclusão dos trabalhos.

## Identificação dos Requisitos

### Requisitos Funcionais

1. O sistema deve permitir o cadastro de clientes.
2. O sistema deve permitir o cadastro de veículos.
3. O sistema deve permitir o cadastro de mecânicos com uma especialidade.
4. O sistema deve permitir a criação de Ordens de Serviço (OS) com data de emissão, valor, status e data de conclusão.
5. O sistema deve permitir a designação de veículos a equipes de mecânicos.
6. O sistema deve permitir a consulta de tabela de referência de mão-de-obra para cálculo do valor dos serviços.
7. O sistema deve permitir o cálculo do valor total da OS, incluindo serviços e peças.
8. O sistema deve permitir a autorização de execução dos serviços pelo cliente.
9. O sistema deve permitir a atualização do status da OS conforme o progresso dos serviços.
10. O sistema deve permitir que o veículo dê entrada para conserto ou revisão.
11. O sistema deve permitir que uma OS contenha vários serviços e que um serviço esteja em várias OS.
12. O sistema deve permitir que uma OS contenha vários tipos de peças e que uma peça esteja em várias OS.
13. O sistema deve permitir que um cliente tenha mais de um veículo cadastrado.

### Requisitos Não Funcionais

1. O sistema deve ser acessível via web e dispositivos móveis.
2. O sistema deve garantir a segurança e privacidade dos dados dos clientes, veículos e mecânicos.
3. O sistema deve ser fácil de usar e intuitivo.
4. O sistema deve ter alta disponibilidade e desempenho.

## Navegação

- [Histórias de Usuário (User Stories)](historias_usuario.md)
- [Casos de Uso](casos_uso.md)
- [Diagrama de Classes](diagrama_classe.md)
- [Diagrama de Sequência](diagrama_sequencia.md)
