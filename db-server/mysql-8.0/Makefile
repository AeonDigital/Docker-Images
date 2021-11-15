#
# Aeon Digital
# Rianna Cantarelli <rianna@aeondigital.com.br>
#
include ../../.env





#
# Variáveis de controle
IMAGE_NAME="mysql-8.0"

PROJECT_VERSION_MAJOR=0
PROJECT_VERSION_MINOR=9
PROJECT_VERSION_HASH=$(shell git log -1 --format=%h)
PROJECT_VERSION_TAG=${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_HASH}

PROJECT_NAME=${IMAGE_NAME}:${PROJECT_VERSION_TAG}





#
# Compila a imagem conforme instruções descritas no ``Dockerfile`` 
# A nova imagem receberá uma tag 'latest' ao mesmo tempo que receberá
# uma tag com a versão exata sendo usada no momento.
build:
	docker build -t ${IMAGE_NAME}:latest -t ${PROJECT_NAME} .

#
# Executa um container com a imagem (da versão latest) deste projeto.
# O container será iniciado desanexado.
# O container terá o mesmo nome da imagem.
run:
	docker run -d --name ${IMAGE_NAME} ${IMAGE_NAME}:latest

#
# Mesmo que acima, mas excluirá totalmente o container ao ser 
# desativado. Qualquer 'objeto acessório' como um volume ou rede
# também serão excluídos totalmente.
run-rm:
	docker run -d --rm --name ${IMAGE_NAME} ${IMAGE_NAME}:latest

#
# Encerra o processamento do container.
stop:
	docker stop ${IMAGE_NAME}

#
# Inicia novamente o container
start:
	docker start ${IMAGE_NAME}

#
# Entra no bash do container
bash:
	docker exec -it ${IMAGE_NAME} /bin/bash

#
# Retorna o IP da rede usado pelo container
get-ip:
	docker inspect ${IMAGE_NAME} | grep -oP -m1 '(?<="IPAddress": ")[^"]*'





#
# Efetua login no Docker Hub
login:
	docker login

#
# Define a tag da build atual
tag: login
	docker tag ${IMAGE_NAME} ${VENDOR_NAME}/${IMAGE_NAME}:latest
	docker tag ${IMAGE_NAME} ${VENDOR_NAME}/${PROJECT_NAME}

#
# Efetua o push da imagem para o Docker Hub
push: tag
	docker push ${VENDOR_NAME}/${IMAGE_NAME}:latest
	docker push ${VENDOR_NAME}/${PROJECT_NAME}
