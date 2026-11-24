# Decisões de Modelagem

## 1. Identificação das entidades
Foram adotados atributos identificadores para as entidades do sistema, com exceção de Veículo, identificado pela placa, e Mensalidade, cuja identificação depende do contrato e da competência.

**Justificativa:** garantir a identificação das ocorrências e manter a coerência entre os modelos conceitual, lógico e físico.

## 2. Entidade fraca Mensalidade
A entidade Mensalidade foi modelada como dependente de Contrato, sendo identificada pela combinação do contrato e da competência (mês e ano).

**Justificativa:** uma mensalidade pertence a um contrato específico, e não deve haver mais de uma cobrança da mesma competência para esse contrato.

## 3. Atributos compostos
O endereço do estacionamento foi representado como atributo composto. A competência da mensalidade foi dividida em mês e ano.

**Justificativa:** representar de maneira organizada as informações que possuem subdivisões relevantes.

## 4. Associação entre clientes e veículos
Um veículo pode existir sem cliente associado. Um cliente pode estar associado a vários veículos, enquanto cada veículo pode estar associado a, no máximo, um cliente no cadastro.

**Justificativa:** permitir o cadastro de veículos avulsos e a posterior associação a clientes mensalistas, conforme a RN02.

## 5. Estadias em aberto
Foi estabelecido que um veículo não pode possuir mais de uma estadia em aberto simultaneamente.

**Justificativa:** atender à RN05 e preservar a consistência dos registros de entrada e saída.

## 6. Vigência dos contratos
Um veículo pode possuir vários contratos ao longo do tempo, desde que seus períodos de vigência não se sobreponham.

**Justificativa:** atender à RN14, permitindo o histórico de contratos sem vigências simultâneas.

## 7. Classificação das estadias
A classificação como mensalista ou rotativa será determinada pela existência de contrato vigente na data e hora de entrada do veículo.

**Justificativa:** cumprir a RN07, evitando que a classificação dependa exclusivamente da associação atual do veículo a um cliente.

## 8. Aplicação das tarifas
Cada estadia rotativa utiliza a tarifa vigente na data e hora da entrada. O cálculo considera o arredondamento das frações de hora para a próxima hora inteira.

**Justificativa:** atender às RN08 e RN09 e permitir a reprodução dos valores históricos de cobrança.

## 9. Pagamentos
O relacionamento entre Estadia e Pagamento é opcional no modelo geral, pois estadias de mensalistas não geram pagamento por estadia. Toda estadia rotativa encerrada deve possuir um único pagamento.

**Justificativa:** atender à RN10 e diferenciar as condições de cobrança das estadias rotativas e mensalistas.

## 10. Capacidade do estacionamento
A disponibilidade será calculada pela diferença entre a capacidade máxima cadastrada e a quantidade de estadias sem registro de saída.

**Justificativa:** atender às RN03 e RN04, considerando que veículos rotativos e mensalistas compartilham a mesma capacidade.

## 11. Regras Omissas

### Decisão RN14 – Múltiplos contratos por veículo e controle de sobreposição

**Regra:** Um mesmo veículo não poderá possuir dois ou mais contratos com períodos de vigência sobrepostos.

**Decisão adotada:** Foi estabelecido que um veículo poderá possuir múltiplos contratos ao longo do tempo, desde que os respectivos períodos de vigência sejam distintos e não apresentem qualquer sobreposição. Dessa forma, é permitida a celebração de novos contratos após o encerramento dos anteriores, preservando o histórico contratual do veículo.

**Justificativa:** Essa decisão permite contemplar situações de renovação ou recontratação dos serviços de estacionamento, sem comprometer a integridade dos dados. Além disso, possibilita manter o histórico dos vínculos contratuais, garantindo que cada período de utilização mensalista esteja associado a um único contrato vigente, em conformidade com a RN14.

**Critério de interpretação das datas:** As datas de início e término da vigência são consideradas inclusivas. Portanto, caso um contrato termine em 31/03, um novo contrato para o mesmo veículo poderá iniciar em 01/04, mas não em 31/03, pois isso caracterizaria sobreposição de períodos.

---

### Decisão RN09 – Controle de vigência das tarifas

**Regra:** As tarifas de estacionamento podem sofrer alterações ao longo do tempo, sendo necessário identificar o valor aplicável em cada período.

**Decisão adotada:** Foi definido que cada tarifa possuirá um período de vigência, determinado pelas datas de início e término. Quando o campo `fim_vigencia` apresentar valor `NULL`, será considerado que a tarifa permanece ativa, sem data de encerramento previamente estabelecida.

**Justificativa:** Essa abordagem permite registrar o histórico de alterações tarifárias e identificar corretamente o valor aplicável a cada estadia, considerando a data em que ocorreu a entrada do veículo no estacionamento. A utilização de um término de vigência nulo também evita a necessidade de atualizações constantes enquanto a tarifa permanecer em vigor, mantendo a flexibilidade do sistema.

**Critério de interpretação das datas:** As datas de início e término da vigência são consideradas inclusivas. Assim, uma tarifa será considerada válida desde sua data de início até sua data de término, incluindo ambas. Quando `fim_vigencia` for `NULL`, entende-se que sua validade permanece indeterminada, até que seja estabelecido um encerramento.


