FROM debian:buster

ENV CSR_COUNTRY 	"NL"
ENV CSR_STATE		"Noord Holland"
ENV CSR_LOCATION	"Amsterdam"
ENV	CSR_ORGANIZAT	"Codam Coding College"

#Change these
ENV	WP_TITLE		"The Blog of an Unrecognized Genius"
ENV SERVER_DIR		server
ENV SERVER_DATABASE	where_to_put_mysql_stuff
ENV USER_NAME		admin
ENV	MYSQL_PASSWORD	moulinette
ENV MYSQL_EMAIL		bmans@student.codam.nl
#DEFINITELY change this
ENV	USER_PASSWORD	1234

#Prerequisites
RUN echo "Welcome to my Docker image :)" \
&&	apt-get update \
&&	apt-get upgrade -y \
&&	apt-get install dialog apt-utils sudo vim wget nginx php-fpm php-mbstring \
	lsb-release gnupg mariadb-server mariadb-client php-mysql -y \
&&	mkdir ${SERVER_DIR}

#SSL certificate
RUN	openssl req -x509 -nodes -new -out /cert.crt -keyout /cert.key -subj \
	"/C=${CSR_COUNTRY}/ST=${CSR_STATE}/L=${CSR_LOCATION}/O=${CSR_ORGANIZAT}"

#Wordpress
RUN	wget -q -P ${SERVER_DIR} https://wordpress.org/latest.tar.gz \
&&	tar -xf ${SERVER_DIR}/latest.tar.gz -C ${SERVER_DIR} \
&&	mkdir /usr/bin/wp \
&&	wget -q -P /usr/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&&	chmod +x /usr/bin/wp/wp-cli.phar \
&&	rm ${SERVER_DIR}/latest.tar.gz

#PHPMyAdmin
RUN	wget -q -P ${SERVER_DIR} https://files.phpmyadmin.net/phpMyAdmin/4.9.4/phpMyAdmin-4.9.4-english.tar.gz \
&&	tar -xf ${SERVER_DIR}/phpMyAdmin-4.9.4-english.tar.gz -C ${SERVER_DIR} \
&&	mv ${SERVER_DIR}/phpMyAdmin-4.9.4-english ${SERVER_DIR}/wordpress/phpmyadmin \
&&	mkdir ${SERVER_DIR}/wordpress/phpmyadmin/tmp \
&&	rm ${SERVER_DIR}/phpMyAdmin-4.9.4-english.tar.gz

#Create user & permissions
RUN	useradd ${USER_NAME} \
&&	echo ${USER_NAME}:${USER_PASSWORD} | chpasswd \
&&	usermod -aG sudo ${USER_NAME} \
&&	chmod -R 755 ${SERVER_DIR} \
&&	chmod -R 777 ${SERVER_DIR}/wordpress/wp-content \
&&	chmod -R 777 ${SERVER_DIR}/wordpress/phpmyadmin/tmp

#Copy config files
COPY ./srcs/default /etc/nginx/sites-enabled/
COPY ./srcs/wp-config.php ${SERVER_DIR}/wordpress/
COPY ./srcs/config.inc.php ${SERVER_DIR}/wordpress/phpmyadmin

USER ${USER_NAME}
EXPOSE 80 443 3306
ENTRYPOINT	echo $USER_PASSWORD | sudo -S service nginx start \
		&&	sudo service php7.3-fpm start \
		&&	sudo service mysql start \
		&&	sudo mysql -u root -p${MYSQL_PASSWORD} \
			< ${SERVER_DIR}/wordpress/phpmyadmin/sql/create_tables.sql \
		&&	sudo mysql -u root -p${MYSQL_PASSWORD} -e \
			"CREATE USER '${USER_NAME}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" \
		&&	sudo mysql -u root -p${MYSQL_PASSWORD} -e \
			"CREATE DATABASE ${SERVER_DATABASE};" \
		&&	sudo mysql -u root -p${MYSQL_PASSWORD} -e \
			"GRANT ALL PRIVILEGES ON ${SERVER_DATABASE}.* TO '${USER_NAME}'@'localhost';" \
		&&	sudo mysql -u root -p${MYSQL_PASSWORD} -e \
			"GRANT ALL PRIVILEGES ON phpmyadmin.* TO '${USER_NAME}'@'localhost' WITH GRANT OPTION;" \
		&&	php /usr/bin/wp/wp-cli.phar core install \
			--path=/${SERVER_DIR}/wordpress/ \
			--url=localhost \
			--title="${WP_TITLE}" \
			--admin_name=${USER_NAME} \
			--admin_password="${MYSQL_PASSWORD}" \
			--admin_email=${MYSQL_EMAIL} \
		&&	sudo tail -f /dev/null
