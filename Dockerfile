# Reference: https://www.howtoforge.com/tutorial/how-to-create-docker-images-with-dockerfile/

# Based on current latest ubuntu LTS
FROM ubuntu:18.04

# No interactive
#   https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ARG DEBIAN_FRONTEND=noninteractive

# Install Software from Ubuntu repository
RUN apt update && apt -y upgrade && apt -y autoremove && apt install -y \
    curl expect iputils-ping zip unzip nano parallel wget sudo \
    mysql-client \
    apache2 apachetop \
    memcached \
    php libapache2-mod-php php-cli php-cgi php-mysql php-intl php-zip php-bcmath php-apcu php-memcached \
    default-jdk maven plantuml \
    fonts-freefont-otf fonts-freefont-ttf ttf-aenigma ttf-summersby \
    fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core \
    graphviz librsvg2-bin inkscape libcanberra-gtk-module

# Install BinaryDoc Parser
RUN mkdir -p /opt/fuiny/binarydoc-parser && cd /opt/fuiny/binarydoc-parser && rm -rf * && wget http://repos.fuiny.net/dist/binarydoc/binarydoc-parser.zip && unzip binarydoc-parser.zip
RUN mkdir -p /opt/fuiny/binarydoc-db     && cd /opt/fuiny/binarydoc-db     && rm -rf * && wget http://repos.fuiny.net/dist/binarydoc/binarydoc-db.zip     && unzip binarydoc-db.zip
RUN mkdir -p /opt/fuiny/demo-tgav

# Install BinaryDoc WebSite
RUN cd /var/www && sudo rm -rf php-library/ && sudo rm -f website-php-library.zip         && sudo wget http://repos.fuiny.net/dist/binarydoc/website-php-library.zip         && sudo unzip website-php-library.zip
RUN cd /var/www && sudo rm -rf html/        && sudo rm -f website-org.binarydoc.repos.zip && sudo wget http://repos.fuiny.net/dist/binarydoc/website-org.binarydoc.repos.zip && sudo unzip website-org.binarydoc.repos.zip && sudo mv org.binarydoc.repos html
RUN chmod -R 777 /var/www/html/api/cache

# Setup Apache
RUN a2enmod cgi cgid expires info proxy_http ssl
COPY etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2"]

