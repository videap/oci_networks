# *Workshop Networks*

# Objetivos:
Experienciar o processo de implementação de VPN de ponta à ponta, do ponto de vista de cloud e onpremise. Apesar disso, este workshop utilizará somente de recursos em Oracle Cloud. Além disso, esta é uma boa fundação para outros estudos de redes.
# Visão Geral:
Neste workshop, será implementada a seguinte topologia:
![4 networks connected](https://github.com/videap/oci_networks/blob/phoenix/advanced_networks/img/topology.jpg)



Terraform:
Este workshop conta com os arquivos terraform disponibilizados para agilizar a implementação dos recursos. Para rodar os códigos é necessário que se tenha instalado em alguma máquina local a aplicação “Terraform” que pode ser obtida neste link.
Também é necessário ter em mãos as seguintes informações do ambiente Oracle Cloud (tenancy):
- tenancy_ocid (obtido no console)
- compartment_ocid (obtido no console)
- user_ocid (obtido no console)
- private_key_path (diretorio do arquivo que esta salva a chave privada do API)
- fingerprint (obtido no console)
- region (ex. us-ashburn-1)

Substitua os valores corretos no arquivo “example.tfvars” e salve.

## Disponibilidade de recursos:
Os recursos utilizados neste workshop serão 3 máquinas virtuais do tipo VM.Standard2.1. Verifique a disponibilidade dos recursos ou faça alterações devidas nos códigos disponibilizados

# 1. Como rodar os scripts terraform.

### 1.1. No diretório dos arquivos disponibilizados terraform, rodar o comando abaixo
```
terraform init
```
### 1.2. Em seguida rodar o comando abaixo e incluir todas as informações solicitadas no prompt. Neste caso, será pedido um OCID de uma imagem de pfsense. Caso você já possua esta "Custom Image" no seu tenancy, apenas indique o OCID. Caso não, deixe em branco que o script irá realizar a importação.

```
terraform plan
```
### 1.3. Se após a validação, tudo estiver ok, podemos aplicar o código.
```
terraform apply 
yes
```	
### 1.4. Verifique no console a criação dos recursos indicados.


# 2. Configurações no pfsense (onpremise)

### 2.1. Acessar a instância pfsense por ssh através de usuário e senha.
```
User: admin
Pwd: Cloud@12345!
```

### 2.2. Escolher a opção 8 (Shell) e rodar o comando abaixo. Este comando habilitará o Painel do pfsense no seu IP Publico.
```
pfSsh.php playback disablereferercheck
```

### 2.3. Acesse o painel do pfsense através de qualquer navegador utilizando seu IP Publico. Faça login com as mesmas credenciais.

### 2.4. Nas abas superiores, siga o caminho abaixo e crie uma regra de firewall na interface WAN permitindo todos os protocolos para todos os IPs.

- Firewall >> Rules >> WAN >> Add
- Altere Protocol para Any
- Save
- Apply Changes


### 2.5. Adicione uma VNIC secundária (que já está configurada no OCI) com os seguintes passos:

- Interfaces >> Assignments >> em1 >> Add >> Save

### 2.6. Acesse a configuração  da nova interface “em1” no seguinte local:

- Interfaces >> LAN

### 2.7. Configure conforme as especificações abaixo:

- Check "Enable Interface" 
- IPv4 Configuration Type: Static IPv4
- IPv6 Configuration Type: None
- IPv4 Address: <IP privado indicado pela 2a vnic no console>
- Mask: mascara da subrede da 2a VNIC. Neste caso, /24

![img1](https://github.com/videap/oci_networks/blob/phoenix/advanced_networks/img/img1.png)

### 2.8. Clicar em Add a new Gateway, para configurar um gateway de rede para o pfsense. Colocar as informações conforme a imagem abaixo. Neste caso, o Gateway tem valor 10.2.1.1

![img2](https://github.com/videap/oci_networks/blob/phoenix/advanced_networks/img/img2.png)

- Add >> Save >> Apply Changes

### 2.9. Verifique no Dashboard do pfsense (Clique no logo pfSense na barra superior) e valide se as 2 interfaces estão configuradas como na imagem abaixo. Se sim, voce fez as configurações corretamente!

![img3](https://github.com/videap/oci_networks/blob/phoenix/advanced_networks/img/img3.png)

### 2.10. Também crie uma regra de firewall permissiva para esta interface LAN, através dos passos:

- Firewall >> Rules >> LAN >> Add
- Altere Protocol para Any
- Save
- Apply Changes

# 3. Subindo a VPN

### 3.1. Garanta que você tem a tabela abaixo preenchida em algum local. Estas são as informações que você precisará em mãos para estabelecer a conexão:

|  | *REDE ONPREM* |*REDE CLOUD*|
|--|--|--|
| Rede |  Faixa de IPs a serem conectados| Faixa de IPs a serem conectados |
| Endpoints | IP público de conexão | IP público de conexão |
| Autenticação Fase1 | PRE-SHARED KEY | PRE-SHARED KEY |

### 3.2. No caso deste Workshop, preencha com as seguintes informações:

|  | *REDE ONPREM* |*REDE CLOUD*|
|--|--|--|
| Rede |  10.2.0.0/16 | 10.0.0.0/16 e 10.1.0.0/16 |
| Endpoints | IP público do pfsense | IP público apresentado na VPN Connection (OCI) |
| Autenticação Fase1 | PRE-SHARED KEY apresentado na VPN Connection (OCI) | PRE-SHARED KEY apresentado na VPN Connection (OCI)|

### 3.3. Assim, para criar uma VPN no pfsense, siga os passos abaixo:

- VPN >> IPsec >> Tunnels >> ADD P1

### 3.4. Mantenham as configurações padrão, apenas incluindo:
- Remote Gateway: Endpont da REDE CLOUD
- My Identifier: IP Address >> Incluir IP Público do pfsense 
- Pre-shared Key: Incluir o valor da Pre-shared Key

### 3.5. Configuração dos Algoritmos de Criptografia (FASE 1)

Existem diversas possibilidades aqui. Todas podem ser consultadas na documentação da Oracle em Supported Parameters.
Abaixo está um exemplo simples que funciona com pfsense:

![img4](https://github.com/videap/oci_networks/blob/phoenix/advanced_networks/img/img4.png)

Mantenha as outras configurações padrão do pfsense. Em outros appliance, valide se os outros parametros como Lifetime estão corretos.

### 3.6. Configuração das Key Exchanges (FASE 2)

- VPN >> IPsec >> Tunnels >> Show Phase 2 Entries >> Add P2

Local Network: 10.2.0.0/16
Remote Network: 10.0.0.0/15

	>Obs. 10.0.0.0/15 é uma faixa de IP que contempla 10.0.0.0/16 + 10.1.0.0/16

Em Phase 2 Proposal, os parâmetros suportados podem ser validados na documentação. Mas abaixo está um exemplo que funciona com pfsense:

![img5](https://github.com/videap/oci_networks/blob/phoenix/advanced_networks/img/img4.png)

### 3.7. Apply Changes
### 3.8. Valide se a conexão está de pé em Status >> IPsec
### 3.9. Em Diagnostigs >> Ping, tente pingar a VM do outro lado.

Para maiores detalhes, consulte a documentação no link:
https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/settingupIPsec.htm#Setting_Up_VPN_Connect







