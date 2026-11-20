# Modelo Lógico de Dados (MLD)

### Descrição do Modelo Lógico

O Modelo Lógico de Dados (MLD) representa a tradução estruturada do modelo conceitual para o paradigma relacional do banco de dados do Sistema de Gestão de Estacionamento. Nesta etapa, as entidades, atributos e relacionamentos são mapeados em tabelas, colunas, chaves primárias (PK), chaves estrangeiras (FK) e tipos de dados primitivos (como `INTEGER`, `VARCHAR` e `DATE`).

O modelo é composto por 13 tabelas que organizam os registros operacionais e administrativos do sistema, abrangendo o controle de marcas, modelos, veículos, clientes, contratos, mensalidades, estacionamentos, estadias, lojas conveniadas, tarifas, ocorrências, funcionários e pagamentos.

Durante a conversão do modelo conceitual para o lógico, foram aplicadas regras de mapeamento relacional para tratar as especificidades da modelagem anterior:

- **Mapeamento de Chaves Primárias e Estrangeiras:** todas as tabelas possuem identificadores únicos definidos (como `CodEstadia`, `CodContrato`, `CodCliente` e a placa `PLACA` na tabela `VEICULO`), garantindo a integridade de entidade. Os relacionamentos entre as tabelas são mantidos por meio de chaves estrangeiras, assegurando a integridade referencial do banco de dados (como a ligação de `CodMarca` e `CodModelo` em `VEICULO`).

- **Tratamento da Entidade Fraca — Mensalidade:** a dependência existencial de `Mensalidade` em relação a `CONTRATO` é refletida na estrutura relacional, onde a tabela armazena os dados de cobrança (`DataVencimento`, `DataPagamento` e `Competencia`) vinculados diretamente ao respectivo contrato.

- **Achatamento de Atributos Compostos:** os atributos compostos do modelo conceitual foram consolidados para simplificar o armazenamento relacional. Na tabela `Estacionamento`, os dados de localização foram unificados no atributo `Endereco` (`VARCHAR`), enquanto na tabela `Mensalidade`, o período de referência foi consolidado no atributo `Competencia` (`VARCHAR`).

- **Simplificação de Atributo Multivalorado:** o atributo `Telefone` na tabela `CLIENTE` foi mapeado diretamente como uma coluna (`VARCHAR`), centralizando o registro de contato junto aos demais dados cadastrais do cliente.

As cardinalidades mínimas e máximas definidas no projeto conceitual foram preservadas nas ligações entre as tabelas (como `(1,1)`, `(0,1)` e `(0,n)`), orientando a obrigatoriedade do preenchimento das chaves estrangeiras e mantendo as restrições das regras de negócio do estacionamento.

Dessa forma, o modelo lógico estabelece a arquitetura relacional definitiva das tabelas e seus vínculos, servindo como guia direto para a criação dos scripts DDL e implementação do modelo físico no Sistema Gerenciador de Banco de Dados (SGBD).