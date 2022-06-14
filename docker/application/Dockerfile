FROM ubuntu:20.04

RUN adduser wordpress

RUN apt update
RUN apt install -y php-fpm nginx supervisor unzip wget

RUN wget https://uk.wordpress.org/latest-uk.zip
RUN unzip latest-uk.zip

RUN mkdir -p /var/www/wordpress && cp -r wordpress/ /var/www/wordpress && ls -la /var/www && chown -R wordpress:wordpress /var/www/wordpress

COPY ./configs/wp-config.php /var/www/wordpress/wp-config.php
COPY ./configs/wordpress.conf /etc/php/7.4/fpm/pool.d/wordpress.conf
COPY ./configs/nginx.conf /etc/nginx/sites-available/default
COPY ./configs/supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
EXPOSE 80