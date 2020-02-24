FROM debian:buster

RUN echo "Welcome to my Docker image :)" \
&&	apt-get update \
&&	apt-get upgrade -y \
&&	apt-get install dialog apt-utils sudo vim wget nginx php-fpm lsb-release gnupg -y \
&&	wget -q -P root https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb \
&&	dpkg -i root/mysql-apt-config_0.8.14-1_all.deb \
&&	apt-get update \
&&	apt-get install mariadb-server mariadb-client -y \
&&	wget -q -P root https://wordpress.org/latest.tar.gz \
&&	tar -xf root/latest.tar.gz -C root \
&&	wget -q -P root https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz \
&&	tar -xf root/phpMyAdmin-4.9.4-english.tar.gz -C root
COPY ./srcs/default /etc/nginx/sites-enabled/
COPY ./srcs/index.php /var/www/html/

EXPOSE 80
ENTRYPOINT service nginx start && service php7.3-fpm start && bash