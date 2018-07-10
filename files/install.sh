#!/bin/bash

# create runtime folder that should not be accessible on the frontend
if [ ! -d "$RUNTIMEFOLDER" ]; then
    mkdir "$RUNTIMEFOLDER"
    chown -R "$WORKINGUSER" "$RUNTIMEFOLDER"
fi

abort=false
if [ ! -f application/config/config.php ]; then
    # do not proceed if already installed
    install="true"
fi

# set default values for non-mandatory variables that are not only used in Jinja2 environment
if [ -z ${DB_NAME+x} ]; then DB_NAME="$DB_USER"; export DB_NAME; fi
if [ -z ${DB_PREFIX+x} ]; then DB_PREFIX="lime_"; export DB_PREFIX; fi

# provision and write out config file
j2 /templates/limesurvey_config.php.j2 > application/config/config.php

# since all mysql requests have a big part in common, this function improves the readability
mysqlrequest () {
    # echo "$1" >> /tmp/sql.log # helper file for debugging
    mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e "$1"
}

# check if LimeSurvey already has a config file – and so would already be installed
if [ "$install" == "true" ]; then
    # install LimeSurvey with provided admin user data
    cd application/commands
    php console.php install "$LIMESURVEY_ADMIN" "$LIMESURVEY_ADMIN_PASS" "$LIMESURVEY_ADMIN_NAME" "$LIMESURVEY_ADMIN_MAIL"

fi

# do LDAP-things if configured by environmental variables
if [ ! -z ${LDAP_SERVER+x} ]; then

    # the query to determine the ldap plugin id is used a few times
    LDAP_PLUGIN_ID_SQL="SELECT \`id\` FROM \`${DB_PREFIX}plugins\` WHERE \`name\` = 'AuthLDAP';"
    LDAP_PLUGIN_ID=$(mysqlrequest "$LDAP_PLUGIN_ID_SQL")

    # the mysql command returns a string with an empty line if no result is found
    # or a string with `id` in the first and the found value in the second line else
    if [ $(echo "${LDAP_PLUGIN_ID}" | wc -l) -gt 1 ]; then
        # if plugin is already present just update the `active` flag
        mysqlrequest "UPDATE \`${DB_PREFIX}plugins\` SET  \`active\` = 1 WHERE \`name\` = 'AuthLDAP';"
    else
        # insert the plugin, activate it and reinvestigate the plugin id
        mysqlrequest "INSERT INTO \`${DB_PREFIX}plugins\` (\`name\`, \`active\`) VALUES ('AuthLDAP', 1);"
        LDAP_PLUGIN_ID=$(mysqlrequest "$LDAP_PLUGIN_ID_SQL")
    fi
    # only the integer id is usefull further ... so remove the first useless line
    LDAP_PLUGIN_ID=$(echo "$LDAP_PLUGIN_ID" | sed -n 2p)
    export LDAP_PLUGIN_ID

    # provision SQL script that configures LDAP and push it to the database
    j2 /templates/limesurvey_ldap.sql.j2 > /tmp/limesurvey_ldap.sql
    mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" < /tmp/limesurvey_ldap.sql

fi

if [ ! -z ${ADMIN_THEME_NAME+x} ]; then

    # the query to determine the ldap plugin id is used a few times
    ADMIN_THEME_VAL_SQL="SELECT \`stg_value\` FROM \`${DB_PREFIX}settings_global\` WHERE \`stg_name\` = 'admintheme';"
    ADMIN_THEME_VAL=$(mysqlrequest "$ADMIN_THEME_VAL_SQL")

    # the mysql command returns a string with an empty line if no result is found
    # or a string with `id` in the first and the found value in the second line else
    if [ $(echo "${ADMIN_THEME_VAL}" | wc -l) -gt 1 ]; then
        # if Admin theme is already present just update it
        mysqlrequest "UPDATE \`${DB_PREFIX}settings_global\` SET  \`stg_value\` = '${ADMIN_THEME_NAME}' WHERE \`stg_name\` = 'admintheme';"
    else
        # activate given Admin theme
        mysqlrequest "INSERT INTO \`${DB_PREFIX}settings_global\` (\`stg_name\`, \`stg_value\`) VALUES ('admintheme', '${ADMIN_THEME_NAME}');"
    fi

fi

if [ ! -z ${LIMESURVEY_TITLE+x} ]; then

    # the query to determine the ldap plugin id is used a few times
    LIMESURVEY_TITLE_VAL_SQL="SELECT \`stg_value\` FROM \`${DB_PREFIX}settings_global\` WHERE \`stg_name\` = 'sitename';"
    LIMESURVEY_TITLE_VAL=$(mysqlrequest "$LIMESURVEY_TITLE_VAL_SQL")

    # the mysql command returns a string with an empty line if no result is found
    # or a string with `id` in the first and the found value in the second line else
    if [ $(echo "${LIMESURVEY_TITLE_VAL}" | wc -l) -gt 1 ]; then
        # if Admin theme is already present just update it
        mysqlrequest "UPDATE \`${DB_PREFIX}settings_global\` SET  \`stg_value\` = '${LIMESURVEY_TITLE}' WHERE \`stg_name\` = 'sitename';"
    else
        # activate given Admin theme
        mysqlrequest "INSERT INTO \`${DB_PREFIX}settings_global\` (\`stg_name\`, \`stg_value\`) VALUES ('sitename', '${LIMESURVEY_TITLE}');"
    fi

fi
