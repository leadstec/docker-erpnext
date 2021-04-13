#!/bin/bash

#
# wait for database
#
function wait_for_database() {
    printf "Waiting for database server '${ERPNEXT_DBHOST}' to accept connections"
    prog="mysqladmin -h ${ERPNEXT_DBHOST} -u {{MARIADB_REMOTE_ADMIN_USER}} -p{{MARIADB_REMOTE_ADMIN_PASSWD}} status"
    timeout=60
    while ! ${prog} >/dev/null 2>&1
    do
        timeout=$(expr $timeout - 1)
        if [ $timeout -eq 0 ]; then
            printf "\nCould not connect to database server. Aborting...\n"
            exit 1
        fi
        printf "."
        sleep 1
    done
    echo
}

# wait for dbserver to come online
wait_for_database

# Determine new install or updating
if [[ ${SETUP_MODE} == 'new' ]]; then

    export PATH=/home/erp/.local/bin/:${PATH}

    cd ${APP_DIR}
    sudo -HEu erp bench new-site ${ERPNEXT_SITE_URL} --db-host ${ERPNEXT_DBHOST} \
        --mariadb-root-username {{MARIADB_REMOTE_ADMIN_USER}} --mariadb-root-password {{MARIADB_REMOTE_ADMIN_PASSWD}} \
        --admin-password {{ERPNEXT_ADMIN_PASSWD}}

    clog -i "erpnext: Site ${ERPNEXT_SITE_URL} created."

    sudo -HEu erp bench install-app erpnext

    clog -i "erpnext: ERPNext installed."
else
    clog -i "erpnext: Persistence storage restored, original db had backup and updated to current version."
fi
