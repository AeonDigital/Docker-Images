#
# Aeon Digital
# Rianna Cantarelli <rianna@aeondigital.com.br>
#
include ../../.env
.SILENT:





#
# Variáveis de controle
IMAGE_NAME="mysql-8.0"
HAS_DEV=0

PROJECT_VERSION_MAJOR=0
PROJECT_VERSION_MINOR=9
PROJECT_VERSION_HASH=$(shell git log -1 --format=%h)
PROJECT_VERSION_TAG=${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_HASH}





#
# Compila a imagem conforme instruções descritas no ``Dockerfile``
# A nova imagem receberá uma tag 'latest'.
build:
	docker build -t ${IMAGE_NAME}:latest .

#
# Compila a imagem conforme instruções descritas no ``Dockerfile.dev``
# A nova imagem receberá uma tag 'dev'.
# Se esta imagem não possui uma versão 'dev', apenas cria a tag para a mesma.
build-dev:
	if [ "${HAS_DEV}" = "1" ]; then \
		docker build -t ${IMAGE_NAME}:dev -f Dockerfile.dev .; \
	else \
		docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:dev; \
	fi;

#
# Executa um container com a imagem (da versão latest) deste projeto.
# O container será iniciado desanexado.
# O container terá o mesmo nome da imagem.
#
# Use o parametro 'tag' para indicar qual versão exatamente você deseja rodar
run:
	if [ -z "${tag}" ]; then \
		docker run -d --name ${IMAGE_NAME} ${IMAGE_NAME}:latest; \
	else \
		docker run -d --name ${IMAGE_NAME} ${IMAGE_NAME}:${tag}; \
	fi;

#
# Mesmo que acima, mas excluirá totalmente o container ao ser
# desativado. Qualquer 'objeto acessório' como um volume ou rede
# também serão excluídos totalmente.
#
# Use o parametro 'tag' para indicar qual versão exatamente você deseja rodar
run-rm:
	if [ -z "${tag}" ]; then \
		docker run -d --rm --name ${IMAGE_NAME} ${IMAGE_NAME}:latest; \
	else \
		docker run -d --rm --name ${IMAGE_NAME} ${IMAGE_NAME}:${tag}; \
	fi;

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
	docker inspect ${IMAGE_NAME} | grep -oP -m1 '(?<="IPAddress": ")[a-f0-9.:]+'





#
# Efetua login no Docker Hub
login:
	docker login

#
# Define a tag da build atual
tag: login
	if [ "${HAS_DEV}" = "1" ]; then \
		docker tag ${IMAGE_NAME}:dev ${VENDOR_NAME}/${IMAGE_NAME}:dev; \
	else \
		docker tag ${IMAGE_NAME}:latest ${VENDOR_NAME}/${IMAGE_NAME}:dev; \
	fi;
	docker tag ${IMAGE_NAME}:latest ${VENDOR_NAME}/${IMAGE_NAME}:latest
	docker tag ${IMAGE_NAME}:latest ${VENDOR_NAME}/${IMAGE_NAME}:${PROJECT_VERSION_TAG}

#
# Efetua o push da imagem para o Docker Hub
push: tag
	docker push ${VENDOR_NAME}/${IMAGE_NAME}:dev
	docker push ${VENDOR_NAME}/${IMAGE_NAME}:latest
	docker push ${VENDOR_NAME}/${IMAGE_NAME}:${PROJECT_VERSION_TAG}
