FROM debian:buster

ENV	WP_TITLE "hey"
ENV SERVER_DIR server
ENV USER_NAME server
ENV	MYSQL_ROOT_PASSWORD server
ENV MYSQL_EMAIL server@server.com
ENV	USER_PASSWORD server
ENV	KEY_PASSWORD server

#Prerequisites
RUN echo "Welcome to my Docker image :)" \
&&	apt-get update \
&&	apt-get upgrade -y \
&&	apt-get install dialog apt-utils sudo vim wget nginx php-fpm lsb-release gnupg -y \
&&	mkdir ${SERVER_DIR}

#MySQL
RUN	wget -q -P ${SERVER_DIR} https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb \
&&	dpkg -i ${SERVER_DIR}/mysql-apt-config_0.8.14-1_all.deb \
&&	apt-get update \
&&	apt-get install mariadb-server mariadb-client php-mysql -y

#Wordpress
RUN	wget -q -P ${SERVER_DIR} https://wordpress.org/latest.tar.gz \
&&	tar -xf ${SERVER_DIR}/latest.tar.gz -C ${SERVER_DIR} \
&&	mkdir /usr/bin/wp \
&&	wget -q -P /usr/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&&	chmod +x /usr/bin/wp/wp-cli.phar

#PHPMyAdmin
RUN	wget -q -P ${SERVER_DIR} https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz \
&&	tar -xf ${SERVER_DIR}/phpMyAdmin-4.9.4-english.tar.gz -C ${SERVER_DIR} \
&&	mv ${SERVER_DIR}/phpMyAdmin-4.9.4-english ${SERVER_DIR}/wordpress/phpmyadmin

#Create user
RUN	useradd ${USER_NAME} \
&&	echo ${USER_NAME}:${USER_PASSWORD} | chpasswd \
&&	usermod -aG sudo ${SERVER_DIR}

#Cleanup & Prepare
RUN	rm ${SERVER_DIR}/phpMyAdmin-4.9.4-english.tar.gz \
&&	rm ${SERVER_DIR}/mysql-apt-config_0.8.14-1_all.deb \
&&	rm ${SERVER_DIR}/latest.tar.gz
COPY ./srcs/default /etc/nginx/sites-enabled/
COPY ./srcs/wp-config.php ${SERVER_DIR}/wordpress/
COPY ./srcs/index.php ${SERVER_DIR}
RUN	chmod -R 755 ${SERVER_DIR} \
&&	chmod -R 777 ${SERVER_DIR}/wordpress/wp-content

USER ${USER_NAME}
EXPOSE 80 443 3306
ENTRYPOINT	echo $USER_PASSWORD | sudo -S service nginx start \
		&&	sudo service php7.3-fpm start \
		&&	sudo service mysql start \
		&&	sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e \
			"CREATE USER '${USER_NAME}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" \
		&&	sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e \
			"CREATE DATABASE ${USER_NAME};" \
		&&	sudo mysql -u root -p${MYSQL_ROOT_PASSWORD} -e \
			"GRANT ALL PRIVILEGES ON ${USER_NAME}.* TO '${USER_NAME}'@'localhost';" \
		&&	php /usr/bin/wp/wp-cli.phar core install \
			--path=/${SERVER_DIR}/wordpress/ \
			--url=localhost \
			--title=${WP_TITLE} \
			--admin_name=${USER_NAME} \
			--admin_password=${MYSQL_ROOT_PASSWORD} \
			--admin_email=${MYSQL_EMAIL} \
		&&	bash