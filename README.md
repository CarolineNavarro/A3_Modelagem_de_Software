# A3 — Modelagem de Software
## Sistema de Gestão de Estacionamento

Projeto desenvolvido para a disciplina de **Modelagem de Software**, referente à atividade A3 do segundo semestre de 2026.

O objetivo é projetar e implementar um banco de dados relacional utilizando **SQLite**, aplicando conceitos de modelagem conceitual, lógica e física.

---

## Sobre o Projeto

O **Sistema de Gestão de Estacionamento** tem como finalidade organizar e gerenciar as informações relacionadas ao funcionamento de um estacionamento.

O banco de dados contempla:

- **Veículos:** cadastro de veículos, placas, marcas e modelos.
- **Clientes:** gerenciamento dos clientes associados aos veículos.
- **Estadias:** registro de entradas, saídas e períodos de permanência.
- **Mensalistas:** gerenciamento de contratos e mensalidades.
- **Pagamentos:** registro dos valores recebidos e formas de pagamento.
- **Tarifas:** controle do histórico de valores cobrados por hora.
- **Funcionários:** cadastro dos responsáveis pelos registros e pagamentos.
- **Lojas conveniadas:** cadastro de estabelecimentos vinculados às estadias.
- **Ocorrências:** registro de acontecimentos relacionados às estadias.
- **Capacidade:** acompanhamento da quantidade de vagas disponíveis.

O projeto contempla exclusivamente o desenvolvimento do banco de dados, sem implementação de interface gráfica.

---

## Integrantes

| Nome completo | RA |
|---|---|
| Caroline Navarro Santos | 823131382 |
| Daniel Henrique Resende | 82410349 |
| Gabriel da Costa Lopes Muniz | 823124043 |
| Paulo da Silva Bassiano | 824219946 |

---

## Ferramentas e Tecnologias

| Ferramenta | Finalidade |
|---|---|
| SQLite | Sistema de gerenciamento de banco de dados relacional |
| DB Browser for SQLite | Criação, execução e gerenciamento do banco de dados |
| GitHub | Versionamento, documentação e armazenamento do projeto |
| brModelo | Elaboração dos diagramas conceitual e lógico |

---

## Estrutura do Repositório

O projeto está organizado da seguinte maneira:

```text
A3_Modelagem_de_Software/
│
├── README.md
│
├── docs/
│   ├── 01-conceitual/
│   ├── 02-logico/
│   ├── 03-fisico/
│   └── decisoes.md
│
└── sql/
    ├── 00-base-fornecida.sql
    ├── 01-schema.sql
    ├── 02-dados.sql
    └── 03-consultas.sql
```

### Descrição dos arquivos

- `00-base-fornecida.sql`: criação e inserção dos dados das tabelas de marcas e modelos fornecidas pelo professor.
- `01-schema.sql`: criação das tabelas e definição das restrições do banco de dados.
- `02-dados.sql`: inserção dos dados fictícios utilizados para os testes.
- `03-consultas.sql`: conjunto de 17 consultas SQL para validação das funcionalidades e regras de negócio.
- `docs/decisoes.md`: registro das decisões de modelagem e suas respectivas justificativas.

---

## Modelagem do Banco de Dados

O desenvolvimento está dividido em três etapas de modelagem.

### 1. Modelo Conceitual

Representa as entidades, seus atributos, relacionamentos e cardinalidades, descrevendo as regras de negócio independentemente da implementação.

**Diagrama Conceitual:** [DER_ESTACIONAMENTO.jpg](./docs/01-conceitual/DER_ESTACIONAMENTO.jpg)

### 2. Modelo Lógico

Apresenta a estrutura relacional do banco de dados, incluindo tabelas, atributos, chaves primárias e estrangeiras.

**Diagrama Lógico:** [LOGICO_ESTACIONAMENTO.png](./docs/02-logico/LOGICO_ESTACIONAMENTO.png)

### 3. Modelo Físico

Implementa a estrutura definida no modelo lógico utilizando SQLite, com tipos de dados, restrições de integridade e índices.

