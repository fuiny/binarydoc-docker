# Reference: https://www.howtoforge.com/tutorial/how-to-create-docker-images-with-dockerfile/

# Based on current latest ubuntu LTS
FROM ubuntu:18.04

# No interactive
#   https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ARG DEBIAN_FRONTEND=noninteractive

# Install Software from Ubuntu repository
RUN apt update
RUN apt -y upgrade
RUN apt -y autoremove

RUN apt install -y curl expect iputils-ping zip unzip nano parallel wget sudo
RUN apt install -y mysql-client

RUN apt install -y apache2 apachetop
RUN a2enmod cgi cgid expires info proxy_http ssl

RUN apt install -y memcached
RUN apt install -y php libapache2-mod-php php-cli php-cgi php-mysql php-intl php-zip php-bcmath php-apcu php-memcached 

RUN apt install -y default-jdk maven plantuml
RUN apt install -y fonts-freefont-otf fonts-freefont-ttf ttf-aenigma ttf-summersby
RUN apt install -y fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core

RUN apt install -y graphviz librsvg2-bin inkscape libcanberra-gtk-module

RUN apt update
RUN apt -y upgrade
RUN apt -y autoremove

# Install BinaryDoc Parser
RUN mkdir -p /opt/fuiny/binarydoc-parser
RUN cd       /opt/fuiny/binarydoc-parser && rm -rf * && wget http://repos.fuiny.net/dist/binarydoc/binarydoc-parser.zip && unzip binarydoc-parser.zip

RUN mkdir -p /opt/fuiny/binarydoc-db
RUN cd       /opt/fuiny/binarydoc-db && rm -rf * && wget http://repos.fuiny.net/dist/binarydoc/binarydocjvmadm-create.sql && wget http://repos.fuiny.net/dist/binarydoc/create-users.sql


# Install BinaryDoc WebSite
RUN cd /var/www && sudo rm -rf php-library/ && sudo rm -f website-php-library.zip         && sudo wget http://repos.fuiny.net/dist/binarydoc/website-php-library.zip         && sudo unzip website-php-library.zip
RUN cd /var/www && sudo rm -rf html/        && sudo rm -f website-org.binarydoc.repos.zip && sudo wget http://repos.fuiny.net/dist/binarydoc/website-org.binarydoc.repos.zip && sudo unzip website-org.binarydoc.repos.zip && sudo mv org.binarydoc.repos html


COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2"]

