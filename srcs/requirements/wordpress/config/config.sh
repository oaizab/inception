#!/bin/sh

# wait mariadb to be ready

while ! mariadb -h$MYSQL_HOST -u$WP_DATABASE_USR -p$WP_DATABASE_PWD $WP_DATABASE_NAME &> /dev/null 2>&1; do
	sleep 3
done

# install wordpress

if [ ! -f "/var/www/html/index.html" ]; then
	# static website
	mv /tmp/index.html /var/www/html/index.html
	mv /tmp/style.css /var/www/html/style.css

	# setup adminer
	wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql-en.php -O /var/www/html/adminer.php &> /dev/null
    wget https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css -O /var/www/html/adminer.css &> /dev/null

	# wordpress
	wp core download --allow-root
	wp config create --dbname=$WP_DATABASE_NAME --dbuser=$WP_DATABASE_USR --dbpass=$WP_DATABASE_PWD --dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --url=$DOMAIN_NAME/wordpress --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
	wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
	# wp theme install inspiro --activate --allow-root
	# wp theme install hello-elementor --activate --allow-root

	# add redis
	sed -i "40i define( 'WP_REDIS_HOST', '$REDIS_HOST' );" /var/www/html/wordpress/wp-config.php
	sed -i "41i define( 'WP_REDIS_PORT', 6379 );" /var/www/html/wordpress/wp-config.php
	sed -i "42i define( 'WP_REDIS_TIMEOUT', 1 );" /var/www/html/wordpress/wp-config.php
	sed -i "43i define( 'WP_REDIS_READ_TIMEOUT', 1 );" /var/www/html/wordpress/wp-config.php
	sed -i "44i define( 'WP_REDIS_DATABASE', 0 );" /var/www/html/wordpress/wp-config.php

	wp plugin install redis-cache --activate --allow-root
	wp plugin update --all --allow-root

fi

wp redis enable --allow-root

/usr/sbin/php-fpm7 -F -R
