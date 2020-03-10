# ft_server
Yippee kye-aye, mother Docker

This Dockerfile installs a blank Debian Buster image running Nginx, MySQL, PHPMyAdmin and Wordpress. Connection supports http (port 80) and https (port 443).

Passed on 10/3/2020 with 100 pts.

Disclaimer: For educational/experimental purposes ONLY! This image is not suitable for commercial use as it lacks necessary security measures. Use at your own risk.

To do:
- Allow PHPMyAdmin to connect to MySQL through SSL.
- Redirect sensitive pages (wp-login.php, phpmyadmin/index.php) to https.
- Make it easier to configure autoindex.
