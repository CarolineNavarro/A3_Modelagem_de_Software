# Decisões do Modelo Físico – Tipos de Dados, Restrições e Índices

## 1. Decisões de tipos de dados

A definição dos tipos de dados foi realizada considerando a natureza das informações armazenadas, a compatibilidade com o SQLite e a necessidade de manter a consistência dos registros.

- **INTEGER:** utilizado para atributos identificadores e campos numéricos inteiros, como códigos de entidades, capacidade máxima do estacionamento, mês e ano de referência das mensalidades. Nas chaves primárias, esse tipo permite a identificação individual dos registros.

- **TEXT:** adotado para informações textuais, como nomes, e-mails, telefones, placas de veículos, tipos de ocorrência e descrições. Também foi utilizado para armazenar datas e horários, seguindo o formato padronizado ISO (`AAAA-MM-DD` e `AAAA-MM-DD HH:MM:SS`), permitindo a comparação e ordenação cronológica dos valores.

- **NUMERIC:** utilizado para valores monetários, como tarifas por hora, valores de mensalidades e pagamentos. Essa escolha permite o armazenamento de valores numéricos, possibilitando operações matemáticas e cálculos financeiros.

A utilização desses tipos busca adequar o armazenamento às características de cada atributo, facilitando a execução das consultas e a manutenção da integridade das informações.

## 2. Decisões de restrições de integridade

Foram estabelecidas restrições de integridade para evitar registros incompletos, duplicidades e valores incompatíveis com as regras de negócio do sistema.

- **PRIMARY KEY:** definida nas tabelas para garantir a identificação única de cada registro, utilizando códigos numéricos ou a placa do veículo como identificador, conforme a entidade.

- **FOREIGN KEY:** utilizada para estabelecer os relacionamentos entre as entidades e garantir que os registros referenciados existam nas respectivas tabelas. Essa restrição foi aplicada, por exemplo, entre contratos e clientes, estadias e funcionários, pagamentos e estadias, além dos relacionamentos entre marcas e modelos.

- **NOT NULL:** aplicada aos atributos considerados obrigatórios, impedindo a inserção de registros sem informações essenciais, como nomes, datas de entrada, valores e identificadores de relacionamentos obrigatórios.

- **UNIQUE:** utilizada para impedir duplicidades em atributos ou combinações de atributos. Foi aplicada, por exemplo, aos e-mails dos clientes, nomes de lojas e marcas, início de vigência das tarifas e combinação de cliente e telefone. Também foi utilizada para garantir que uma mesma estadia não possua mais de um registro de pagamento.

- **CHECK:** aplicada para restringir valores que precisam obedecer a condições específicas. Entre as validações implementadas estão:
  - Capacidade máxima do estacionamento superior a zero;
  - Valores de tarifas e mensalidades maiores que zero;
  - Valores de pagamentos iguais ou superiores a zero;
  - Mês limitado ao intervalo de 1 a 12;
  - Ano limitado ao intervalo de 2000 a 9999;
  - Carroceria limitada às categorias previamente estabelecidas;
  - Data de saída posterior à data de entrada;
  - Data de término de contrato igual ou posterior à data de início;
  - Data de término de tarifa posterior à data de início;
  - Formas de pagamento limitadas a Dinheiro, Débito, Crédito e PIX.

- **DEFAULT:** utilizada no atributo `data_hora` da tabela `ocorrencia`, definindo automaticamente a data e o horário atuais quando nenhum valor for informado durante a inserção do registro.

Essas restrições foram definidas para reduzir a possibilidade de inconsistências e assegurar que os dados armazenados respeitem as condições estabelecidas para o funcionamento do sistema.

## 3. Decisões de índices

Foram criados índices adicionais em atributos frequentemente utilizados em consultas, filtros e operações de relacionamento, visando melhorar o desempenho das operações de leitura do banco de dados.

Foram definidos os seguintes índices:

- **idx_contrato_placa_periodo:** criado sobre os atributos `placa`, `data_inicio` e `data_fim` da tabela `contrato`. Tem como finalidade otimizar consultas que verificam os contratos associados a determinado veículo e seus respectivos períodos de vigência, contribuindo também para a análise de possíveis sobreposições contratuais.

- **idx_estadia_entrada:** criado sobre o atributo `data_hora_entrada` da tabela `estadia`. Busca melhorar o desempenho de consultas que filtram, agrupam ou ordenam estadias de acordo com a data e o horário de entrada.

- **idx_estadia_placa_saida:** criado sobre os atributos `placa` e `data_hora_saida` da tabela `estadia`. Tem como objetivo facilitar consultas relacionadas ao histórico de permanência dos veículos, especialmente aquelas que identificam estadias em aberto ou encerradas.

- **idx_tarifa_vigencia:** criado sobre os atributos `inicio_vigencia` e `fim_vigencia` da tabela `tarifa`. Busca otimizar a identificação da tarifa aplicável em determinada data, considerando seus respectivos períodos de vigência.

A criação desses índices considera principalmente os atributos utilizados nas consultas previstas para o sistema, buscando reduzir o custo de localização dos registros e melhorar a eficiência das operações de pesquisa.

## 4. Considerações finais

As decisões adotadas na implementação física procuram garantir a integridade referencial, a consistência dos dados e a eficiência das consultas do sistema de gestão de estacionamento. A combinação de tipos de dados adequados, restrições de integridade e índices específicos permite estabelecer uma estrutura compatível com as regras de negócio definidas nas etapas anteriores da modelagem.

Além disso, foram consideradas as particularidades do SQLite, especialmente no armazenamento de datas e valores numéricos, de modo a manter a compatibilidade entre a estrutura física e as operações necessárias ao funcionamento do sistema.
