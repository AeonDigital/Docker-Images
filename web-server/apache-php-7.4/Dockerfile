FROM debian:stable-20211011-slim

LABEL   "project"="web-server-apache-php-7.4" \
        "description"="Debian based web server with Apache and PHP 7.4." \
        "vendor.name"="Aeon Digital" \
        "vendor.site"="aeondigital.com.br" \
        "author.name"="Rianna Cantarelli" \
        "author.email"="rianna@aeondigital.com.br"





#
# Define argumentos a serem passados para o momento de build
ARG DEBIAN_FRONTEND=noninteractive

#
# Variáveis de ambiente para o build
ENV PATH=$PATH:/root/composer/vendor/bin \
    COMPOSER_ALLOW_SUPERUSER=1 \
	ENV_TIMEZONE=America/Sao_Paulo



# 
# Comandos que compõe o build
RUN buildPacks=" \
        curl ca-certificates git vim zip unzip \
        apache2 \
        php7.4 \
        php7.4-dom php7.4-curl php7.4-tidy php7.4-mbstring php7.4-bcmath \
        php7.4-gd php7.4-zip php7.4-mysql \
    " \ 
    && apt-get update -y \
    && apt-get install -y --no-install-recommends ${buildPacks} \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt \
    && a2enmod rewrite

#
# Instalação do Composer
# os pacotes 'php7.4-curl'; 'zip'; 'unzip' foram instalados como
# dependencias opcionais.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer

#
# Instalação do PHPUnit
RUN curl -Lo /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-9.phar \
    && chmod +x /usr/local/bin/phpunit



#
# Ajusta o timezone do container
RUN ln -snf /usr/share/zoneinfo/${ENV_TIMEZONE} /etc/localtime \
	&& echo ${ENV_TIMEZONE} > /etc/timezone

#
# Redefine o .bashrc para acessos '-it'
RUN > /root/.bashrc \
    && echo "loadkeys br-abnt2" >> /root/.bashrc \
    && echo "alias ls='ls --color=auto'" >> /root/.bashrc \
    && echo "alias ll='ls -la --color=auto'" >> /root/.bashrc \
    && echo "PS1='\[\e[0;94;49m\]\$ \[\e[0;90;49m\]\u\[\e[0;94;49m\]@docker \[\e[0;90;49m\]\h\[\e[0;94;49m\] in \[\e[0;90;49m\]\w \n\076\[\e[0;37;49m\]\040'" >> /root/.bashrc



#
# Diretório de trabalho padrão
WORKDIR /var/www/html

#
# Portas que serão expostas
EXPOSE 80 443

#
# Configura o comando de inicialização do container.
COPY cmd.sh /
RUN chmod +x /cmd.sh
CMD ["/cmd.sh"]
