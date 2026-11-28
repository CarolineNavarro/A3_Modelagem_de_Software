-- A3 | Modelagem de Software | 03-consultas.sql
-- Consultas obrigatorias 01 a 17 - SQLite / DB Browser for SQLite
-- Executar apos 00-base-fornecida.sql, 01-schema.sql e 02-dados.sql.
-- Convencoes: datas ISO; tarifa: inicio inclusivo e fim exclusivo;
-- contratos: inicio e fim inclusivos; competencia = mes/ano.
-- RN05 e RN14: consultas 16 e 17 devem retornar zero linhas.

-- 01 | RN06 | Quais veiculos estao no estacionamento agora? Placa e entrada, do mais antigo ao mais recente.
SELECT placa, data_hora_entrada
FROM estadia
WHERE data_hora_saida IS NULL
ORDER BY data_hora_entrada ASC, placa;

-- 02 | RN02 | Quais veiculos cadastrados nao tem cliente associado?
SELECT placa, cod_modelo
FROM veiculo
WHERE cod_cliente IS NULL
ORDER BY placa;

-- 03 | RN13 | Mensalidades nao pagas: contrato, competencia e vencimento.
SELECT cod_contrato, printf('%02d/%04d', mes, ano) AS competencia, data_vencimento
FROM mensalidade
WHERE data_pagamento IS NULL
ORDER BY data_vencimento, cod_contrato;

-- 04 | RN09 | Tarifa por hora vigente em 05/03/2024.
SELECT cod_tarifa, valor_hora, inicio_vigencia, fim_vigencia
FROM tarifa
WHERE inicio_vigencia <= '2024-03-05'
  AND (fim_vigencia IS NULL OR fim_vigencia > '2024-03-05');

-- 05 | RN06 | Quantas estadias comecaram em cada dia?
SELECT date(data_hora_entrada) AS dia, COUNT(*) AS quantidade_estadias
FROM estadia
GROUP BY date(data_hora_entrada)
ORDER BY dia;

-- 06 | RN10 | Quanto foi recebido por forma de pagamento?
SELECT forma_pagamento, ROUND(SUM(valor), 2) AS total_recebido
FROM pagamento
GROUP BY forma_pagamento
ORDER BY forma_pagamento;

-- 07 | RN15 | Quantas ocorrencias houve de cada tipo?
SELECT tipo, COUNT(*) AS quantidade_ocorrencias
FROM ocorrencia
GROUP BY tipo
ORDER BY tipo;

-- 08 | RN06 | Permanencia media, em minutos, das estadias encerradas.
SELECT ROUND(AVG((julianday(data_hora_saida) - julianday(data_hora_entrada)) * 1440), 2)
       AS permanencia_media_minutos
FROM estadia
WHERE data_hora_saida IS NOT NULL;

-- 09 | RN01 | Para cada estadia, placa, marca e modelo do veiculo.
SELECT e.cod_estadia, v.placa, ma.nome AS marca, mo.nome AS modelo
FROM estadia AS e
JOIN veiculo AS v ON v.placa = e.placa
JOIN modelo AS mo ON mo.cod_modelo = v.cod_modelo
JOIN marca AS ma ON ma.cod_marca = mo.cod_marca
ORDER BY e.cod_estadia;

-- 10 | RN12 | Contratos com cliente, placa e modelo do veiculo.
SELECT c.cod_contrato, cl.nome AS cliente, c.placa, mo.nome AS modelo,
       c.data_inicio, c.data_fim, c.valor_mensal
FROM contrato AS c
JOIN cliente AS cl ON cl.cod_cliente = c.cod_cliente
JOIN veiculo AS v ON v.placa = c.placa
JOIN modelo AS mo ON mo.cod_modelo = v.cod_modelo
ORDER BY c.cod_contrato;

-- 11 | RN11 | Quantas estadias por loja, incluindo lojas sem nenhuma estadia?
SELECT l.cod_loja, l.nome AS loja, COUNT(e.cod_estadia) AS quantidade_estadias
FROM loja_conveniada AS l
LEFT JOIN estadia AS e ON e.cod_loja = l.cod_loja
GROUP BY l.cod_loja, l.nome
ORDER BY l.cod_loja;

-- 12 | RN15 | Ocorrencias com data/hora, tipo, placa e funcionario responsavel.
SELECT o.cod_ocorrencia, o.data_hora, o.tipo,
       e.placa, f.nome AS funcionario
