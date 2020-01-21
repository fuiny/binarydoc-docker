# Reference: https://www.howtoforge.com/tutorial/how-to-create-docker-images-with-dockerfile/

# Based on current latest ubuntu LTS
FROM ubuntu:18.04

# No interactive
#   https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ARG DEBIAN_FRONTEND=noninteractive

# Install Software from Ubuntu repository
RUN apt update
RUN apt install -y apache2 memcached
RUN apt install -y php libapache2-mod-php php-cli php-cgi php-mysql php-intl php-zip php-bcmath php-apcu php-memcached 
RUN apt install -y graphviz inkscape libcanberra-gtk-module
RUN apt install -y default-jdk plantuml
RUN apt update
RUN apt -y upgrade
RUN apt -y autoremove

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2"]

