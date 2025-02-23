-- Script de Criação do Banco de Dados da Oficina Mecânica
-- Data de Criação: 2025-02-23 01:44:26
-- Autor: marcus2703
-- Descrição: Este script cria a estrutura do banco de dados para o sistema de ordem de serviço da oficina mecânica

-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS oficina_mecanica;
USE oficina_mecanica;

-- Tabela pessoa
CREATE TABLE pessoa (
    id_pessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    email VARCHAR(100),
    documento VARCHAR(20) UNIQUE NOT NULL,
    tipo_pessoa ENUM('CLIENTE', 'FUNCIONARIO') NOT NULL
);

-- Tabela cliente
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa INT UNIQUE NOT NULL,
    data_cadastro DATE NOT NULL,
    preferencias TEXT,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

-- Tabela funcionario
CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    id_pessoa INT UNIQUE NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    data_admissao DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

-- Tabela mecanico
CREATE TABLE mecanico (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    id_funcionario INT UNIQUE NOT NULL,
    nivel_experiencia VARCHAR(20) NOT NULL,
    certificacoes TEXT,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

-- Tabela atendente
CREATE TABLE atendente (
    id_atendente INT AUTO_INCREMENT PRIMARY KEY,
    id_funcionario INT UNIQUE NOT NULL,
    setor VARCHAR(50) NOT NULL,
    nivel_acesso VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

-- Tabela montadora
CREATE TABLE montadora (
    id_montadora INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    pais_origem VARCHAR(45),
    site_oficial VARCHAR(100)
);

-- Tabela modelo
CREATE TABLE modelo (
    id_modelo INT AUTO_INCREMENT,
    id_montadora INT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    tipo VARCHAR(45) NOT NULL,
    transmissao VARCHAR(45),
    motorizacao VARCHAR(45),
    combustivel VARCHAR(45),
    quantidade_portas INT,
    cod_fipe VARCHAR(45) UNIQUE,
    PRIMARY KEY (id_modelo, id_montadora),
    FOREIGN KEY (id_montadora) REFERENCES montadora(id_montadora)
);

-- Tabela veiculo
CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_modelo INT NOT NULL,
    id_montadora INT NOT NULL,
    placa VARCHAR(10) UNIQUE NOT NULL,
    ano INT NOT NULL,
    chassi VARCHAR(17) UNIQUE NOT NULL,
    cor VARCHAR(30),
    tipo_veiculo VARCHAR(30) NOT NULL,
    quilometragem INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_modelo, id_montadora) REFERENCES modelo(id_modelo, id_montadora)
);

-- Tabela especialidade
CREATE TABLE especialidade (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    nivel_complexidade VARCHAR(20) NOT NULL,
    certificacao_requerida VARCHAR(100),
    tempo_medio_servicos INT
);

-- Tabela mecanico_especialidade
CREATE TABLE mecanico_especialidade (
    id_mecanico_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    id_mecanico INT NOT NULL,
    id_especialidade INT NOT NULL,
    data_certificacao DATE NOT NULL,
    nivel_proficiencia VARCHAR(20) NOT NULL,
    principal BOOLEAN DEFAULT false,
    UNIQUE KEY (id_mecanico, id_especialidade),
    FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

-- Tabela equipe
CREATE TABLE equipe (
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT
);

-- Tabela equipe_mecanico
CREATE TABLE equipe_mecanico (
    id_equipe INT,
    id_mecanico INT,
    PRIMARY KEY (id_equipe, id_mecanico),
    FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),
    FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico)
);

-- Tabela servico
CREATE TABLE servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT NOT NULL,
    valor_padrao DECIMAL(10,2) NOT NULL,
    tipo ENUM('REVISAO', 'REPARO') NOT NULL,
    tempo_estimado INT NOT NULL,
    nivel_complexidade VARCHAR(20) NOT NULL
);

-- Tabela servico_revisao
CREATE TABLE servico_revisao (
    id_servico_revisao INT AUTO_INCREMENT PRIMARY KEY,
    id_servico INT UNIQUE NOT NULL,
    quilometragem INT NOT NULL,
    itens_revisao TEXT NOT NULL,
    periodicidade VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

-- Tabela servico_reparo
CREATE TABLE servico_reparo (
    id_servico_reparo INT AUTO_INCREMENT PRIMARY KEY,
    id_servico INT UNIQUE NOT NULL,
    tipo_reparo VARCHAR(50) NOT NULL,
    area_veiculo VARCHAR(50) NOT NULL,
    ferramentas_necessarias TEXT,
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

-- Tabela ordem_servico
CREATE TABLE ordem_servico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
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

-- Tabela orcamento
CREATE TABLE orcamento (
    id_orcamento INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT UNIQUE NOT NULL,
    data_orcamento DATETIME NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os)
);

-- Tabela item_servico
CREATE TABLE item_servico (
    id_item_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    id_servico INT NOT NULL,
    valor_cobrado DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

-- Tabela peca
CREATE TABLE peca (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
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

-- Tabela item_peca
CREATE TABLE item_peca (
    id_item_peca INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    id_peca INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);

-- Índices adicionais para otimização
CREATE INDEX idx_pessoa_nome ON pessoa(nome);
CREATE INDEX idx_veiculo_placa ON veiculo(placa);
CREATE INDEX idx_peca_codigo ON peca(codigo);
CREATE INDEX idx_ordem_servico_data ON ordem_servico(data_emissao);
