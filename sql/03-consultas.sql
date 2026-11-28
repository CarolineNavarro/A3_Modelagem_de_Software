-- A3 | Modelagem de Software | 03-consultas.sql
-- Consultas obrigatorias 01 a 17 - SQLite / DB Browser for SQLite
-- Executar apos 00-base-fornecida.sql, 01-schema.sql e 02-dados.sql.
-- Convencoes: datas ISO; tarifa: inicio inclusivo e fim exclusivo;
-- contratos: inicio e fim inclusivos; competencia = mes/ano.
-- RN05 e RN14: consultas 16 e 17 devem retornar zero linhas.

-- 01 | Quais veículos estão no estacionamento agora (entrada sem saída)? Mostre placa e horário de entrada, do mais antigo ao mais recente.
SELECT placa, data_hora_entrada
FROM estadia
WHERE data_hora_saida IS NULL
ORDER BY data_hora_entrada ASC, placa;

-- 02 | Quais veículos cadastrados não têm cliente associado?
SELECT placa, cod_modelo
FROM veiculo
WHERE cod_cliente IS NULL
ORDER BY placa;

-- 03 | Quais mensalidades ainda não foram pagas? Mostre contrato, competência e vencimento.
SELECT cod_contrato, printf('%02d/%04d', mes, ano) AS competencia, data_vencimento
FROM mensalidade
WHERE data_pagamento IS NULL
ORDER BY data_vencimento, cod_contrato;

-- 04 | Qual era a tarifa por hora vigente em 05/03/2024?
SELECT cod_tarifa, valor_hora, inicio_vigencia, fim_vigencia
FROM tarifa
WHERE inicio_vigencia <= '2024-03-05'
  AND (fim_vigencia IS NULL OR fim_vigencia > '2024-03-05');

-- 05 | Quantas estadias começaram em cada dia?
SELECT date(data_hora_entrada) AS dia, COUNT(*) AS quantidade_estadias
FROM estadia
GROUP BY date(data_hora_entrada)
ORDER BY dia;

-- 06 | Quanto foi recebido em cada forma de pagamento?
SELECT forma_pagamento, ROUND(SUM(valor), 2) AS total_recebido
FROM pagamento
GROUP BY forma_pagamento
ORDER BY forma_pagamento;

-- 07 | Quantas ocorrências houve de cada tipo?
SELECT tipo, COUNT(*) AS quantidade_ocorrencias
FROM ocorrencia
GROUP BY tipo
ORDER BY tipo;

-- 08 | Qual a permanência média, em minutos, das estadias encerradas?
SELECT ROUND(AVG((julianday(data_hora_saida) - julianday(data_hora_entrada)) * 1440), 2)
       AS permanencia_media_minutos
FROM estadia
WHERE data_hora_saida IS NOT NULL;

-- 09 | Para cada estadia, mostrar a placa, a marca e o modelo do veículo.
SELECT e.cod_estadia, v.placa, ma.nome AS marca, mo.nome AS modelo
FROM estadia AS e
JOIN veiculo AS v ON v.placa = e.placa
JOIN modelo AS mo ON mo.cod_modelo = v.cod_modelo
JOIN marca AS ma ON ma.cod_marca = mo.cod_marca
ORDER BY e.cod_estadia;

-- 10 | Listar os contratos com o nome do cliente, a placa e o modelo do veículo.
SELECT c.cod_contrato, cl.nome AS cliente, c.placa, mo.nome AS modelo,
       c.data_inicio, c.data_fim, c.valor_mensal
FROM contrato AS c
JOIN cliente AS cl ON cl.cod_cliente = c.cod_cliente
JOIN veiculo AS v ON v.placa = c.placa
JOIN modelo AS mo ON mo.cod_modelo = v.cod_modelo
ORDER BY c.cod_contrato;

-- 11 | Quantas estadias cada loja conveniada vinculou, incluindo as lojas sem nenhuma?
SELECT l.cod_loja, l.nome AS loja, COUNT(e.cod_estadia) AS quantidade_estadias
FROM loja_conveniada AS l
LEFT JOIN estadia AS e ON e.cod_loja = l.cod_loja
GROUP BY l.cod_loja, l.nome
ORDER BY l.cod_loja;

-- 12 | Listar as ocorrências com data e hora, tipo, placa do veículo e nome do funcionário que registrou.
SELECT o.cod_ocorrencia, o.data_hora, o.tipo,
       e.placa, f.nome AS funcionario
FROM ocorrencia AS o
JOIN estadia AS e ON e.cod_estadia = o.cod_estadia
JOIN funcionario AS f ON f.cod_funcionario = o.cod_funcionario
ORDER BY o.data_hora, o.cod_ocorrencia;

-- 13 | Quantas vagas estão livres agora?
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

-- 14 | Qual o valor devido em cada estadia rotativa encerrada, pela tarifa vigente na data da entrada, com fração contando como hora cheia?
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

-- 15 | Classificar cada estadia como rotativa ou de mensalista (veículo com contrato vigente na data da entrada).
-- A vinculacao atual do veiculo a um cliente nao determina sua classificacao.
SELECT e.cod_estadia, e.placa, e.data_hora_entrada,
       CASE WHEN EXISTS (
           SELECT 1 FROM contrato AS c
           WHERE c.placa = e.placa
             AND date(e.data_hora_entrada) BETWEEN c.data_inicio AND c.data_fim
       ) THEN 'Mensalista' ELSE 'Rotativa' END AS tipo_estadia
FROM estadia AS e
ORDER BY e.cod_estadia;

-- 16 | Auditoria: quais placas têm mais de uma estadia em aberto? (deve retornar vazio)
SELECT placa, COUNT(*) AS estadias_abertas
FROM estadia
WHERE data_hora_saida IS NULL
GROUP BY placa
HAVING COUNT(*) > 1
ORDER BY placa;

-- 17 | Auditoria: quais contratos do mesmo veículo têm períodos sobrepostos? (deve retornar vazio)
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
