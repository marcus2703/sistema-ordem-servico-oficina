# Modelagem Conceitual do Banco de Dados

## Introdução

Este documento apresenta a modelagem conceitual do banco de dados para o Sistema de Controle e Gerenciamento de Execução de Ordens de Serviço em uma Oficina Mecânica.
O modelo foi desenvolvido com base nos requisitos, casos de uso e histórias de usuário previamente documentados.

## Diagrama Entidade-Relacionamento

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

# Modelagem Conceitual do Banco de Dados - Com Especializações

```mermaid
erDiagram
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
    CLIENTE }|--|| PESSOA : "é"
    CLIENTE {
        int id_cliente PK
        int id_pessoa FK
        date data_cadastro
        string preferencias
    }
    
    FUNCIONARIO }|--|| PESSOA : "é"
    FUNCIONARIO {
        int id_funcionario PK
        int id_pessoa FK
        string cargo
        date data_admissao
        decimal salario
        string turno
    }

    ESPECIALIDADE ||--|{ MECANICO_ESPECIALIDADE : possui
    ESPECIALIDADE {
        int id_especialidade PK
        string nome
        string descricao
        string nivel_complexidade
        string certificacao_requerida
        int tempo_medio_servicos
    }
    
    MECANICO }|--|| FUNCIONARIO : "é"
    MECANICO ||--|{ MECANICO_ESPECIALIDADE : possui
    MECANICO {
        int id_mecanico PK
        int id_funcionario FK
        string nivel_experiencia
        string certificacoes
    }

    MECANICO_ESPECIALIDADE {
        int id_mecanico_especialidade PK
        int id_mecanico FK
        int id_especialidade FK
        date data_certificacao
        string nivel_proficiencia
        boolean principal
    }
    
    ATENDENTE }|--|| FUNCIONARIO : "é"
    ATENDENTE {
        int id_atendente PK
        int id_funcionario FK
        string setor
        string nivel_acesso
    }
    
    VEICULO ||--o{ ORDEM_SERVICO : gera
    VEICULO {
        int id_veiculo PK
        string placa
        string marca
        string modelo
        int ano
        string chassi
        string cor
        string tipo_veiculo
        int quilometragem
        int id_cliente FK
    }
    
    SERVICO {
        int id_servico PK
        string descricao
        decimal valor_padrao
        string tipo
        int tempo_estimado
        string nivel_complexidade
    }
    
    SERVICO_REVISAO }|--|| SERVICO : "é"
    SERVICO_REVISAO {
        int id_servico_revisao PK
        int id_servico FK
        int quilometragem
        string itens_revisao
        string periodicidade
    }
    
    SERVICO_REPARO }|--|| SERVICO : "é"
    SERVICO_REPARO {
        int id_servico_reparo PK
        int id_servico FK
        string tipo_reparo
        string area_veiculo
        string ferramentas_necessarias
    }
    
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
    
    ORDEM_SERVICO ||--|{ ITEM_SERVICO : possui
    ORDEM_SERVICO ||--|{ ITEM_PECA : possui
    ORDEM_SERVICO {
        int id_os PK
        date data_emissao
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
```

## Descrição das Especializações

### 1. Especialização de PESSOA
- **Entidade Genérica:** PESSOA
- **Especializações:** 
  - CLIENTE
  - FUNCIONARIO (que por sua vez tem suas próprias especializações)

### 2. Especialização de FUNCIONARIO
- **Entidade Genérica:** FUNCIONARIO
- **Especializações:**
  - MECANICO (com relação com ESPECIALIDADE)
  - ATENDENTE

### 3. Especialização de SERVICO
- **Entidade Genérica:** SERVICO
- **Especializações:**
  - SERVICO_REVISAO
  - SERVICO_REPARO

### 4. Estrutura de ESPECIALIDADE
- **Entidade:** ESPECIALIDADE
- **Relacionamento:** N:N com MECANICO através de MECANICO_ESPECIALIDADE
- **Benefícios:**
  - Melhor controle das competências dos mecânicos
  - Histórico de certificações
  - Gestão de níveis de proficiência

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
