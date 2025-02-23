# Modelagem Conceitual do Banco de Dados

## Introdução
A modelagem conceitual é a primeira etapa no processo de design de um banco de dados, onde representamos as entidades do mundo real e seus relacionamentos de forma abstrata e independente de implementação. Este modelo serve como base para entender a estrutura dos dados e suas interações, sem se preocupar com detalhes técnicos específicos de um Sistema Gerenciador de Banco de Dados (SGBD).

## Utilização
A modelagem conceitual deve ser utilizada como:
- Ferramenta de comunicação entre stakeholders e desenvolvedores
- Base para validação dos requisitos do sistema
- Guia para desenvolvimento do modelo lógico
- Documentação de alto nível da estrutura de dados
- Referência para futuras manutenções e evolução do sistema

O diagrama apresentado utiliza a notação de Entidade-Relacionamento (ER), onde as entidades são representadas por retângulos, seus atributos são listados internamente, e os relacionamentos são indicados por linhas conectoras com suas respectivas cardinalidades.

Este documento apresenta duas versões para a modelagem conceitual do banco de dados para o Sistema de Controle e Gerenciamento de Execução de Ordens de Serviço em uma Oficina Mecânica.

- [Diagrama Entidade-Relacionamento sem especializações](#diagrama-entidade-relacionamento-sem-especializa%C3%A7%C3%B5es)
- [Modelagem Conceitual do Banco de Dados - Com Especializações](#diagrama-entidade-relacionamento---com-especializa%C3%A7%C3%B5es)


O modelo foi desenvolvido com base nos requisitos, casos de uso e histórias de usuário previamente documentados.

## Diagrama Entidade-Relacionamento sem especializações

```mermaid
erDiagram
    CLIENTE ||--o{ VEICULO : possui
    CLIENTE {
        int id_cliente PK
        string nome
        string endereco
        string telefone
        string email
    }
    
    VEICULO ||--o{ ORDEM_SERVICO : gera
    VEICULO {
        int id_veiculo PK
        string placa
        string marca
        string modelo
        int ano
        int id_cliente FK
    }
    
    MECANICO }|--o{ EQUIPE : compoe
    MECANICO {
        int id_mecanico PK
        string nome
        string especialidade
        string telefone
    }
    
    EQUIPE ||--o{ ORDEM_SERVICO : atende
    EQUIPE {
        int id_equipe PK
        string nome
        string especialidade
    }
    
    ORDEM_SERVICO ||--|{ ITEM_SERVICO : possui
    ORDEM_SERVICO ||--|{ ITEM_PECA : possui
    ORDEM_SERVICO {
        int id_os PK
        date data_emissao
        string tipo_servico
        string status
        decimal valor_total
        boolean autorizado
        int id_veiculo FK
        int id_equipe FK
    }
    
    SERVICO ||--o{ ITEM_SERVICO : contem
    SERVICO {
        int id_servico PK
        string descricao
        decimal valor_padrao
        string tipo
    }
    
    ITEM_SERVICO {
        int id_item_servico PK
        int id_os FK
        int id_servico FK
        decimal valor_cobrado
    }
    
    PECA ||--o{ ITEM_PECA : utiliza
    PECA {
        int id_peca PK
        string nome
        string codigo
        decimal valor_unitario
        int quantidade_estoque
    }
    
    ITEM_PECA {
        int id_item_peca PK
        int id_os FK
        int id_peca FK
        int quantidade
        decimal valor_unitario
    }
    
    ORCAMENTO ||--|| ORDEM_SERVICO : possui
    ORCAMENTO {
        int id_orcamento PK
        int id_os FK
        date data_orcamento
        decimal valor_total
        string status
    }
```

## Descrição das Entidades

### CLIENTE
- Armazena informações dos clientes da oficina
- Relaciona-se com os veículos que possui

### VEICULO
- Registra dados dos veículos dos clientes
- Vinculado a um cliente e pode ter várias ordens de serviço

### MECANICO
- Contém dados dos mecânicos
- Pode fazer parte de uma ou mais equipes

### EQUIPE
- Representa grupos de trabalho de mecânicos
- Atende as ordens de serviço

### ORDEM_SERVICO
- Documento principal que registra os serviços
- Vinculada a um veículo e uma equipe
- Contém itens de serviço e peças

### SERVICO
- Catálogo de serviços oferecidos
- Possui valor padrão de referência

### ITEM_SERVICO
- Registra serviços específicos de uma OS
- Permite valor diferente do padrão

### PECA
- Cadastro de peças em estoque
- Controle de quantidade e valores

### ITEM_PECA
- Registra peças utilizadas em uma OS
- Mantém o valor praticado na época

### ORCAMENTO
- Vinculado a uma OS
- Registra valores e status da aprovação

## Principais Relacionamentos

1. Cliente possui vários Veículos (1:N)
2. Veículo gera várias Ordens de Serviço (1:N)
3. Equipe atende várias Ordens de Serviço (1:N)
4. Mecânico pode estar em várias Equipes (N:N)
5. Ordem de Serviço possui vários Itens de Serviço (1:N)
6. Ordem de Serviço possui vários Itens de Peça (1:N)
7. Ordem de Serviço possui um Orçamento (1:1)

## Observações

- O modelo suporta o controle de estoque de peças
- Permite o registro de valores diferentes do padrão para serviços
- Mantém histórico de preços praticados em cada OS
- Controla status de aprovação e execução dos serviços
- Possibilita a gestão de equipes e especialidades
- 
[🔝 Voltar ao topo](#modelagem-conceitual-do-banco-de-dados)

## Diagrama Entidade-Relacionamento - Com Especializações

```mermaid
%%{init: {
  'flowchart': {
    'rankDir': 'TB',
    'nodeSpacing': 50,
    'rankSpacing': 50
  }
}}%%
erDiagram
    %% Grupo Pessoa/Cliente
    PESSOA ||--|{ CLIENTE : "especializa"
    PESSOA {
        int id_pessoa PK
        string nome
        string endereco
        string telefone
        string email
        string documento
        string tipo_pessoa
    }
    
    CLIENTE ||--o{ VEICULO : possui
    CLIENTE {
        int id_cliente PK
        int id_pessoa FK
        date data_cadastro
        string preferencias
    }

    %% Grupo Funcionário e Especializações
    PESSOA ||--|{ FUNCIONARIO : "especializa"
    FUNCIONARIO ||--|{ MECANICO : "especializa"
    FUNCIONARIO ||--|{ ATENDENTE : "especializa"
    FUNCIONARIO {
        int id_funcionario PK
        int id_pessoa FK
        string cargo
        date data_admissao
        decimal salario
        string turno
    }

    MECANICO {
        int id_mecanico PK
        int id_funcionario FK
        string nivel_experiencia
        string certificacoes
    }

    ATENDENTE {
        int id_atendente PK
        int id_funcionario FK
        string setor
        string nivel_acesso
    }

    %% Grupo Veículo e Especializações
    MONTADORA ||--o{ MODELO : possui
    MODELO ||--o{ VEICULO : "é do tipo"
    MONTADORA {
        int id_montadora PK
        string nome
        string pais_origem
        string site_oficial
    }

    MODELO {
        int id_modelo PK
        int id_montadora FK
        string nome
        string tipo
        string transmissao
        string motorizacao
        string combustivel
        int quantidade_portas
        string cod_fipe
    }

    VEICULO {
        int id_veiculo PK
        int id_cliente FK
        int id_modelo FK
        int id_montadora FK
        string placa
        int ano
        string chassi
        string cor
        string tipo_veiculo
        int quilometragem
    }

    %% Grupo Especialidade e Equipe
    ESPECIALIDADE ||--|{ MECANICO_ESPECIALIDADE : possui
    MECANICO ||--|{ MECANICO_ESPECIALIDADE : possui
    ESPECIALIDADE {
        int id_especialidade PK
        string nome
        string descricao
        string nivel_complexidade
        string certificacao_requerida
        int tempo_medio_servicos
    }

    MECANICO_ESPECIALIDADE {
        int id_mecanico_especialidade PK
        int id_mecanico FK
        int id_especialidade FK
        date data_certificacao
        string nivel_proficiencia
        boolean principal
    }

    EQUIPE ||--o{ EQUIPE_MECANICO : possui
    MECANICO ||--o{ EQUIPE_MECANICO : pertence
    EQUIPE {
        int id_equipe PK
        string nome
        string descricao
    }

    EQUIPE_MECANICO {
        int id_equipe FK
        int id_mecanico FK
    }

    %% Grupo Serviço e Especializações
    SERVICO ||--|{ SERVICO_REVISAO : "especializa"
    SERVICO ||--|{ SERVICO_REPARO : "especializa"
    SERVICO {
        int id_servico PK
        string descricao
        decimal valor_padrao
        string tipo
        int tempo_estimado
        string nivel_complexidade
    }
    
    SERVICO_REVISAO {
        int id_servico_revisao PK
        int id_servico FK
        int quilometragem
        string itens_revisao
        string periodicidade
    }
    
    SERVICO_REPARO {
        int id_servico_reparo PK
        int id_servico FK
        string tipo_reparo
        string area_veiculo
        string ferramentas_necessarias
    }

    %% Grupo Ordem de Serviço e Relacionamentos
    ORDEM_SERVICO ||--|| ORCAMENTO : possui
    VEICULO ||--o{ ORDEM_SERVICO : gera
    EQUIPE ||--o{ ORDEM_SERVICO : atende
    ATENDENTE ||--o{ ORDEM_SERVICO : registra
    ORDEM_SERVICO ||--|{ ITEM_SERVICO : contem
    ORDEM_SERVICO ||--|{ ITEM_PECA : utiliza
    ORDEM_SERVICO {
        int id_os PK
        datetime data_emissao
        string tipo_servico
        string status
        decimal valor_total
        boolean autorizado
        string observacoes
        int quilometragem_atual
        int id_veiculo FK
        int id_equipe FK
        int id_atendente FK
    }

    ORCAMENTO {
        int id_orcamento PK
        int id_os FK
        datetime data_orcamento
        decimal valor_total
        string status
    }

    %% Grupo Peças e Itens
    PECA ||--|{ ITEM_PECA : compoe
    SERVICO ||--|{ ITEM_SERVICO : compoe
    PECA {
        int id_peca PK
        string nome
        string codigo
        string fabricante
        string categoria
        string aplicacao
        decimal valor_unitario
        int quantidade_estoque
        int estoque_minimo
        string localizacao_estoque
    }
    
    ITEM_PECA {
        int id_item_peca PK
        int id_os FK
        int id_peca FK
        int quantidade
        decimal valor_unitario
    }

    ITEM_SERVICO {
        int id_item_servico PK
        int id_os FK
        int id_servico FK
        decimal valor_cobrado
    }
```

## Descrição dos Relacionamentos Principais

1. **Hierarquia de PESSOA**
   - PESSOA → CLIENTE (especialização)
   - PESSOA → FUNCIONARIO (especialização)

2. **Hierarquia de FUNCIONARIO**
   - FUNCIONARIO → MECANICO (especialização)
   - FUNCIONARIO → ATENDENTE (especialização)

3. **Hierarquia de SERVICO**
   - SERVICO → SERVICO_REVISAO (especialização)
   - SERVICO → SERVICO_REPARO (especialização)

4. **Relacionamentos com ORDEM_SERVICO**
   - VEICULO → ORDEM_SERVICO (1:N)
   - EQUIPE → ORDEM_SERVICO (1:N)
   - ATENDENTE → ORDEM_SERVICO (1:N)
   - ORDEM_SERVICO → ORCAMENTO (1:1)
   - ORDEM_SERVICO → ITEM_SERVICO (1:N)
   - ORDEM_SERVICO → ITEM_PECA (1:N)

5. **Relacionamentos de MECANICO**
   - MECANICO ↔ ESPECIALIDADE (N:N através de MECANICO_ESPECIALIDADE)
   - MECANICO → EQUIPE (N:N)

6. **Relacionamentos de PECA e SERVICO**
   - PECA → ITEM_PECA (1:N)
   - SERVICO → ITEM_SERVICO (1:N)

## Benefícios das Especializações

1. **Melhor Organização dos Dados**
   - Separação clara entre diferentes tipos de entidades
   - Facilita a manutenção e evolução do sistema

2. **Maior Precisão nas Informações**
   - Atributos específicos para cada tipo de entidade
   - Melhor representação do mundo real

3. **Flexibilidade**
   - Facilita a adição de novos tipos de serviços
   - Permite evolução do sistema sem grandes mudanças estruturais

4. **Integridade dos Dados**
   - Regras de negócio mais claras
   - Melhor controle de acesso e permissões

[🔝 Voltar ao topo](#modelagem-conceitual-do-banco-de-dados)
