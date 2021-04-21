#!/bin/bash

#
# wait for database
#
# function wait_for_database() {
#     printf "Waiting for database server '${ERPNEXT_DBHOST}' to accept connections"
#     prog="mysqladmin -h ${ERPNEXT_DBHOST} -u {{MARIADB_REMOTE_ADMIN_USER}} -p{{MARIADB_REMOTE_ADMIN_PASSWD}} status"
#     timeout=30
#     while ! ${prog} >/dev/null 2>&1
#     do
#         timeout=$(expr $timeout - 1)
#         if [ $timeout -eq 0 ]; then
#             printf "\nCould not connect to database server. Aborting...\n"
#             exit 1
#         fi
#         printf "."
#         sleep 1
#     done
#     echo
# }

function wait_for_database() {
    printf "Waiting for MariaDB to start ..."
    RET=1
    while [[ $RET -ne 0 ]]; do
        printf "."
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done
    printf "Connected\n"
}


SECURE_MYSQL=$(expect -c "
set timeout 10

spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"{{ERPNEXT_MARIADB_ROOT_PASSWD}}\r\"

expect \"Change the root password?\"
send \"n\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

# wait for dbserver to come online
#wait_for_database

# Determine new install or updating
if [[ ${SETUP_MODE} == 'new' ]]; then

    # initialize mariadb
    mysql_install_db --user=mysql > /dev/null
    clog -i "erpnext: Mariadb database engine initialized."

    # start mariadb server
    /usr/bin/mysqld_safe --user mysql > /dev/null 2>&1 &
    # wait for database server coming up
    wait_for_database

    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '{{ERPNEXT_MARIADB_ROOT_PASSWD}}' WITH GRANT OPTION;"
    clog -i "erpnext: Mariadb Grant access to root for localhost only."

    # secure setup database
    # echo ${SECURE_MYSQL}
    # clog -i "erpnext: MariaDB setup secured."

    cd ${APP_DIR}
    sudo -HEu erp /home/erp/.local/bin/bench new-site ${ERPNEXT_SITE_URL} \
        --mariadb-root-password {{ERPNEXT_MARIADB_ROOT_PASSWD}} \
        --admin-password {{ERPNEXT_ADMIN_PASSWD}}

    clog -i "erpnext: Site ${ERPNEXT_SITE_URL} created."

    sudo -HEu erp /home/erp/.local/bin/bench install-app erpnext

    clog -i "erpnext: ERPNext installed."

    # shutdown mariadb to wait for supervisor
    mysqladmin --user=root --password={{ERPNEXT_MARIADB_ROOT_PASSWD}} shutdown
else
    clog -i "erpnext: Persistence storage restored, original db had backup and updated to current version."
fi
