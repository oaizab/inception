#!/bin/sh

if [ ! -d /run/mysqld ]; then
	mkdir -p /run/mysqld
	chown -R mysql /run/mysqld
fi

if [ ! -d /var/lib/mysql/mysql ]; then
	chown -R mysql:mysql /var/lib/mysql

	#install mariadb
	mysql_install_db --basedir=/usr --user=mysql --datadir=/var/lib/mysql --rpm > /dev/null

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM	mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';

CREATE DATABASE $WP_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$WP_DATABASE_USR'@'%' IDENTIFIED by '$WP_DATABASE_PWD';
GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO '$WP_DATABASE_USR'@'%';

FLUSH PRIVILEGES;
EOF
	# initialize database
	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	rm -f $tfile
fi

# disabling hostname search
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

# allow external connections
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# run mariadb
/usr/bin/mysqld --user=mysql --console
