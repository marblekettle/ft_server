FROM debian:buster

ENV	MYSQL_ROOT_PASSWORD server
ENV	USER_PASSWORD server

RUN echo "Welcome to my Docker image :)" \
&&	apt-get update \
&&	apt-get upgrade -y \
&&	apt-get install dialog apt-utils sudo vim wget nginx php-fpm lsb-release gnupg -y \
&&	mkdir server \
&&	wget -q -P server https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb \
&&	dpkg -i server/mysql-apt-config_0.8.14-1_all.deb \
&&	apt-get update \
&&	apt-get install mariadb-server mariadb-client php-mysql -y \
&&	wget -q -P server https://wordpress.org/latest.tar.gz \
&&	tar -xf server/latest.tar.gz -C server \
&&	wget -q -P server https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz \
&&	tar -xf server/phpMyAdmin-4.9.4-english.tar.gz -C server \
&&	mv server/phpMyAdmin-4.9.4-english server/phpmyadmin \
&&	chmod -R 755 server \
&&	useradd server \
&&	echo server:${USER_PASSWORD} | chpasswd \
&&	echo root:${USER_PASSWORD} | chpasswd
COPY ./srcs/default /etc/nginx/sites-enabled/
#COPY ./srcs/index.php /var/www/html/

EXPOSE 80 3306
ENTRYPOINT	service nginx start \
		&&	service php7.3-fpm start \
		&&	service mysql start \
		&&	mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE server" \
		&&	bash