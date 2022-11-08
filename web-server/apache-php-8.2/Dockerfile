FROM debian:stable-20221024-slim

LABEL   "project"="web-server-apache-php-8.2" \
        "description"="Debian based web server with Apache and PHP 8.2." \
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
# Ajusta o timezone do container
RUN ln -snf /usr/share/zoneinfo/${ENV_TIMEZONE} /etc/localtime \
	&& echo ${ENV_TIMEZONE} > /etc/timezone

#
# Redefine o .bashrc para acessos '-it'
RUN > /root/.bashrc \
    && echo "[[ \$- != *i* ]] && return" >> /root/.bashrc \
    && echo "alias ls='ls --color=auto --group-directories-first --human-readable'" >> /root/.bashrc \
    && echo "PS1='\[\e[0;94;49m\]\$ \[\e[0;90;49m\]\u\[\e[0;94;49m\]@docker \[\e[0;90;49m\]\h\[\e[0;94;49m\] in \[\e[0;90;49m\]\w \n\076\[\e[0;37;49m\]\040'" >> /root/.bashrc \
    && echo "LS_COLORS='tw=1;20;49;35:*.config=1;20;49;36:no=0:fi=0:mi=1;20;49;36:or=1;20;49;36:bd=0:ow=1;20;49;34:di=1;20;49;94:do=0:cd=0:pi=0:*.conf=1;20;49;36:sg=1;2;49;37:ln=1;20;49;36:so=0:st=1;2;49;95:su=1;2;49;37:ex=1;2;49;37'" >> /root/.bashrc \
    && cp /root/.bashrc /etc/skel/.bashrc \
    && rm /etc/skel/.bash_logout



#
# Inicia preparos para a instalação do php 8.2
#
# @REVIEW
# https://php.watch/articles/install-php82-ubuntu-debian
# Neste momento (11/11/2022) ele ainda está n versão CR6 e deve ser lançado efetivamente em 24/11
# Quando o for, e estiver entre os pacotes oficiais fornecidos para distro Debian esta parte abaixo
# poderá ser revista e possivelmente totalmente removida.
RUN dpkg -l | grep php | tee packages.txt
RUN apt update -y \
    && apt install -y \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        wget

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'



#
# Instala e configura os pacotes principais da build
#
# @REVIEW
# https://php.watch/articles/install-php82-ubuntu-debian
# Adicionado "libapache2-mod-php8.2" para a configuração do apache (provavelmente pode sair quando a
# versão final do PHP 8.2 for lançado)
# Adicionado "php8.2-cli" pois esta instalação personalizada não o instala por padrão  (aguardar até lançamento oficial)
# Adicionado "php8.2-intl" para internacionalização
# Adicionado "php8.2-curl" para a lista de módulos fixos e não mais como uma dependencia do composer
RUN buildPacks=" \
        curl ca-certificates git vim \
        apache2 libapache2-mod-php8.2 \
        php8.2 php8.2-cli \
        php8.2-dom php8.2-tidy php8.2-mbstring php8.2-bcmath \
        php8.2-gd php8.2-zip php8.2-mysql php8.2-intl php8.2-curl \
        default-mysql-client \
        iputils-ping \
    " \
    && apt update -y \
    && apt install -y ${buildPacks} \
    && a2enmod rewrite \
    && apt purge php8.1*

#
# Instalação do Composer
# os pacotes 'zip'; 'unzip' são instalados como dependencias.
RUN apt-get install -y --no-install-recommends zip unzip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer

#
# Limpa dados temporários do 'apt'
RUN apt autoremove -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

#
# Copia os arquivos de configuração para este build
# [Efetua um 'merge' com os arquivos padrões existentes no container]
COPY ./configuration-files/prd/etc/. /etc/





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
CMD [ "/cmd.sh" ]
