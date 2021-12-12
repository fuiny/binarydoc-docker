# Based on current latest Ubuntu LTS
FROM ubuntu:20.04

# No interactive
#   https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ARG DEBIAN_FRONTEND=noninteractive

# Install Software from Ubuntu repository
RUN apt update && apt -y upgrade && apt -y autoremove && apt install -y \
    curl expect iputils-ping zip unzip nano parallel wget sudo \
    mysql-client \
    apache2 apachetop \
    memcached \
    php libapache2-mod-php php-cli php-cgi php-mbstring php-mysql php-intl php-zip php-bcmath php-apcu php-memcached \
    openjdk-17-jdk maven plantuml \
    fonts-freefont-otf fonts-freefont-ttf ttf-aenigma ttf-summersby \
    fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core \
    graphviz librsvg2-bin inkscape libcanberra-gtk-module

# Install Customized software
RUN rm    -f                                                    /usr/bin/mc \
 && wget  https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/bin/mc \
 && chmod +x                                                    /usr/bin/mc \
 && mkdir -p                 /var/www/.mc                                   \
 && chown www-data:www-data  /var/www/.mc/

# Install BinaryDoc Parser
RUN mkdir -p /opt/fuiny/binarydoc-db     && cd /opt/fuiny/binarydoc-db     && wget http://repos.fuiny.net/dist/binarydoc/binarydoc-4.5.1-db.zip     && unzip binarydoc-4.5.1-db.zip      \
 && mkdir -p /opt/fuiny/binarydoc-parser && cd /opt/fuiny/binarydoc-parser && wget http://repos.fuiny.net/dist/binarydoc/binarydoc-4.5.1-parser.zip && unzip binarydoc-4.5.1-parser.zip  \
 && mkdir -p /opt/fuiny/app-to-parse

# Install BinaryDoc WebSite
RUN cd /var/www && sudo rm -rf html/         && sudo wget http://repos.fuiny.net/dist/binarydoc/binarydoc-4.5-web_org.binarydoc.www.zip && sudo unzip -q binarydoc-4.5-web_org.binarydoc.www.zip && sudo mv org.binarydoc.www html  \
 && cd /var/www && sudo rm -rf php-library/  && sudo wget http://repos.fuiny.net/dist/binarydoc/binarydoc-4.5-web_php-library.zip       && sudo unzip -q binarydoc-4.5-web_php-library.zip \
 && truncate -s 0  /var/www/php-library/ads/amazon-banners.php                           \
 && truncate -s 0  /var/www/php-library/ads/google-adsense-responsive-text-display.php

# Setup Web Server
RUN  a2enmod cgi cgid expires info proxy_http ssl
COPY etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY etc/php/apache2/conf.d/fuiny-php.ini         /etc/php/7.4/apache2/conf.d/
COPY var/www/html/apc.php                         /var/www/html/
COPY var/www/html/phpinfo.php                     /var/www/html/
COPY docker-entrypoint.sh                         /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2"]

