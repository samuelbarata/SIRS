Instituto Superior Técnico, Universidade de Lisboa

**Segurança Informática em Redes e Sistemas**

# Objetivos gerais

O objetivo do projeto consiste em configurar a [infraestrutura crítica de informação (ICI)][Wikipedia1] usada para controlar a [rede elétrica][Wikipedia2] de uma região ou país, e proteger este rede de ciberataques.
Esta rede inclui diversos computadores, dispositivos de rede e serviços de WWW, DNS e DHCP.
O sistema será emulado usando o *Kathará*.
Em concreto, é necessário projetar a infraestrutura usando protocolos seguros, restringir o acessos a recursos e usar um detetor de intrusões para monitorizar possíveis ataques.

# Introdução

Uma infraestrutura crítica de informação é uma rede de computadores usada para controlar uma assim chamada [infraestrutura crítica][Wikipedia1].
Alguns exemplos típicos de infraestruturas críticas são *utilities* como as redes de geração, transporte e distribuição de eletricidade, água ou gás.
Estas infraestruturas, também designadas mais genericamente por sistemas ciber-físicos, têm uma componente informática e outra de controle de processos físicos: ativação de geradores de eletricidade, corte de ligações, abrir/fechar bombas de água, etc.
Estes processos são controlados por dispositivos eletrónicos chamados PLC (*Programmable Logic Controllers*), que são comandados usando sistemas SCADA (*Supervisory Control and Data Acquisition*).
A comunicação é feita usando protocolos da camada aplicação sobre TCP/IP.

Uma ICI é composta por diversas subredes, geralmente distribuídas por diferentes localizações.
No projeto vamos considerar apenas:

+ um edifício central;
+ duas subestações elétricas.

Nessas três instalações estão colocadas as seguintes subredes:

+ LAN *corporate*, onde estão as estações de trabalho dos funcionários da empresa que gere a ICI.
Esta LAN está no edifício central.
+ LAN de serviços, onde estão os servidores de WWW e DNS, também no edifício central.
+ LAN SCADA, onde estão as estações de trabalho dos sistemas SCADA, no edifício central.
+ Subrede do *data historian*, sendo o *data historian* uma base de dados onde são armazenadas informações sobre problemas ocorridos na rede elétrica.
Esta subrede está também no edifício central.
+ LANs de controle que interligam os PLCs.
Estas duas LANs encontram-se nas duas subestações.

O edifício central está ligado à Internet.
As subestações estão ligadas à rede SCADA do edifício central através de uma rede privada virtual (VPN), contratada a um fornecedor de serviço de Internet (ISP).
Esta rede isola o tráfego de controlo da Internet, o que é muito importante sob o ponto de vista da segurança.
O projeto envolve uma emulação simples da ligação do sistema à Internet, bem como a configuração dos diversos subsistemas mencionados.

# Descrição geral da rede

## Internet

