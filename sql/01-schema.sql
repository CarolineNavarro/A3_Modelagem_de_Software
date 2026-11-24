PRAGMA foreign_keys = ON;

-- A3 - Modelagem de Software | Sistema de Gestao de Estacionamento
-- Execute 00-base-fornecida.sql ANTES deste arquivo.
-- Nao recriar nem alterar as tabelas marca e modelo.
-- Datas: YYYY-MM-DD; data/hora: YYYY-MM-DD HH:MM:SS (formato local consistente).

-- RN03 / RN04: um estacionamento, com capacidade compartilhada.
CREATE TABLE estacionamento (
    cod_estacionamento INTEGER PRIMARY KEY,
    nome               TEXT NOT NULL,
    logradouro         TEXT NOT NULL,
    numero             TEXT NOT NULL,
    bairro             TEXT NOT NULL,
    cidade             TEXT NOT NULL,
    uf                 TEXT NOT NULL CHECK (length(uf) = 2),
    cep                TEXT NOT NULL,
    capacidade_maxima  INTEGER NOT NULL CHECK (capacidade_maxima > 0)
);

-- RN02: cadastro de cliente; telefone foi separado por ser multivalorado.
CREATE TABLE cliente (
    cod_cliente INTEGER PRIMARY KEY,
    nome        TEXT NOT NULL,
    email       TEXT UNIQUE
);

CREATE TABLE cliente_telefone (
    cod_cliente INTEGER NOT NULL,
    telefone    TEXT NOT NULL CHECK (length(trim(telefone)) >= 8),
    PRIMARY KEY (cod_cliente, telefone),
    FOREIGN KEY (cod_cliente) REFERENCES cliente (cod_cliente)
);

-- RN06 / RN10 / RN15: funcionario registra entrada, recebe pagamento e registra ocorrencia.
CREATE TABLE funcionario (
    cod_funcionario INTEGER PRIMARY KEY,
    nome            TEXT NOT NULL
);

-- RN01 / RN02: referencia obrigatoria ao modelo da base fornecida.
CREATE TABLE veiculo (
    placa       TEXT PRIMARY KEY NOT NULL,
    cod_modelo  INTEGER NOT NULL,
    cod_cliente INTEGER,
    CHECK (length(trim(placa)) = 7),
    FOREIGN KEY (cod_modelo) REFERENCES modelo (cod_modelo),
    FOREIGN KEY (cod_cliente) REFERENCES cliente (cod_cliente)
);

-- RN08 / RN09: tarifa unica por periodo, com historico de vigencia.
-- Convenção adotada: inicio inclusivo e fim exclusivo; NULL = sem termino definido.
CREATE TABLE tarifa (
    cod_tarifa     INTEGER PRIMARY KEY,
    valor_hora     NUMERIC NOT NULL CHECK (valor_hora > 0),
    inicio_vigencia TEXT NOT NULL UNIQUE,
    fim_vigencia    TEXT,
    CHECK (fim_vigencia IS NULL OR fim_vigencia > inicio_vigencia)
);

-- RN11: loja conveniada nao concede desconto.
CREATE TABLE loja_conveniada (
    cod_loja INTEGER PRIMARY KEY,
    nome     TEXT NOT NULL UNIQUE
);

-- RN12 / RN14: um cliente e um veiculo por contrato.
CREATE TABLE contrato (
    cod_contrato  INTEGER PRIMARY KEY,
    cod_cliente   INTEGER NOT NULL,
    placa         TEXT NOT NULL,
    data_inicio   TEXT NOT NULL,
    data_fim      TEXT NOT NULL,
    valor_mensal  NUMERIC NOT NULL CHECK (valor_mensal > 0),
    CHECK (data_fim >= data_inicio),
    FOREIGN KEY (cod_cliente) REFERENCES cliente (cod_cliente),
    FOREIGN KEY (placa) REFERENCES veiculo (placa)
);

-- RN13: entidade fraca identificada por contrato + competencia (mes, ano).
CREATE TABLE mensalidade (
    cod_contrato    INTEGER NOT NULL,
    mes             INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
    ano             INTEGER NOT NULL CHECK (ano BETWEEN 2000 AND 9999),
    data_vencimento TEXT NOT NULL,
    data_pagamento  TEXT,
    PRIMARY KEY (cod_contrato, mes, ano),
    FOREIGN KEY (cod_contrato) REFERENCES contrato (cod_contrato)
);

-- RN05 / RN06 / RN07 / RN11: uma estadia por entrada; saida e vinculo a loja opcionais.
-- cod_tarifa opcional: somente rotativas possuem tarifa aplicada.
CREATE TABLE estadia (
    cod_estadia         INTEGER PRIMARY KEY,
    placa               TEXT NOT NULL,
    cod_funcionario     INTEGER NOT NULL,
    cod_estacionamento  INTEGER NOT NULL,
    cod_loja            INTEGER,
    cod_tarifa          INTEGER,
    data_hora_entrada   TEXT NOT NULL,
    data_hora_saida     TEXT,
    CHECK (data_hora_saida IS NULL OR data_hora_saida > data_hora_entrada),
    FOREIGN KEY (placa) REFERENCES veiculo (placa),
    FOREIGN KEY (cod_funcionario) REFERENCES funcionario (cod_funcionario),
    FOREIGN KEY (cod_estacionamento) REFERENCES estacionamento (cod_estacionamento),
    FOREIGN KEY (cod_loja) REFERENCES loja_conveniada (cod_loja),
    FOREIGN KEY (cod_tarifa) REFERENCES tarifa (cod_tarifa)
);

-- RN10: um pagamento no maximo por estadia; funcionario obrigatorio.
CREATE TABLE pagamento (
    cod_pagamento   INTEGER PRIMARY KEY,
    cod_estadia     INTEGER NOT NULL UNIQUE,
    cod_funcionario INTEGER NOT NULL,
    forma_pagamento TEXT NOT NULL
       CHECK (forma_pagamento IN ('Dinheiro', 'Débito', 'Crédito', 'PIX')),
    valor           NUMERIC NOT NULL CHECK (valor >= 0),
    FOREIGN KEY (cod_estadia) REFERENCES estadia (cod_estadia),
    FOREIGN KEY (cod_funcionario) REFERENCES funcionario (cod_funcionario)
);

-- RN15: toda ocorrencia pertence a uma estadia e a um funcionario.
CREATE TABLE ocorrencia (
    cod_ocorrencia  INTEGER PRIMARY KEY,
    cod_estadia     INTEGER NOT NULL,
    cod_funcionario INTEGER NOT NULL,
    data_hora       TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    tipo            TEXT NOT NULL,
    descricao       TEXT NOT NULL,
    FOREIGN KEY (cod_estadia) REFERENCES estadia (cod_estadia),
    FOREIGN KEY (cod_funcionario) REFERENCES funcionario (cod_funcionario)
);

-- Indices para consultas das estadias, contratos e auditorias.
CREATE INDEX idx_estadia_placa_saida ON estadia (placa, data_hora_saida);
CREATE INDEX idx_estadia_entrada ON estadia (data_hora_entrada);
CREATE INDEX idx_contrato_placa_periodo ON contrato (placa, data_inicio, data_fim);
CREATE INDEX idx_tarifa_vigencia ON tarifa (inicio_vigencia, fim_vigencia);
