# Modelagem Lógica do Banco de Dados

## Tabelas Base

### Pessoa
```sql
CREATE TABLE pessoa (
    id_pessoa INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    email VARCHAR(100),
    documento VARCHAR(20) UNIQUE NOT NULL,
    tipo_pessoa ENUM('CLIENTE', 'FUNCIONARIO') NOT NULL
);
```

### Cliente
```sql
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    id_pessoa INT UNIQUE NOT NULL,
    data_cadastro DATE NOT NULL,
    preferencias TEXT,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);
```

### Funcionario
```sql
CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY,
    id_pessoa INT UNIQUE NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    data_admissao DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);
```

### Especialidade
```sql
CREATE TABLE especialidade (
    id_especialidade INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    nivel_complexidade VARCHAR(20) NOT NULL,
    certificacao_requerida VARCHAR(100),
    tempo_medio_servicos INT
);
```

### Mecanico
```sql
CREATE TABLE mecanico (
    id_mecanico INT PRIMARY KEY,
    id_funcionario INT UNIQUE NOT NULL,
    nivel_experiencia VARCHAR(20) NOT NULL,
    certificacoes TEXT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);
```

### Mecanico_Especialidade
```sql
CREATE TABLE mecanico_especialidade (
    id_mecanico_especialidade INT PRIMARY KEY,
    id_mecanico INT NOT NULL,
    id_especialidade INT NOT NULL,
    data_certificacao DATE NOT NULL,
    nivel_proficiencia VARCHAR(20) NOT NULL,
    principal BOOLEAN DEFAULT false,
    FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade),
    UNIQUE (id_mecanico, id_especialidade)
);
```

### Atendente
```sql
CREATE TABLE atendente (
    id_atendente INT PRIMARY KEY,
    id_funcionario INT UNIQUE NOT NULL,
    setor VARCHAR(50) NOT NULL,
    nivel_acesso VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);
```

### Veiculo
```sql
CREATE TABLE veiculo (
    id_veiculo INT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    chassi VARCHAR(17) UNIQUE NOT NULL,
    cor VARCHAR(30),
    tipo_veiculo VARCHAR(30) NOT NULL,
    quilometragem INT NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);
```

### Equipe
```sql
CREATE TABLE equipe (
    id_equipe INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT
);
```

### Equipe_Mecanico
```sql
CREATE TABLE equipe_mecanico (
    id_equipe INT,
    id_mecanico INT,
    PRIMARY KEY (id_equipe, id_mecanico),
    FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),
    FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico)
);
```

### Servico
```sql
CREATE TABLE servico (
    id_servico INT PRIMARY KEY,
    descricao TEXT NOT NULL,
    valor_padrao DECIMAL(10,2) NOT NULL,
    tipo ENUM('REVISAO', 'REPARO') NOT NULL,
    tempo_estimado INT NOT NULL,
    nivel_complexidade VARCHAR(20) NOT NULL
);
```

### Servico_Revisao
```sql
CREATE TABLE servico_revisao (
    id_servico_revisao INT PRIMARY KEY,
    id_servico INT UNIQUE NOT NULL,
    quilometragem INT NOT NULL,
    itens_revisao TEXT NOT NULL,
    periodicidade VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);
```

### Servico_Reparo
```sql
CREATE TABLE servico_reparo (
    id_servico_reparo INT PRIMARY KEY,
    id_servico INT UNIQUE NOT NULL,
    tipo_reparo VARCHAR(50) NOT NULL,
    area_veiculo VARCHAR(50) NOT NULL,
    ferramentas_necessarias TEXT,
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);
```

### Ordem_Servico
```sql
CREATE TABLE ordem_servico (
    id_os INT PRIMARY KEY,
    data_emissao DATETIME NOT NULL,
    tipo_servico ENUM('REVISAO', 'REPARO') NOT NULL,
    status VARCHAR(30) NOT NULL,
    valor_total DECIMAL(10,2),
    autorizado BOOLEAN DEFAULT false,
    observacoes TEXT,
    quilometragem_atual INT NOT NULL,
    id_veiculo INT NOT NULL,
    id_equipe INT NOT NULL,
    id_atendente INT NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),
    FOREIGN KEY (id_atendente) REFERENCES atendente(id_atendente)
);
```

### Orcamento
```sql
CREATE TABLE orcamento (
    id_orcamento INT PRIMARY KEY,
    id_os INT UNIQUE NOT NULL,
    data_orcamento DATETIME NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os)
);
```

### Item_Servico
```sql
CREATE TABLE item_servico (
    id_item_servico INT PRIMARY KEY,
    id_os INT NOT NULL,
    id_servico INT NOT NULL,
    valor_cobrado DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);
```

### Peca
```sql
CREATE TABLE peca (
    id_peca INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    fabricante VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    aplicacao TEXT,
    valor_unitario DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL,
    estoque_minimo INT NOT NULL,
    localizacao_estoque VARCHAR(50)
);
```

### Item_Peca
```sql
CREATE TABLE item_peca (
    id_item_peca INT PRIMARY KEY,
    id_os INT NOT NULL,
    id_peca INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);
```

## Observações Importantes

1. **Integridade Referencial:**
   - Todas as chaves estrangeiras têm referências explícitas
   - Relacionamentos N:N foram decompostos em tabelas associativas

2. **Tipos de Dados:**
   - Uso de DECIMAL(10,2) para valores monetários
   - VARCHAR com limites apropriados
   - TEXT para campos longos
   - ENUM para valores predefinidos

3. **Restrições:**
   - NOT NULL onde apropriado
   - UNIQUE para campos que não podem ter duplicatas
   - DEFAULT valores quando necessário

4. **Especializações:**
   - Implementadas através de tabelas separadas com chaves estrangeiras
   - Relação 1:1 entre tabela genérica e especializada
