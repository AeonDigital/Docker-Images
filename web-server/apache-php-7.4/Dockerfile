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
# Importa o script de inicialização a ser usado no container.
ADD start.sh /



# 
# Comandos que compõe o build
RUN buildPacks=" \
        apache2 \
        php7.4 \
        php7.4-dom php7.4-mbstring php7.4-bcmath php7.4-gd php7.4-zip \
        curl git vim \
    " \ 
    && apt-get -y update \
    && apt-get -y install $buildPacks \
    && apt-get -y upgrade \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -r /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt \
    && a2enmod rewrite \
    && chmod +x /start.sh



#
# Instalação do Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer

#
# Instalação do PHPUnit
RUN curl -Lo /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-9.phar \
    && chmod +x /usr/local/bin/phpunit

#
# Redefinindo o .bashrc para acessos '-it'
RUN > /root/.bashrc \
    && echo "loadkeys br-abnt2" >> /root/.bashrc \
    && echo "alias ls='ls --color=auto'" >> /root/.bashrc \
    && echo "alias ll='ls -la --color=auto'" >> /root/.bashrc \
    && echo "PS1='\[\e[0;94;49m\]\$ \[\e[0;90;49m\]\u\[\e[0;94;49m\]@docker \[\e[0;90;49m\]\h\[\e[0;94;49m\] in \[\e[0;90;49m\]\w \n\076\[\e[0;37;49m\]\040'" >> /root/.bashrc



#
# Variáveis de ambiente
ENV PATH=$PATH:/root/composer/vendor/bin \
    COMPOSER_ALLOW_SUPERUSER=1

#
# Diretório de trabalho padrão
WORKDIR /var/www/html

#
# Porta que será exposta
EXPOSE 80

#
# Configura o script de inicialização para que ele
# seja executado sempre que um container iniciar.
CMD /start.sh