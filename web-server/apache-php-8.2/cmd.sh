#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]


#
# Iniciando o serviço
if [ $(whoami) == "root" ]; then
  apachectl -D FOREGROUND
else
  su root -s /bin/bash -c "apachectl -D FOREGROUND"
fi