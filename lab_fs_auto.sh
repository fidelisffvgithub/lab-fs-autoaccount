##Script bash para criação de ambiente Storage Account\File Share e Automation Account
## Recursos e configurações 
#Resource Group
#Vnet com address space 10.10.0.0/16 e subnet 10.10.1.0/24
#Network Security Group associado à subnet, com regra RDP de entrada para a VM
#Virtual Machine e remove o NSG associado à nic
#Storage Account e File Share
#Instala extensão e cria Automation Account

## O modelo de VM utilizado para esse lab é o Standard_B2s. 
## Verifique a disponibilidade na região que escolher para o lab.
## Utilize o comando abaixo ou simule uma criação no portal. 
## az vm list-skus --size Standard_B2s --output table

### Variáveis ###
let "randomIdentifier=$RANDOM*$RANDOM"
rg="RG-LAB"
loc="JapanEast"
vnet="vnet-lab"
subnet="sub-lab"
sto="sto$randomIdentifier"
fileshare="fs01"
nsg="nsg-lab"
vm="vm01"



### RG ####
az group create -n $rg --location $loc


### Virtual Network e Subnet ###
az network vnet create -n $vnet -g $rg --address-prefix 10.10.0.0/16  --subnet-name $subnet --subnet-prefix 10.10.1.0/24 


### Criar NSG e regra. Asssociar à sub-lan. ###
az network nsg create -g $rg -n $nsg 
az network vnet subnet update -g $rg -n $subnet --vnet-name $vnet --network-security-group $nsg
az network nsg rule create -g $rg --nsg-name $nsg -n Allow-3389 --access Allow --protocol Tcp --direction Inbound --priority 120 --source-address-prefix "*" --source-port-range "*" --destination-address-prefixes 10.10.1.4 --destination-port-range 3389


### Criar VM ###
az vm create --resource-group $rg --name $vm --image "Win2016Datacenter" --size Standard_B2s --public-ip-sku Standard --vnet-name $vnet --subnet $subnet --admin-username azwin --admin-password P@ssword123@
nicID=$(az vm show -n $vm -g $rg --query 'networkProfile.networkInterfaces[].id' -o tsv)
nsgID=$(az network nic show --ids $nicID --query 'networkSecurityGroup.id' -o tsv)
az network nic update --ids $nicID --remove networkSecurityGroup


### Storage Account ###
# Criar storage
az storage account create -n $sto -g $rg --location $loc --sku Standard_LRS --kind StorageV2

# Criar file share
az storage share-rm create -g $rg --storage-account $sto -n $fileshare --access-tier "TransactionOptimized" --quota 5120 --output none


### Automation Account ###
# Instalar extensão
az extension add --name automation

# Criar Automation Account
az automation account create --automation-account-name "AutomationAccount" --location $loc --sku "Free" --resource-group $rg


### Listar recursos ###
echo "#### RECURSOS CRIADOS #####"
az resource list -g $rg --output table





