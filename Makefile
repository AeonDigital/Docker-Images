#
# Aeon Digital
# Rianna Cantarelli <rianna@aeondigital.com.br>
#
include .env





#
# DOCKER - CONTAINERS

#
# Encerra o processamento de todos os containers
docker-container-stop-all:
	@echo " - Encerrando o processamento de todos os containers ..."
	docker stop $(shell docker container ls -q)

#
# Remove todos os containers inativos
docker-container-remove-inactives:
	@echo " - Removendo todos os containers inativos ..."
	docker container prune

#
# Remove todos os containers 
docker-container-remove-all:
	@echo " - Removendo todos os containers ..."
	docker rm -f $(shell docker container ls -a -q)



#
# DOCKER - VOLUMES

#
# Remove todos os volumes inativos
docker-volume-remove-inactives:
	@echo " - Removendo todos os volumes inativos ..."
	docker volume prune

#
# Remove todos os volumes
docker-volume-remove-all:
	@echo " - Removendo todos os volumes ..."
	docker volume rm $(shell docker volume ls -a -q)



#
# DOCKER - NETWORK

#
# Remove todas as redes inativas
docker-network-remove-inactives:
	@echo " - Removendo todas as redes inativas ..."
	docker network prune

#
# Remove todas as redes
docker-network-remove-all:
	@echo " - Removendo todas as redes ..."
	docker network rm $(shell docker network ls -a -q)



#
# DOCKER - IMAGE

#
# Remove todas as redes inativas
docker-image-remove-inactives:
	@echo " - Removendo todas as imagens inativas ..."
	docker image prune

#
# Remove todas as redes
docker-image-remove-all:
	@echo " - Removendo todas as imagens ..."
	docker image rm $(shell docker image ls -a -q)





#
# Restaura o Docker da máquina atual para um estado inicial
# Esta ação excluirá TODOS os seguintes itens:
# - containers
# - volumes
# - redes
# - imagens
# 
# Use esta opção APENAS SE TIVER CERTEZA de que não precisa de
# nenhuma informação de nenhum dos itens listados acima.
#
# Para ter segurança que todos os comandos serão rodados use a 
# flag '-i' (--ignore-errors) junto ao comando ``make``.
#
# > make -i docker-reset
#
docker-reset: 
	@echo "\n\n :: Iniciando Docker Reset"
	docker stop $(shell docker container ls -q)
	docker rm -f $(shell docker container ls -a -q)
	docker volume rm $(shell docker volume ls -q)
	docker network rm $(shell docker network ls -q)
	docker image rm $(shell docker image ls -q)
	@echo "\n\n :: Tarefa finalizada"