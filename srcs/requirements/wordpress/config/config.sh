#!/bin/sh

# wait mariadb to be ready

while ! mariadb -h$MYSQL_HOST -u$WP_DATABASE_USR -p$WP_DATABASE_PWD $WP_DATABASE_NAME &> /dev/null 2>&1; do
	sleep 3
done

# install wordpress

if [ ! -f "/var/www/html/index.html" ]; then
	# static website
	mv /tmp/index.html /var/www/html/index.html

	# setup adminer

	# wordpress
	wp core download --allow-root
	wp config create --dbname=$WP_DATABASE_NAME --dbuser=$WP_DATABASE_USR --dbpass=$WP_DATABASE_PWD --dbhost=$MYSQL_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
	wp core install --url=$DOMAIN_NAME/wordpress --title=$WP_TITLE --admin_user=$WP_ADMIN_USR --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
	wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root
	# wp theme install inspiro --activate --allow-root
	wp theme install hello-elementor --activate --allow-root

	# add redis
fi

/usr/sbin/php-fpm7 -F -R
