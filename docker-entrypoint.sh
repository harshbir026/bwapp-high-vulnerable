#!/bin/bash
set -e

PORT="${PORT:-80}"

sed -i "s/^Listen .*/Listen ${PORT}/" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/" /etc/apache2/sites-available/000-default.conf

mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld
chmod 777 /var/run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql >/tmp/mysql-install.log
fi

mysqld_safe --datadir=/var/lib/mysql --bind-address=127.0.0.1 >/tmp/mysql.log 2>&1 &

for _ in $(seq 1 60); do
    if mysqladmin --protocol=socket -u root ping --silent; then
        break
    fi
    sleep 1
done

mysql --protocol=socket -u root <<'SQL'
GRANT ALL PRIVILEGES ON *.* TO 'bwapp'@'127.0.0.1' IDENTIFIED BY 'bug' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SQL

if ! mysql --protocol=tcp -h 127.0.0.1 -u bwapp -pbug -Nse "SHOW DATABASES LIKE 'bWAPP'" | grep -q bWAPP; then
    php -r '$_REQUEST["install"]="yes"; include "/var/www/html/install.php";' >/tmp/bwapp-install.html
fi

exec apachectl -D FOREGROUND
