PRAGMA foreign_keys = ON;

-- A3 - Modelagem de Software | Sistema de Gestao de Estacionamento
-- Execute 00-base-fornecida.sql ANTES deste arquivo.
-- Nao recriar nem alterar as tabelas marca e modelo.
-- Datas: YYYY-MM-DD; data/hora: YYYY-MM-DD HH:MM:SS (formato local consistente).

DROP TABLE IF EXISTS "cliente";
CREATE TABLE "cliente" (
	"cod_cliente"	INTEGER,
	"nome"	TEXT NOT NULL,
	"email"	TEXT UNIQUE,
	PRIMARY KEY("cod_cliente")
);
DROP TABLE IF EXISTS "cliente_telefone";
CREATE TABLE "cliente_telefone" (
	"cod_telefone"	INTEGER,
	"cod_cliente"	INTEGER NOT NULL,
	"telefone"	TEXT NOT NULL,
	UNIQUE("cod_cliente","telefone"),
	PRIMARY KEY("cod_telefone"),
	FOREIGN KEY("cod_cliente") REFERENCES "cliente"("cod_cliente")
);
DROP TABLE IF EXISTS "contrato";
CREATE TABLE "contrato" (
	"cod_contrato"	INTEGER,
	"cod_cliente"	INTEGER NOT NULL,
	"placa"	TEXT NOT NULL,
	"data_inicio"	TEXT NOT NULL,
	"data_fim"	TEXT NOT NULL,
	"valor_mensal"	NUMERIC NOT NULL CHECK("valor_mensal" > 0),
	PRIMARY KEY("cod_contrato"),
	FOREIGN KEY("cod_cliente") REFERENCES "cliente"("cod_cliente"),
	FOREIGN KEY("placa") REFERENCES "veiculo"("placa"),
	CHECK("data_fim" >= "data_inicio")
);
DROP TABLE IF EXISTS "estacionamento";
CREATE TABLE "estacionamento" (
	"cod_estacionamento"	INTEGER,
	"endereco"	TEXT NOT NULL,
	"capacidade_maxima"	INTEGER NOT NULL CHECK("capacidade_maxima" > 0),
	PRIMARY KEY("cod_estacionamento")
);
DROP TABLE IF EXISTS "estadia";
CREATE TABLE "estadia" (
	"cod_estadia"	INTEGER,
	"placa"	TEXT NOT NULL,
	"cod_funcionario"	INTEGER NOT NULL,
	"cod_estacionamento"	INTEGER NOT NULL,
	"cod_loja"	INTEGER,
	"cod_tarifa"	INTEGER,
	"data_hora_entrada"	TEXT NOT NULL,
	"data_hora_saida"	TEXT,
	PRIMARY KEY("cod_estadia"),
	FOREIGN KEY("cod_estacionamento") REFERENCES "estacionamento"("cod_estacionamento"),
	FOREIGN KEY("cod_funcionario") REFERENCES "funcionario"("cod_funcionario"),
	FOREIGN KEY("cod_loja") REFERENCES "loja_conveniada"("cod_loja"),
	FOREIGN KEY("cod_tarifa") REFERENCES "tarifa"("cod_tarifa"),
	FOREIGN KEY("placa") REFERENCES "veiculo"("placa"),
	CHECK("data_hora_saida" IS NULL OR "data_hora_saida" > "data_hora_entrada")
);
DROP TABLE IF EXISTS "funcionario";
CREATE TABLE "funcionario" (
	"cod_funcionario"	INTEGER,
	"nome"	TEXT NOT NULL,
	PRIMARY KEY("cod_funcionario")
);
DROP TABLE IF EXISTS "loja_conveniada";
CREATE TABLE "loja_conveniada" (
	"cod_loja"	INTEGER,
	"nome"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("cod_loja")
);
DROP TABLE IF EXISTS "mensalidade";
CREATE TABLE "mensalidade" (
	"cod_mensalidade"	INTEGER,
	"cod_contrato"	INTEGER NOT NULL,
	"mes"	INTEGER NOT NULL CHECK("mes" BETWEEN 1 AND 12),
	"ano"	INTEGER NOT NULL CHECK("ano" BETWEEN 2000 AND 9999),
	"data_vencimento"	TEXT NOT NULL,
	"data_pagamento"	TEXT,
	UNIQUE("cod_contrato","mes","ano"),
	PRIMARY KEY("cod_mensalidade"),
	FOREIGN KEY("cod_contrato") REFERENCES "contrato"("cod_contrato")
);
DROP TABLE IF EXISTS "ocorrencia";
CREATE TABLE "ocorrencia" (
	"cod_ocorrencia"	INTEGER,
	"cod_estadia"	INTEGER NOT NULL,
	"cod_funcionario"	INTEGER NOT NULL,
	"data_hora"	TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
	"tipo"	TEXT NOT NULL,
	"descricao"	TEXT NOT NULL,
	PRIMARY KEY("cod_ocorrencia"),
	FOREIGN KEY("cod_estadia") REFERENCES "estadia"("cod_estadia"),
	FOREIGN KEY("cod_funcionario") REFERENCES "funcionario"("cod_funcionario")
);
DROP TABLE IF EXISTS "pagamento";
CREATE TABLE "pagamento" (
	"cod_pagamento"	INTEGER,
	"cod_estadia"	INTEGER NOT NULL UNIQUE,
	"cod_funcionario"	INTEGER NOT NULL,
	"forma_pagamento"	TEXT NOT NULL CHECK("forma_pagamento" IN ('Dinheiro', 'Débito', 'Crédito', 'PIX')),
	"valor"	NUMERIC NOT NULL CHECK("valor" >= 0),
	PRIMARY KEY("cod_pagamento"),
	FOREIGN KEY("cod_estadia") REFERENCES "estadia"("cod_estadia"),
	FOREIGN KEY("cod_funcionario") REFERENCES "funcionario"("cod_funcionario")
);
DROP TABLE IF EXISTS "tarifa";
CREATE TABLE "tarifa" (
	"cod_tarifa"	INTEGER,
	"valor_hora"	NUMERIC NOT NULL CHECK("valor_hora" > 0),
	"inicio_vigencia"	TEXT NOT NULL UNIQUE,
	"fim_vigencia"	TEXT,
	PRIMARY KEY("cod_tarifa"),
	CHECK("fim_vigencia" IS NULL OR "fim_vigencia" > "inicio_vigencia")
);
DROP TABLE IF EXISTS "veiculo";
CREATE TABLE "veiculo" (
	"placa"	TEXT NOT NULL,
	"cod_modelo"	INTEGER NOT NULL,
	"cod_cliente"	INTEGER,
	PRIMARY KEY("placa"),
	FOREIGN KEY("cod_cliente") REFERENCES "cliente"("cod_cliente"),
	FOREIGN KEY("cod_modelo") REFERENCES "modelo"("cod_modelo"),
	CHECK(length(trim("placa")) = 7)
);
DROP INDEX IF EXISTS "idx_contrato_placa_periodo";
CREATE INDEX "idx_contrato_placa_periodo" ON "contrato" (
	"placa",
	"data_inicio",
	"data_fim"
);
DROP INDEX IF EXISTS "idx_estadia_entrada";
CREATE INDEX "idx_estadia_entrada" ON "estadia" (
	"data_hora_entrada"
);
DROP INDEX IF EXISTS "idx_estadia_placa_saida";
CREATE INDEX "idx_estadia_placa_saida" ON "estadia" (
	"placa",
	"data_hora_saida"
);
DROP INDEX IF EXISTS "idx_tarifa_vigencia";
CREATE INDEX "idx_tarifa_vigencia" ON "tarifa" (
	"inicio_vigencia",
	"fim_vigencia"
);
