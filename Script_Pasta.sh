#!/bin/bash -
#===============================================================================
#
#          FILE:  Comp_fstab.sh
# 
#         USAGE:  ./Comp_fstab.sh.sh 
# 
#   DESCRIPTION:  Esse script visa automatizar o mapeamento de compartilhamentos  
#                 em uma rede.  
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#      AUTHOR'S: Adriano Henrique (adrianohenriquesantana@gmail.com) 
#       COMPANY: 
#       CREATED: 01/08/2016
#      REVISION:  ---
#===============================================================================
r=1

#Solicitando credenciais da rede
echo "Digite login: "
read nome
stty -echo
read -p "Senha: " senha
stty echo 
echo "\n"

#Iniciando loop
while [ $r != 0 ];
do
 
 #Aqui será solicitado o nome da pasta que será mapeada
 echo "Digite o nome da pasta: "
 read compartilhamento

 #Testando pasta do usuário
 cd /home/DOMINIO/$nome
 
 #Testando pasta do compartilhamento. Caso não exista, a pasta que recebeŕa os arquivos será criada.
 if [ -d $compartilhamento ];then
  echo "Diretorio já Existe"
 else
  mkdir -p /home/DOMINIO/$nome/$compartilhamento;
 fi  

 #Testando e criando credenciais.
 cd /home/DOMINIO/$nome/

 #Aqui será criado o arquivo com as credenciais do usuário, caso não exista.	
 if [  -e .$nome ]; then
  echo "\n"
 else
  touch .$nome
  echo "username=$nome" >> .$nome
  echo "password=$senha" >> .$nome
  echo "domain=DOMINIO" >> .$nome
 fi

 #Escrevendo informações no arquivos fstab 
 cd /etc
 echo "#Compartilhamento do usuario $nome para acesso a pasta $compartilhamento " >> fstab
 echo "//SERVIDOR/$compartilhamento$ /home/DOMINIO/$nome/$compartilhamento cifs x-systemd.automount,credentials=/home/DOMINIO/$nome/.$nome,dir_mode=0777,file_mode=0777 0 0 " >> fstab
 
 #Montando os compartilhamentos
 mount -a
 
 #Condição do loop
 echo "Deseja repetir a operação ? (1 = SIM 0 = NÃO) "
 read r
done

