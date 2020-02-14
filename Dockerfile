FROM debian:buster

RUN echo "Welcome to my Docker image :)" \
&&	apt-get update \
&&	apt-get install dialog -y \
&&	apt-get install apt-utils -y \
&&	apt-get install sudo wget nginx lsb-release gnupg -y \
&&	wget -q -P root https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb \
&&	dpkg -i root/mysql-apt-config_0.8.14-1_all.deb \
&&	apt-get update
## &&	apt-get install mysql-server -y

EXPOSE 80
ENTRYPOINT service nginx start && bash