**Modelo Físico:** [Adicionar link do modelo](#)

---

## Instruções de Utilização

Para reproduzir o banco de dados, siga as instruções abaixo.

### Pré-requisitos

É necessário ter instalado:

- **DB Browser for SQLite:** https://sqlitebrowser.org/

### Passo 1 — Obter os arquivos

Clone o repositório utilizando o Git:

```bash
git clone https://github.com/CarolineNavarro/A3_Modelagem_de_Software
```

Ou utilize a opção **Code → Download ZIP** na página do GitHub.

### Passo 2 — Criar o banco de dados

1. Abra o **DB Browser for SQLite**.
2. Clique em **Novo Banco de Dados**.
3. Escolha o nome `estacionamento.db`.
4. Salve o arquivo no diretório desejado.
5. Caso seja exibida uma janela para criar uma tabela, cancele-a.

### Passo 3 — Executar os scripts SQL

Na aba **Executar SQL**, abra e execute os scripts na seguinte ordem:

| Ordem | Arquivo | Finalidade |
|---|---|---|
| 1 | `00-base-fornecida.sql` | Criação das tabelas de marcas e modelos |
| 2 | `01-schema.sql` | Criação da estrutura do banco |
| 3 | `02-dados.sql` | Inserção dos dados de teste |
| 4 | `03-consultas.sql` | Execução das consultas obrigatórias |

**Importante:** mantenha a integridade referencial habilitada por meio do comando:

```sql
PRAGMA foreign_keys = ON;
```

Após executar os scripts de criação e inserção, clique em **Gravar Alterações** para salvar os dados.

### Passo 4 — Consultar os dados

Após a criação do banco:

1. Acesse a aba **Navegar Dados** para visualizar os registros.
2. Utilize a aba **Executar SQL** para realizar consultas.
3. Execute as 17 consultas disponíveis em `03-consultas.sql` para verificar o funcionamento do modelo.

---

## Regras de Negócio e Decisões de Modelagem

O banco de dados foi projetado considerando as **15 regras de negócio (RN01 a RN15)** estabelecidas no enunciado da atividade.

As decisões tomadas durante a modelagem, especialmente nos pontos em que o enunciado permite diferentes interpretações, são documentadas no arquivo:

`docs/decisoes.md`

Cada decisão deve conter sua descrição e justificativa, garantindo transparência e coerência entre os modelos conceitual, lógico e físico.

---

## Consultas SQL

O projeto contempla **17 consultas SQL obrigatórias**, organizadas em quatro níveis:

- **Básico:** consultas simples para recuperação de informações.
- **Agregação:** cálculos estatísticos, contagens e totalizações.
- **Junções:** consultas envolvendo relacionamentos entre tabelas.
- **Avançado:** cálculos de tarifas, disponibilidade e auditoria de integridade.

As consultas estão disponíveis em `sql/03-consultas.sql`, acompanhadas de seus respectivos resultados esperados.

### 01 | Quais veículos estão no estacionamento agora (entrada sem saída)? Mostre placa e horário de entrada, do mais antigo ao mais recente.

| placa | data_hora_entrada | 
|---|---|
| KIA1H13 | 2026-11-27 08:00:00 |
| AFF4B12 | 2026-11-27 09:00:00 |
| TST6A12 | 2026-11-27 10:00:00 |

### 02 | Quais veículos cadastrados não têm cliente associado?

| placa | cod_modelo | 
|---|---|
| AFF4B12 | 7 |
| KIA1H13 | 54 |
| TST6A12 | 21 |

### 03 | Quais mensalidades ainda não foram pagas? Mostre contrato, competência e vencimento.

| cod_contrato | competencia | data_vencimento |
|---|---|---|
|1 | 03/2024 | 2024-03-10|
|2 | 02/2025 | 2025-02-10|
|3 | 02/2026 | 2026-02-10|

### 04 | Qual era a tarifa por hora vigente em 05/03/2024?
| cod_tarifa | valor_hora | inicio_vigencia | fim_vigencia |
|---|---|---|---|
| 1 | 10 | 2024-01-01 | 2025-01-01 |

### 05 | Quantas estadias começaram em cada dia?
| dia | quantidade_estadias |
|---|---|
| 2024-01-15 | 1 |
| 2024-03-05 | 4 |
| 2024-03-06 | 1 |
| 2024-04-12 | 1 |
| 2024-06-21 | 1 |
| 2024-10-03 | 1 |
| 2025-01-18 | 1 |
| 2025-02-08 | 1 |
| 2025-02-20 | 1 |
| 2025-04-07 | 1 |
| 2025-07-29 | 1 |
| 2025-08-17 | 1 |
| 2025-11-12 | 1 |
| 2025-12-14 | 1 |
| 2026-02-09 | 1 |
| 2026-03-05 | 1 |
| 2026-03-06 | 1 |
| 2026-05-11 | 1 |
| 2026-06-22 | 1 |
| 2026-07-19 | 1 |
| 2026-08-03 | 1 |
| 2026-09-15 | 1 |
| 2026-10-19 | 1 |
| 2026-11-20 | 1 |
| 2026-11-27 | 3 |
                                          
### 06 | Quanto foi recebido em cada forma de pagamento?

| forma_pagamento | total_recebido |
|---|---|
| Crédito | 179.0 | 
| Dinheiro | 207.0 | 
| Débito | 102.0 | 
| PIX | 197.0 | 

### 07 | Quantas ocorrências houve de cada tipo?

| tipo | quantidade_ocorrencias |
|---|---|
| Atendimento | 2 |
| Manutencao | 1 |
| Seguranca | 2 |

### 08 | Qual a permanência média, em minutos, das estadias encerradas?

| permanencia_media_minutos |
|---|
| 195.04 |

### 09 | Para cada estadia, mostrar a placa, a marca e o modelo do veículo.

| cod_estadia | placa | marca | modelo | 
|---|---|---|---|
| 1 | TXT1D05 | Volkswagen | Gol | 
| 2 | TXT1D05 | Volkswagen | Gol | 
| 3 | TFT5H02 | Volkswagen | Polo | 
| 4 | TFT5H02 | Volkswagen | Polo | 
| 5 | TSF8R07 | Volkswagen | Virtus | 
| 6 | TSF8R07 | Volkswagen | Virtus | 
| 7 | AST9K04 | Fiat | Argo | 
| 8 | FST9Y08 | Fiat | Cronos | 
| 9 | TST2K06 | Chevrolet | Onix | 
| 10 | TGJ3H09 | Chevrolet | Tracker | 
| 11 | BOY1G08 | Toyota | Corolla | 
| 12 | TKL1H08 | Toyota | Corolla Cross | 
| 13 | TSA7L13 | Hyundai | HB20 | 
| 14 | TAH6K12 | Hyundai | Creta | 
| 15 | VEY3J11 | Jeep | Renegade | 
| 16 | KIA1H13 | Jeep | Compass | 
| 17 | AFF4B12 | Fiat | Uno | 
| 18 | TST6A12 | Chevrolet | S10 | 
| 19 | AST9K04 | Fiat | Argo | 
| 20 | FST9Y08 | Fiat | Cronos | 
| 21 | TST2K06 | Chevrolet | Onix | 
| 22 | TGJ3H09 | Chevrolet | Tracker | 
| 23 | BOY1G08 | Toyota | Corolla | 
| 24 | TKL1H08 | Toyota | Corolla Cross | 
| 25 | TSA7L13 | Hyundai | HB20 | 
| 26 | TAH6K12 | Hyundai | Creta | 
| 27 | VEY3J11 | Jeep | Renegade | 
| 28 | KIA1H13 | Jeep | Compass | 
| 29 | AFF4B12 | Fiat | Uno | 
| 30 | TST6A12 | Chevrolet | S10 | 


### 10 | Listar os contratos com o nome do cliente, a placa e o modelo do veículo.

| cod_contrato | cliente | placa | modelo | data_inicio | data_fim | valor_mensal |
|---|---|---|---|---|---|---|
| 1 | Ana Ribeiro | TXT1D05 | Gol | 2024-01-01 | 2024-06-30 | 240 |
| 2 | Bruno Almeida | TFT5H02 | Polo | 2025-01-01 | 2025-12-31 | 270 |
| 3 | Clara Monteiro | TSF8R07 | Virtus | 2026-01-01 | 2026-12-31 | 320 |

### 11 | Quantas estadias cada loja conveniada vinculou, incluindo as lojas sem nenhuma?

| cod_loja | loja | quantidade_estadias |
|---|---|---| 
| 1 | Papelaria Horizonte | 5 |
| 2 | Cafeteria Central | 5 |
| 3 | Livraria Aurora | 0 |

### 12 | Listar as ocorrências com data e hora, tipo, placa do veículo e nome do funcionário que registrou.

| cod_ocorrencia | data_hora | tipo | placa | funcionario |
|---|---|---|---|---|
| 1 | 2024-03-05 08:45:00 | Atendimento | AST9K04 | Davi Nogueira | 
| 2 | 2024-03-05 11:30:00 | Seguranca | TST2K06 | Caio Martins | 
| 3 | 2025-02-20 12:00:00 | Atendimento | VEY3J11 | Bruna Farias | 
| 4 | 2026-03-05 10:00:00 | Manutencao | TST2K06 | Davi Nogueira | 
| 5 | 2026-11-20 09:00:00 | Seguranca | VEY3J11 | Caio Martins | 

### 13 | Quantas vagas estão livres agora?

| cod_estacionamento| capacidade_maxima | vagas_ocupadas | vagas_livres |
|---|---|---|---|
| 1 | 80 | 3 | 77 |

### 14 | Qual o valor devido em cada estadia rotativa encerrada, pela tarifa vigente na data da entrada, com fração contando como hora cheia?

| cod_estadia | placa | data_hora_entrada | data_hora_saida | cod_tarifa | valor_hora | horas_cobradas | valor_devido |
|---|---|---|---|---|---|---|---|
| 7 | AST9K04 | 2024-03-05 08:00:00 | 2024-03-05 10:30:00 | 1 | 10 | 3 | 30.0 | 
| 8 | FST9Y08 | 2024-03-05 09:15:00 | 2024-03-05 10:00:00 | 1 | 10 | 1 | 10.0 | 
| 9 | TST2K06 | 2024-03-05 10:00:00 | 2024-03-05 12:10:00 | 1 | 10 | 3 | 30.0 | 
| 10 | TGJ3H09 | 2024-03-06 11:00:00 | 2024-03-06 12:40:00 | 1 | 10 | 2 | 20.0 | 
| 11 | BOY1G08 | 2024-04-12 14:00:00 | 2024-04-12 17:00:00 | 1 | 10 | 3 | 30.0 | 
| 12 | TKL1H08 | 2024-06-21 09:40:00 | 2024-06-21 11:10:00 | 1 | 10 | 2 | 20.0 | 
| 13 | TSA7L13 | 2024-10-03 15:00:00 | 2024-10-03 16:25:00 | 1 | 10 | 2	| 20.0 | 
| 14 | TAH6K12 | 2025-01-18 08:30:00 | 2025-01-18 11:00:00 | 2 | 12 | 3 | 36.0 | 
| 15 | VEY3J11 | 2025-02-20 10:00:00 | 2025-02-20 13:15:00 | 2 | 12 | 4 | 48.0 | 
| 16 | KIA1H13 | 2025-04-07 09:00:00 | 2025-04-07 09:30:00 | 2 | 12 | 1 | 12.0 | 
| 17 | AFF4B12 | 2025-07-29 17:00:00 | 2025-07-29 19:00:00 | 2 | 12 | 2 | 24.0 | 
| 18 | TST6A12 | 2025-08-17 11:10:00 | 2025-08-17 14:00:00 | 2 | 12 | 3 | 36.0 | 
| 19 | AST9K04 | 2025-12-14 08:05:00 | 2025-12-14 10:00:00 | 2 | 12 | 2 | 24.0 | 
| 20 | FST9Y08 | 2026-02-09 13:00:00 | 2026-02-09 14:01:00 | 3 | 15 | 2 | 30.0 | 
| 21 | TST2K06 | 2026-03-05 09:00:00 | 2026-03-05 12:30:00 | 3 | 15 | 4 | 60.0 | 
| 22 | TGJ3H09 | 2026-05-11 10:00:00 | 2026-05-11 12:00:00 | 3 | 15 | 2 | 30.0 | 
| 23 | BOY1G08 | 2026-06-22 11:00:00 | 2026-06-22 13:45:00 | 3 | 15 | 3 | 45.0 |
| 24 | TKL1H08 | 2026-07-19 07:00:00 | 2026-07-19 08:10:00 | 3 | 15 | 2 | 30.0 | 
| 25 | TSA7L13 | 2026-08-03 12:00:00 | 2026-08-03 15:00:00 | 3 | 15 | 3 | 45.0 | 
| 26 | TAH6K12 | 2026-09-15 14:00:00 | 2026-09-15 18:30:00 | 3 | 15 | 5 | 75.0 | 
| 27 | VEY3J11 | 2026-11-20 08:00:00 | 2026-11-20 09:50:00 | 3 | 15 | 2 | 30.0 | 

### 15 | Classificar cada estadia como rotativa ou de mensalista (veículo com contrato vigente na data da entrada).

| cod_estadia | placa | data_hora_entrada | tipo_estadia |
|---|---|---|---|
| 1 | TXT1D05 | 2024-01-15 08:00:00 | Mensalista | 
| 2 | TXT1D05 | 2024-03-05 07:30:00 | Mensalista | 
| 3 | TFT5H02 | 2025-02-08 09:00:00 | Mensalista | 
| 4 | TFT5H02 | 2025-11-12 10:00:00 | Mensalista | 
| 5 | TSF8R07 | 2026-03-06 08:00:00 | Mensalista | 
| 6 | TSF8R07 | 2026-10-19 13:00:00 | Mensalista | 
| 7 | AST9K04 | 2024-03-05 08:00:00 | Rotativa | 
| 8 | FST9Y08 | 2024-03-05 09:15:00 | Rotativa | 
| 9 | TST2K06 | 2024-03-05 10:00:00 | Rotativa | 
| 10 | TGJ3H09 | 2024-03-06 11:00:00 | Rotativa | 
| 11 | BOY1G08 | 2024-04-12 14:00:00 | Rotativa | 
| 12 | TKL1H08 | 2024-06-21 09:40:00 | Rotativa | 
| 13 | TSA7L13 | 2024-10-03 15:00:00 | Rotativa | 
| 14 | TAH6K12 | 2025-01-18 08:30:00 | Rotativa |
| 15 | VEY3J11 | 2025-02-20 10:00:00 | Rotativa | 
| 16 | KIA1H13 | 2025-04-07 09:00:00 | Rotativa | 
| 17 | AFF4B12 | 2025-07-29 17:00:00 | Rotativa | 
| 18 | TST6A12 | 2025-08-17 11:10:00 | Rotativa | 
| 19 | AST9K04 | 2025-12-14 08:05:00 | Rotativa | 
| 20 | FST9Y08 | 2026-02-09 13:00:00 | Rotativa | 
| 21 | TST2K06 | 2026-03-05 09:00:00 | Rotativa | 
| 22 | TGJ3H09 | 2026-05-11 10:00:00 | Rotativa | 
| 23 | BOY1G08 | 2026-06-22 11:00:00 | Rotativa | 
| 24 | TKL1H08 | 2026-07-19 07:00:00 | Rotativa | 
| 25 | TSA7L13 | 2026-08-03 12:00:00 | Rotativa | 
| 26 | TAH6K12 | 2026-09-15 14:00:00 | Rotativa | 
| 27 | VEY3J11 | 2026-11-20 08:00:00 | Rotativa | 
| 28 | KIA1H13 | 2026-11-27 08:00:00 | Rotativa | 
| 29 | AFF4B12 | 2026-11-27 09:00:00 | Rotativa | 
| 30 | TST6A12 | 2026-11-27 10:00:00 | Rotativa | 

### 16 | Auditoria: quais placas têm mais de uma estadia em aberto? (deve retornar vazio)

| placa | estadias_abertas |
|---|---|
|  |  |

### 17 | Auditoria: quais contratos do mesmo veículo têm períodos sobrepostos? (deve retornar vazio)

| placa | contrato_1 | inicio_1 | fim_1 | contrato_2 | inicio_2 | fim_2 |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  | 

---

## Licença

Copyright (c) 2026 Prof. Marcelo Amorim e colaboradores

É concedida permissão, gratuitamente, a qualquer pessoa que obtenha uma cópia deste software e dos arquivos de documentação associados (o "Software"), para lidar com o Software sem restrições, incluindo, sem limitação, os direitos de usar, copiar, modificar, mesclar, publicar, distribuir, sublicenciar e/ou vender cópias do Software, e permitir que as pessoas a quem o Software é fornecido o façam, sujeito às seguintes condições:

O aviso de copyright acima e este aviso de permissão devem ser incluídos em todas as cópias ou partes substanciais do Software.

O SOFTWARE É FORNECIDO "COMO ESTÁ", SEM GARANTIA DE QUALQUER TIPO, EXPRESSA OU IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO ÀS GARANTIAS DE COMERCIALIZAÇÃO, ADEQUAÇÃO A UM DETERMINAÇÃO ESPECÍFICO E NÃO INFRAÇÃO. EM NENHUM CASO OS AUTORES OU DETENTORES DE COPYRIGHT SERÃO RESPONSÁVEIS POR QUALQUER REIVINDICAÇÃO, DANOS OU OUTRA RESPONSABILIDADE, SEJA EM AÇÃO DE CONTRATO, ILÍCITO OU DE OUTRA FORMA, DECORRENTE DE, FORA DE OU EM CONEXÃO COM O SOFTWARE OU O USO OU OUTRAS NEGOCIAÇÕES NO SOFTWARE.

---

**Projeto acadêmico — Modelagem de Software | A3 — 2026/2**