A Internet tem uma arquitetura complexa que, obviamente, está fora do âmbito deste trabalho configurar.
Essa rede vai ser emulada de forma simples por um único *router* (ao qual está ligado o edifício central) e um PC (para testar a comunicação com a ICI).
Não é preciso considerar o problema do *routing* interdomínio (BGP): basta que o *router* tenha uma rota definida para o edifício central da ICI, de modo a que todos os nós do sistema possam comunicar.
A infraestrutura de DNS da Internet deve ser emulada de forma simplificada usando dois servidores [bind][Bind].
Estes servidores devem estar ligados ao *router* do ISP.
Um dos servidores é do domínio de raiz (*root*) e o outro do domínio `pt`, que é o domínio do país onde se situa a ICI.
O PC e os dois servidores devem usar endereços IP do bloco `88.60.0.0/22`.
Não é importante a forma como o bloco é dividido.
O *router* tem de estar ligado à empresa usando um endereço da gama *link-local* (ver [RFC 3927](https://tools.ietf.org/html/rfc3927)).

## Edifício central

Como já referido o edifício central tem 4 LANs: *corporate*, serviços, SCADA e *data historian*.
Cada uma destas LANs tem um *switch* que está ligado ao *router* do edifício central.
Este router está ligado ao *router* que emula a Internet.
Entre o *router* do edifício e o *router* que emula a Internet poderia existir outro equipamento de nível 1 ou 2, mas vamos abstrairmo-nos desses detalhes considerando que existe uma ligação direta entre ambos.
Não é preciso correr protocolos de *routing*.

O ISP fornece à ICI o bloco `95.92.192.0/20`, que é dividido pelas suas subredes e máquinas.
Todas as máquinas usam IPs públicos.
Na LAN *corporate* estão as estações de trabalho dos funcionários da empresa.
Deve configurar 2 PCs de outros tantos engenheiros da ICI.
Cada PC deve correr Linux.
Os PCs devem ter instalado e configurado um programa para acesso à *web*.
Devem obter o seu IP dinamicamente através do serviço de DHCP.

Um dos engenheiros é também o administrador da rede informática, e a sua máquina deverá monitorizar o estado da rede com [MRTG][MRTG].

Na LAN de serviços devem ser instalados os servidores de WWW e DNS, todos com IPs fixos (ou seja, não fornecidos por DHCP):

+ DNS: devem ser configurados um servidor de DNS para a ICI (domínio `acdc.pt`), usando o serviço [Bind][Bind].
O DNS deve ser configurado de modo a que os servidores da ICI possam ser acedidos fornecendo o seu nome, p.ex., ao servidor de *web* com `http://www.acdc.pt`.
+ WWW: contendo uma página *web* de apresentação da ICI e um *site* pessoal para cada um dos 2 engenheiros.
Deve ser usado o servidor [Apache][Apache].
O servidor de *web* deve ser designado por `www.acdc.pt`.

A LAN SCADA deve conter apenas uma estação de trabalho, ou seja, um PC a correr Linux.
Não é preciso instalar nada em concreto nesse PC (não vai ser usado *software* SCADA).
Este PC deve ter um endereço IP dinâmico, fornecido por DHCP.
Nesta LAN existe ainda um *router* que dá acesso às subestações através de uma VPN (mais detalhes na próxima secção).
As máquinas da LAN devem estar configuradas para enviar todo o tráfego para o *router* do edifício exceto o tráfego destinado às subestações, que deve ser entregue ao outro *router*.
A subrede do *data historian* tem um servidor com a base de dados onde são armazenadas informações sobre problemas ocorridos na rede elétrica.
Tal como na LAN SCADA, não é obrigatório instalar nada nesse servidor, mas poderá fazê-lo.
Deve ter um endereço IP fixo e um nome registado no DNS: `historian.acdc.pt`.

## Subestações

Sob o ponto de vista informático cada subestação contém uma LAN de controlo e um *router*.
Este *router* está ligado à VPN que o liga ao *router* da LAN SCADA do edifício central.
A VPN tem dois troços: *router* da subestação 1 – *router* da LAN SCADA e router da subestação 2 – *router* da LAN SCADA.
Não existe qualquer ligação direta à Internet (só uma ligação indireta: LAN de controle > VPN > *router* da LAN SCADA > *router* do edifício central > Internet).
Isto é importante sob o ponto de vista da segurança e deverá ser tido em conta quando implementar a VPN.

Nota: poderá facilitar primeiro emular a VPN com um *link* normal entre os dois *routers* e só depois configurar o servidor OpenVPN.

A LAN de controle de cada subestação contém um *switch* ao qual está ligado apenas um PC com Linux (uma estação SCADA local).
O objetivo seria serem aí ligados os PLCs mas não os vamos emular explicitamente.
O PC obtém o endereço IP dinamicamente usando um servidor de DHCP local à LAN de controlo (colocado, p.ex., no próprio *router*).

# Descrição dos serviços da rede

Nesta parte do projeto, deverá configurar alguns serviços na rede.
Deverá prioritizar a construção da rede antes de avançar para a configuração dos serviços.

## SSH

A ICI tem um administrador de rede que tem de poder trabalhar remotamente nos servidores da LAN de serviços (os servidores **web** e DNS da ICI).
Este acesso tem de poder ser feito a partir dos PCs dos engenheiros e do PC da Internet.
Este administrador tem de ter uma conta (utilizador) “admin” em cada um desses servidores que usa para fazer o acesso.
Para aceder remotamente aos computadores da ICI têm de ser usados protocolos seguros.
Para permitir esse acesso, vamos configurar os protocolos SSH fornecidos pelo pacote [OpenSSH][ssh].
A autenticação tem de ser baseada em criptografia de chave pública, não em *password*.
Configure o SSH de modo a que seja possível aceder remotamente dos PCs dos engenheiros ao servidor de *web*.
Teste o funcionamento desses protocolos usando os comandos `ssh` e `scp`.

## VPNs

As subestações estão ligadas à rede SCADA do edifício central através de uma rede privada virtual (VPN) que isola o tráfego de controlo da Internet.
Realize essa configuração usando o software [OpenVPN][OpenVPN].
Considere que os *routers* das subestações são clientes OpenVPN e que o SCADA *router* é o servidor OpenVPN.
Confirme que os pacotes são enviados pela VPN.

## *Firewalls*

O administrador de rede resolveu limitar os riscos de ataque à ICI através da limitação:

+ dos acessos à rede da ICI a partir do exterior ao mínimo necessário;
+ dos acessos da LAN de serviços - que constitui a DMZ da rede - ao resto da ICI também ao mínimo necessário;
+ dos acessos à rede das duas subestações apenas às máquinas da LAN SCADA.

Para o efeito é necessário configurar o *router* do edifício central e o *router* da LAN SCADA de modo a efetuarem essas duas limitações através da filtragem de pacotes.
Para isso é necessário usar o software de `netfilter`/`iptables`.
Em concreto estas duas *firewalls* devem garantir o seguinte:

+ máquinas de fora da rede da ICI só podem comunicar com os servidores da DMZ (ou seja, da LAN de serviços) e só para aceder aos serviços fornecidos por esses servidores (WWW e DNS);
+ as máquinas da DMZ não podem comunicar com o resto da rede da ICI;
+ só as máquinas da LAN SCADA podem comunicar com as máquinas das subestações e estas só podem comunicar com as máquinas da LAN SCADA;
+ todas as máquinas da rede ICI excepto o *data historian* podem aceder ao DNS;
+ deve ser possível fazer *ping* entre todas as máquinas da rede ICI e das estações dos engenheiros para a Internet;
+ deve ser possível fazer *ping* aos ips externos que resolvam os serviços fornecidos (WWW e DNS);
+ todo o restante tráfego deve ser bloqueado.

No relatório deve ser apresentada a lista de regras `iptables` com comentários que as justifiquem.
Devem ser incluidos testes para as regras criadas.

## HTTPS

O servidor *web* deverá ser configurado para poder servir HTTPS com certificados auto-assinados (*self-signed certificates*) para `www.acdc.pt`.
Os certificados deverão ser conhecidos em pelo menos um PC de exemplo, que não seja o servidor *web*, e feito um teste com um pedido `curl` a partir desse PC.

## Deteção de intrusões

Deverão ser instalados sistemas de deteção de intrusões (IDS) e configurado de modo a detetar ataques e intrusões em dois pontos da rede:

+ Um IDS para monitorizar a DMZ, colocado entre o *router* do edifício central e o *switch* da LAN de serviços.
Este detetor deve correr num PC que atue como um *switch* de rede.

+ Um IDS para monitorizar a subrede *corporate*, colocado entre o *router* do edifício central e o *hub* dessa rede.
A configuração deve ser semelhante à do primeiro IDS.

O funcionamento do IDS deve ser testado.
Não é necessário criar ataques reais, mas apenas criar tráfego que seja assinalado pelo IDS como malicioso.

O detetor de intrusões a usar deverá ser escolhido pelo grupo.
As alternativas consideradas deverão ser apresentadas no relatório e a escolha deve ser justificada.


## Componentes opcionais (escolher um)

### Servidor DHCP

Como foi referido, algumas das máquinas devem receber o seu endereço IP dinamicamente a partir de um servidor DHCP.
Esse servidor deve ser colocado onde for considerado conveniente e justificado no relatório.
Deve ser usado o [dhcp3-server][Dhcp2] e o cliente respetivo [dhcp3-client][Dhcp2].

### Monitorização da rede - MRTG

No PC do administrador da rede informática é necessário instalar o [MRTG][MRTG] para monitorizar o estado da rede.
Este PC, configurado no modo *bridge* (colocar `nomedopc[bridged]=true` no `lab.conf`) deverá permitir que os gráficos da interface *web* sejam acessíveis fora do *Kathará*.
Deverá ser possível observar:

+ o tráfego recebido e enviado por todas as interfaces de todos os routers da ICI (`ifInOctets` e `ifOutOctets` da tabela `ifTable` do grupo de interfaces da `Mib-II`);
+ o tráfego recebido e enviado pelo servidor de *web*;
+ o número de segmentos TCP recebidos e enviados pelo mesmo servidor.

Os gráficos devem ter títulos e legendas que correspondam à informação apresentada, de modo a que o administrador de sistemas consiga perceber facilmente o que está a ver.
Os dispositivos monitorizados devem correr o agente `snmpd`.

### DNSSEC

Deverá implementar DNSSEC de modo a que todos os nomes existentes nos *routers* estejam autenticados.
Não é necessário ter nenhuma infraestrutura que assine os nomes automaticamente.

# Entrega do projeto

A entrega do projeto tem duas fases:

1. Os grupos devem apresentar um diagrama detalhado da rede (topologia, endereços IP/MAC, subredes, localização dos serviços) – numa aula de laboratório ou numa sessão de dúvidas até **quinta-feira, 13 de Maio de 2021, 17:00**.
Após esta data já não será garantido *feedback* ao diagrama de rede antes da entrega final do relatório.

2. Entrega final – até **quarta-feira, 26 de Maio de 2021, às 17:00**.
A entrega é feita através do sistema Fénix de um ficheiro `.zip`, que inclua, pelo menos, os seguintes ficheiros:

+ `Relatorio.md` ou `Relatorio.pdf` - relatório seguindo a [estrutura indicada](Relatorio.md);
  + `Requisitos.md` - [lista de verificação](Requisitos.md) devidamente preenchida;
+ `proj/` - uma pasta dentro da qual está o laboratório de *Kathará* do projeto e com o ficheiro `lab.conf` em `proj/lab.conf`;
+ `proj/tests` - testes incluidos no seu projeto, em conjunto com informação sobre como os executar num ficheiro `README.md`.
Os testes deverão ser o mais automáticos possível.

## Valorização

A valorização do trabalho está distribuída da seguinte forma:

+ Rede [8 valores]
  + Emulação da Internet [3 valores]
  + Rede do edifício central [3 valores]
  + Redes das subestações [2 valores]

+ Serviços [9 valores]
  + SSH [1 valor]
  + VPNs [1 valor]
  + Firewalls [1,5 valores]
  + HTTPS [1 valor]
  + Deteção de intrusões [2,5 valores]
  + **Opção**: DHCP **ou** MRTG **ou** DNSSEC [2 valores]

+ Qualidade [3 valores]
  + Qualidade do código *(boa estrutura, bons nomes, comentários relevantes, bons testes)* [1 valor]
  + Relatório *(bem escrito, bem ilustrado, boa argumentação)* [1 valor]
  + Demonstração do funcionamento *(à primeira tentativa, bem explicado, sem falhas)* [1 valor]

## Avaliação

A nota final será dada com base no material entregue no Fénix e numa discussão do projeto que ocorrerá após a data de entrega do projeto.
O grupo deverá preparar uma demonstração rápida do funcionamento do trabalho.

As notas a atribuir serão individuais, por isso é importante que a divisão de tarefas ao longo do trabalho seja equilibrada pelos membros do grupo.
Cada membro deverá estar preparado para responder a perguntas sobre **todo** o trabalho realizado.
Todas as discussões e revisões de nota do trabalho devem contar com a participação obrigatória de todos os membros do grupo.

# Bibliografia

+ [Critical infrastructure][Wikipedia1]
+ [Electrical grid][Wikipedia2]
+ [MRTG Configuration Reference][MRTG]
+ [dhcp3-client][Dhcp1]
+ [dhcp3-server][Dhcp2]

  [Wikipedia1]: http://en.wikipedia.org/wiki/Critical_infrastructure 
  [Wikipedia2]: http://en.wikipedia.org/wiki/Electrical_grid 
  [MRTG]: http://oss.oetiker.ch/mrtg/doc/mrtg-reference.en.html 
  [Bind]: https://github.com/tecnico-sec/Kathara-DNS
  [ssh]: https://github.com/tecnico-sec/Kathara-SSH
  [OpenVPN]: https://github.com/tecnico-sec/Kathara-VPN
  [iptables]: https://github.com/tecnico-sec/Kathara-WebServer-Firewall
  [apache]: https://github.com/tecnico-sec/Kathara-WebServer-Firewall  
  [Dhcp1]: http://wiki.debian.org/DHCP_Client 
  [Dhcp2]: http://wiki.debian.org/DHCP_Server 
  [snort]: http://manual-snort-org.s3-*web*site-us-east-1.amazonaws.com/

---

Caso venham a surgir correções ou clarificações neste documento, podem ser consultadas no histórico (_History_).

**Bom trabalho!**

[Os docentes de SIRS](mailto:leti-sirs@disciplinas.tecnico.ulisboa.pt)
