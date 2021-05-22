# Lista de verificação (*Checklist*)

**Grupo 2**

## Rede

### Quantos routers tem no total?
internet + 4

### Quantos switches tem no total?
1 + 6

### Quantas máquinas tem no total? (quantos contentores do Kathará são criadas quanto faz kathara lstart)
17

### Quantos computadores ligou ao router da Internet?
3

### Quantas subredes implementou dentro da ICI (excluindo a Internet)?

### Quantos routers implementou dentro da ICI (excluindo a Internet)?

### Implementou o servidor DNS da ICI?
sim

### Implementou o servidor WWW da ICI?
sim

### Implementou os dois PCs da ICI?
sim

### Criou o PC da LAN SCADA?
sim

### Criou o PC historian?
sim

### Implementou as subredes das suas subestações?

### Implementou os dois switches dessas subredes?

## Serviços

### Criou uma conta admin nos dois servidores da LAN de serviços?
sim

### Implementou alguma coisa no PC historian?
sql server

### Implementou o MRTG? Funciona?

### Quantas páginas web com gráficos está a fornecer o MRTG?

### Configurou o OpenSSH?
sim

### É possível fazer ssh e scp do PC da Internet para os servidores da LAN de serviços?
ssh dns.acdc.pt
touch /tmp/tmp.test
scp /tmp/tmp.test www.acdc.pt:/home/admin/test
ssh www.acdc.pt

### É possível fazer ssh e scp dos PCs dos engenheiros para os dois servidores da LAN de serviços?
scp -i /root/id_rsa /tmp/ici.tmp dns.acdc.pt:/home/admin/test
ssh -i /root/id_rsa dns.acdc.pt

### Ao fazer ssh e scp, a autenticação é baseada em criptografia de chave pública?
sim

### Configurou as VPNs usando o pacote OpenVPN? Funcionam?

### Configurou o netfilter / iptables no router do edifício central?
sim

### Esse router bloqueia a maior parte dos acessos da Internet à ICI?

### Esse router bloqueia a maior parte dos acessos da DMZ às outras subredes da ICI?

### Criou um novo nó para instalar o IDS na rede da DMZ?
no router principal

### Instalou o IDS na rede DMZ?
screen -r servicesNIDS

### Instalou o IDS na subrede corporate?
sim

### Indique o conteúdo do teste usado para testar o IDS
screen -r corporateNIDS
ping -b -c 1 95.92.199.255

screen -r servicesNIDS
ping -b -c 1 95.92.204.127

### Configurou DHCP? Funciona?

### Configurou HTTPS? Funciona?
sim, curl -k https://www.acdc.pt/index.html

### Configurou DNSSEC? Funciona?
