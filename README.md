# A3 — Modelagem de Software
## Sistema de Gestão de Estacionamento

Projeto desenvolvido para a disciplina de **Modelagem de Software**, referente à atividade A3 do segundo semestre de 2026.

O objetivo é projetar e implementar um banco de dados relacional utilizando **SQLite**, aplicando conceitos de modelagem conceitual, lógica e física.

---

## 📋 Sobre o Projeto

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

**Diagrama Conceitual:** [Adicionar link do diagrama](#)

### 2. Modelo Lógico

Apresenta a estrutura relacional do banco de dados, incluindo tabelas, atributos, chaves primárias e estrangeiras.

**Diagrama Lógico:** [Adicionar link do diagrama](#)

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
git clone <URL_DO_REPOSITORIO>
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

## 📖 Regras de Negócio e Decisões de Modelagem

O banco de dados foi projetado considerando as **15 regras de negócio (RN01 a RN15)** estabelecidas no enunciado da atividade.

As decisões tomadas durante a modelagem, especialmente nos pontos em que o enunciado permite diferentes interpretações, são documentadas no arquivo:

📄 `docs/decisoes.md`

Cada decisão deve conter sua descrição e justificativa, garantindo transparência e coerência entre os modelos conceitual, lógico e físico.

---

## 🔎 Consultas SQL

O projeto contempla **17 consultas SQL obrigatórias**, organizadas em quatro níveis:

- **Básico:** consultas simples para recuperação de informações.
- **Agregação:** cálculos estatísticos, contagens e totalizações.
- **Junções:** consultas envolvendo relacionamentos entre tabelas.
- **Avançado:** cálculos de tarifas, disponibilidade e auditoria de integridade.

As consultas estão disponíveis em `sql/03-consultas.sql`, acompanhadas de seus respectivos resultados esperados.

---

## 📄 Licença

**Licença a definir.**

O código-fonte, os scripts SQL e os dados fictícios utilizados neste projeto terão suas condições de utilização especificadas no arquivo `LICENSE` do repositório.

---

**Projeto acadêmico — Modelagem de Software | A3 — 2026/2**