FROM ocorrencia AS o
JOIN estadia AS e ON e.cod_estadia = o.cod_estadia
JOIN funcionario AS f ON f.cod_funcionario = o.cod_funcionario
ORDER BY o.data_hora, o.cod_ocorrencia;

-- 13 | RN03/RN04 | Quantas vagas estao livres agora?
-- Contagem considera estadias sem saida de rotativos E mensalistas.
SELECT p.cod_estacionamento, p.capacidade_maxima,
       COUNT(e.cod_estadia) AS vagas_ocupadas,
       p.capacidade_maxima - COUNT(e.cod_estadia) AS vagas_livres
FROM estacionamento AS p
LEFT JOIN estadia AS e
  ON e.cod_estacionamento = p.cod_estacionamento
 AND e.data_hora_saida IS NULL
GROUP BY p.cod_estacionamento, p.capacidade_maxima
ORDER BY p.cod_estacionamento;

-- 14 | RN08/RN09 | Valor devido em cada estadia rotativa ENCERRADA,
-- usando a tarifa vigente na data de entrada e hora fracionada arredondada para cima.
-- Os intervalos de tarifa sao [inicio_vigencia, fim_vigencia).
-- Cobranca por minutos: CAST(minutos / 60 AS INTEGER) + 1 se houver fracao.
WITH rotativas AS (
    SELECT e.cod_estadia, e.placa, e.data_hora_entrada, e.data_hora_saida,
           CAST(ROUND((julianday(e.data_hora_saida) - julianday(e.data_hora_entrada)) * 86400) AS INTEGER) AS segundos
    FROM estadia AS e
    WHERE e.data_hora_saida IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM contrato AS c
          WHERE c.placa = e.placa
            AND date(e.data_hora_entrada) BETWEEN c.data_inicio AND c.data_fim
      )
), cobranca AS (
    SELECT r.*, t.cod_tarifa, t.valor_hora,
           CAST((r.segundos + 3599) / 3600 AS INTEGER) AS horas_cobradas
    FROM rotativas AS r
    JOIN tarifa AS t
      ON date(r.data_hora_entrada) >= t.inicio_vigencia
     AND (t.fim_vigencia IS NULL OR date(r.data_hora_entrada) < t.fim_vigencia)
)
SELECT cod_estadia, placa, data_hora_entrada, data_hora_saida,
       cod_tarifa, valor_hora, horas_cobradas,
       ROUND(horas_cobradas * valor_hora, 2) AS valor_devido
FROM cobranca
ORDER BY cod_estadia;

-- 15 | RN07 | Classificar CADA estadia pelo contrato vigente na data da entrada.
-- A vinculacao atual do veiculo a um cliente nao determina sua classificacao.
SELECT e.cod_estadia, e.placa, e.data_hora_entrada,
       CASE WHEN EXISTS (
           SELECT 1 FROM contrato AS c
           WHERE c.placa = e.placa
             AND date(e.data_hora_entrada) BETWEEN c.data_inicio AND c.data_fim
       ) THEN 'Mensalista' ELSE 'Rotativa' END AS tipo_estadia
FROM estadia AS e
ORDER BY e.cod_estadia;

-- 16 | RN05 | Auditoria: placas com mais de uma estadia em aberto (esperado: vazio).
SELECT placa, COUNT(*) AS estadias_abertas
FROM estadia
WHERE data_hora_saida IS NULL
GROUP BY placa
HAVING COUNT(*) > 1
ORDER BY placa;

-- 17 | RN14 | Auditoria: pares de contratos do mesmo veiculo com vigencias sobrepostas (esperado: vazio).
-- Datas dos contratos sao inclusivas.
SELECT c1.placa, c1.cod_contrato AS contrato_1, c1.data_inicio AS inicio_1,
       c1.data_fim AS fim_1, c2.cod_contrato AS contrato_2,
       c2.data_inicio AS inicio_2, c2.data_fim AS fim_2
FROM contrato AS c1
JOIN contrato AS c2
  ON c1.placa = c2.placa
 AND c1.cod_contrato < c2.cod_contrato
 AND c1.data_inicio <= c2.data_fim
 AND c2.data_inicio <= c1.data_fim
ORDER BY c1.placa, c1.cod_contrato, c2.cod_contrato;
