FROM debian:buster

ENV	MYSQL_ROOT_PASSWORD server
ENV MYSQL_EMAIL server@server.com
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
&&	chmod -R 777 server/wordpress/wp-content      \
&&	useradd server \
&&	mkdir /usr/bin/wp \
&&	wget -q -P /server https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&&	chmod +x /server/wp-cli.phar \
&&	echo server:${USER_PASSWORD} | chpasswd \
&&	echo root:${USER_PASSWORD} | chpasswd \
&&	usermod -aG sudo server
#&&	echo 'alias wp = "php /server/wp-cli.phar"' >> /home/server/.bashrc
COPY ./srcs/default /etc/nginx/sites-enabled/
COPY ./srcs/wp-config.php /server/wordpress/
#COPY ./srcs/index.php /var/www/html/

USER server
EXPOSE 80 3306
ENTRYPOINT	echo $USER_PASSWORD | sudo -S service nginx start \
		&&	sudo service php7.3-fpm start \
		&&	sudo service mysql start \
		&&	sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER 'server'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" \
		&&	sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE server;" \
		&&	sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON server.* TO 'server'@'localhost';" \
		&&	sudo php /server/wp-cli.phar --info \
		&&	php /server/wp-cli.phar core install \
			--path=/server/wordpress/ \
			--url=localhost \
			--title="test" \
			--admin_name=server \
			--admin_password=${MYSQL_ROOT_PASSWORD} \
			--admin_email=${MYSQL_EMAIL} \
		&&	bash