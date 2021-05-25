# Relatório do projeto de SIRS

Segurança Informática em Redes e Sistemas 2020-2021, segundo semestre

## Autores

**Grupo 2**

![Samuel Barata][SamuelPhoto] ![Pedro Godinho][PedroPhoto] ![Fabio Sousa][FabioPhoto]

| Número | Nome              | Correio eletrónico                  |
| -------|-------------------|-------------------------------------|
| 94230  | Samuel Barata     | [samuel.barata@tecnico.ulisboa.pt](mailto:samuel.barata@tecnico.ulisboa.pt)   |
| 93608  | Pedro Godinho      | [pedro.f.godinho@tecnico.ulisboa.pt](mailto:pedro.f.godinho@tecnico.ulisboa.pt)     |
| 93577  | Fabio Sousa     | [fabio.sousa@tecnico.ulisboa.pt](mailto:fabio.sousa@tecnico.ulisboa.pt) |

## Introdução

Neste projeto tenciona-se simular uma infrastrutura crítica de informação constituída por um edifício central e duas subestações elétricas. Na rede do edifício central encontram-se dois serviços numa DMZ (um web server e um servidos DNS), bem como um serviço de bases de dados (data historian), uma rede corporate com 3 pcs (2 hosts e um admin) e uma rede SCADA. Adicionalmente, simula-se uma internet simples através de um único router, ao qual estão ligadas as duas subestações, o edifício central, um pc, e 2 servidores de dns, para os domínios root e .pt.

## Diagrama de rede

![Diagrama](projArch.svg)


## Justificação de opções

### Decisões de implementação da rede

#### ...

### Decisões de implementação dos serviços

#### ...

## Escolha do IDS

Consultamos alguns artigos, mas focamo-nos principalmente num que tinha comparações dos [melhores NIDS gratuitos](https://www.upguard.com/blog/top-free-network-based-intrusion-detection-systems-ids-for-the-enterprise) que continha uma lista de pros e contras de cada um deles. Escolhemos o Snort porque, para alem de termos falado dele na aula, também estava em primeiro lugar na lista deste website. Além disso, é também bastante facil de configurar.


## Conclusão

*(o que foi alcançado)*

*(pontos fortes, pontos a melhorar)*

*(sugestões para melhorar o projeto em edições futuras)*

[SamuelPhoto]: https://fenix.tecnico.ulisboa.pt/user/photo/ist194230
[PedroPhoto]:  https://fenix.tecnico.ulisboa.pt/user/photo/ist193608
[FabioPhoto]:  https://fenix.tecnico.ulisboa.pt/user/photo/ist193577
