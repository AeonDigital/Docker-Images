#!/bin/bash


#
# Definindo o timezone padrão do container
ln -snf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
echo America/Sao_Paulo > /etc/timezone

#
# Iniciando o serviço do apache
apachectl -D FOREGROUND