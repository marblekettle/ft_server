FROM debian:buster

RUN echo "Welcome to my Docker image :)"
RUN apt-get update
# RUN apt-get install wget -y
RUN apt-get install nginx -y
RUN update-rc.d nginx defaults
# RUN apt-get install lsb-release -y
# RUN apt-get install gnupg -y
# RUN ip addr show eth0

# RUN cd root
# RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb
# RUN dpkg -i mysql-apt-config_0.8.14-1_all.deb
# RUN apt-get update
# RUN apt-get install mysql-server

EXPOSE 80
ENTRYPOINT service nginx start && bash