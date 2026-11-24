# Diagrama de Entidade-Relacionamentos

### Descrição do Modelo Conceitual

O Diagrama Entidade-Relacionamento (DER) representa a estrutura conceitual do banco de dados do Sistema de Gestão de Estacionamento, contemplando as entidades, seus atributos, relacionamentos e respectivas cardinalidades, de acordo com as regras de negócio estabelecidas.

O modelo é composto por 13 entidades, responsáveis pelo armazenamento das informações referentes a veículos, clientes, funcionários, estadias, tarifas, pagamentos, contratos, mensalidades, lojas conveniadas e ocorrências.

Durante a modelagem, foram utilizados elementos específicos da notação Entidade-Relacionamento:

- **Entidade fraca — Mensalidade:** representa uma entidade cuja identificação depende da entidade Contrato. Cada mensalidade é identificada pelo contrato ao qual pertence e por sua competência, composta por mês e ano. Essa estrutura permite identificar individualmente as cobranças mensais de cada contrato.

- **Atributo composto — Endereço:** associado à entidade Estacionamento, é subdividido em informações como logradouro, número, bairro, cidade, estado e CEP, permitindo uma representação mais detalhada da localização.

- **Atributo composto — Competência:** associado à entidade Mensalidade, é dividido nos atributos Mês e Ano, possibilitando a identificação do período de referência de cada cobrança.

- **Atributo multivalorado — Telefone:** associado à entidade Cliente, permite registrar mais de um número de telefone para um mesmo cliente, considerando que ele pode possuir diferentes meios de contato.

Os relacionamentos foram definidos com cardinalidades mínimas e máximas, indicando a quantidade de ocorrências permitidas entre as entidades. Também foram consideradas restrições temporais, como a impossibilidade de um veículo possuir duas estadias abertas simultaneamente e a proibição de contratos com períodos de vigência sobrepostos para o mesmo veículo.

Dessa forma, o modelo conceitual estabelece uma representação estruturada das informações e regras do sistema, servindo como base para o desenvolvimento posterior dos modelos lógico e físico do banco de dados.
