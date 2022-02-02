FROM debian:stable-20211011-slim

LABEL   "project"="db-server-mysql-8.0" \
        "description"="Debian based database server with MySql 8.0." \
        "vendor.name"="Aeon Digital" \
        "vendor.site"="aeondigital.com.br" \
        "author.name"="Rianna Cantarelli" \
        "author.email"="rianna@aeondigital.com.br"





#
# Variáveis de ambiente para o build
ENV GOSU_VERSION=1.14 \
	MYSQL_MAJOR=8.0 \
	MYSQL_VERSION=8.0.28-1debian10 \
	MYSQL_ROOT_PASSWORD=root \
	ENV_TIMEZONE=America/Sao_Paulo



#
# Ajusta o timezone do container
RUN ln -snf /usr/share/zoneinfo/${ENV_TIMEZONE} /etc/localtime \
	&& echo ${ENV_TIMEZONE} > /etc/timezone

#
# Redefine o .bashrc para acessos '-it'
RUN > /root/.bashrc \
    && echo "alias ls='ls --color=auto'" >> /root/.bashrc \
    && echo "alias ll='ls -la --color=auto'" >> /root/.bashrc \
    && echo "PS1='\[\e[0;94;49m\]\$ \[\e[0;90;49m\]\u\[\e[0;94;49m\]@docker \[\e[0;90;49m\]\h\[\e[0;94;49m\] in \[\e[0;90;49m\]\w \n\076\[\e[0;37;49m\]\040'" >> /root/.bashrc


#
# Em primeiro lugar, adiciona um grupo 'mysql' e após, um usuário 'mysql'
# para ter certeza que os respectivos IDs estarão assinados consistentemente.
#
# Após, atualiza o apt-get e instala pacotes que serão úteis para
# o restante da build
RUN groupadd -r mysql \
	&& useradd -r -g mysql mysql \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends gnupg dirmngr

#
# Adiciona o projeto 'gosu' para facilitar o uso de ações
# que exijam privilégios elevados ('su' ou 'sudo')
# https://github.com/tianon/gosu/releases
RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get install -y --no-install-recommends ca-certificates wget; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

#
# Instala outros pacotes necessários
RUN mkdir /docker-entrypoint-initdb.d \
	&& apt-get install -y --no-install-recommends pwgen openssl perl xz-utils

#
# Verificação
# gpg: key 3A79BD29: public key
# "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
RUN set -ex; \
	key='859BE8D7C586F538430B19C2467B942D3A79BD29'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
	gpg --batch --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME"; \
	apt-key list > /dev/null

#
# Prepara o APT para receber a fonte de pacotes que permitem instalar o mysql.
# Atualiza o APT e instala o 'mysql-community-client' e o 'mysql-community-server-core'
# na mesma versão que foi definida na variável de ambiente 'MYSQL_VERSION'.
RUN echo 'deb http://repo.mysql.com/apt/debian/ buster mysql-8.0' > /etc/apt/sources.list.d/mysql.list \
	&& { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update \
	&& apt-get install -y \
		mysql-community-client="${MYSQL_VERSION}" \
		mysql-community-server-core="${MYSQL_VERSION}" \
	&& rm -rf /var/lib/mysql \
	&& mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 1777 /var/lib/mysql /var/run/mysqld \
	&& chmod 777 /dev/stderr

#
# Limpa dados temporários do 'apt'
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt





#
# Copia os arquivos de configuração para este build
# [Efetua um 'merge' com os arquivos padrões existentes no container]
COPY ./configuration-files/prd/etc/. /etc/
# Ajusta permissões de acessos para os arquivos sensíveis.
RUN chmod 644 /etc/mysql/my.cnf



#
# Configuração do entrypoint padrão para os containers
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh \
	&& ln -s usr/local/bin/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

#
# Especifica um local do container que será montado
# em um volume no ambiente do hospedeiro.
VOLUME /var/lib/mysql

#
# Portas que serão expostas
EXPOSE 3306

#
# Configura o comando de inicialização do container.
CMD ["mysqld"]

#
# Este arquivo e os outros que fazem parte deste build foram
# coletados do repositório "https://github.com/docker-library/mysql"
# e adaptados para as necessidades dos projetos Aeon Digital.

#
# O comando abaixo pode ser usado em seu docker-compose.
# Ele é opcional e está aqui registrado para eventualidade de uso futuro.
# command: mysqld --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
