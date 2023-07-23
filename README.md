# LimeSurvey – Extension of Apache Base Image

The LimeSurvey Image is based on our [base Apache with current latest PHP version](https://hub.docker.com/r/devopsansiblede/apache/).

## How to get this container run

Minimal usage is to provide at least mandatory environmental variables from next chapter – so base usage can look like this [given that there is a Docker container `databasecontainer` within the Docker network `internal` and the given user credentials]:

```sh
docker run \
   --rm -d -P \
   --network internal \
   -e DB_HOST=databasecontainer \
   -e DB_NAME=database \
   -e DB_USER=user \
   -e DB_PASS=password \
   -e LIMESURVEY_ADMIN=admin \
   -e LIMESURVEY_ADMIN_PASS='$uper-secur3' \
   -e LIMESURVEY_ADMIN_NAME=Admin \
   -e LIMESURVEY_ADMIN_MAIL='admin@example.net' \
   -e LIMESURVEY_SHOW_SCRIPT_NAME=true \
   devopsansiblede/limesurvey:latest
```

## Environmental Variables

This image is customizable by these environmental variables:

| env                   | default               | mandatory | change recommended | description | comment |
| --------------------- | --------------------- |:---------:|:------------------:| ----------- | --- |
| **RUNTIMEFOLDER** | */var/www/limesurvey* | no | no | folder LimeSurvey puts the runtime files like sessions in |  |
| **DB\_USER** | | yes | yes | database user | |
| **DB\_PASS** | | yes | yes | password for database user **$DB\_USER** | |
| **DB\_NAME** | **$DB\_USER** | no | yes | database the user **$DB\_USER** will work on for LimeSurvey | |
| **DB_HOST** | | yes | yes | host of database **$DB\_NAME** | |
| **DB\_PREFIX** | *"lime\_"* | no | no | prefix for all LimeSurvey-Tables within database | |
| **LIMESURVEY\_ADMIN** | | yes | yes | username for LimeSurvey super admin | |
| **LIMESURVEY\_ADMIN\_PASS** | | yes | yes | password for super admin **$LIMESURVEY\_ADMIN** | |
| **LIMESURVEY\_ADMIN\_NAME** | | yes | yes | real name for super admin **$LIMESURVEY\_ADMIN** | |
| **LIMESURVEY_ADMIN\_MAIL** | | yes | yes | e-mail address for super admin **$LIMESURVEY\_ADMIN** | |
| **LIMESURVEY\_DEFAULT\_LANG** | | no | yes | abbreviation of default language to use | LimeSurvey defaults to `en` |
| **LIMESURVEY\_TITLE** | | no | yes | Title of LimeSurvey instance | defaults to `LimeSurvey` |
| **ADMIN\_THEME\_NAME** | | no | yes | theme name for admin theme to be activated | |
| **DEFAULT\_TEMPLATE** | | no | yes | theme name for survey theme | has to be installed through the admin interface before it can be activated through this setting since there are done complex parsing steps during installation of a theme |
| **LDAP\_SERVER** | | no | yes | ldap server | mandatory for activating ldap configuration; every LDAP variable without default has to be defined – else installation will fail |
| **LDAP\_PORT** | 389 | no | yes | port for ldap connection | |
| **LDAP\_VERSION** | 3 | no | no | ldap version to use | |
| **LDAP\_TLS** | 0 | no | | 0 or 1 – whether TLS should not or should be activated | |
| **LDAP\_SEARCH\_USER\_ATTRIBUTE** | *uid* | no | | search attribute for users | |
| **LDAP\_USER\_PREFIX** | '' | no | | set userprefix for ldap binds | |
| **LDAP\_USER\_SUFFIX** | '' | no | | set usersuffix for ldap binds | |
| **LDAP\_USER\_SEARCH\_BASE** | *ou=people,dc=example,dc=com* | no | yes | ldap search base | |
| **LDAP\_BIND\_DN** | *cn=admin,dc=example,dc=com* | no | yes | ldap user / authority to check binds | |
| **LDAP\_BIND\_PASS** | | no | yes | password for ldap user / authority **$LDAP\_BIND\_DN** | |
| **LDAP\_MAIL\_ATTRIBUTE** | *mail* | no | | ldap attribute for logged in users to be fetched as `mail` attribute to LimeSurvey | |
| **LDAP\_FULLNAME\_ATTRIBUTE** | *displayName* | no | | ldap attribute interpreted as `fullname` for logged in users in LimeSurvey | |
| **LDAP\_IS\_DEFAULT** | 1 | no | yes | 1 or 0 – whether ldap login should or not be default login method | |
| **LDAP\_AUTOCREATE** | 1 | no | yes | 1 or 0 – whether login through ldap should create LimeSurvey user | |
| **LDAP\_ALLOW\_CREATION\_TO\_LOGGEDIN** | '' | no | yes | | |
| **LDAP\_GROUP\_SEARCH\_BASE** | *ou=groups,dc=example,dc=com* | no | yes | in which searchbase LimeSurvey should search for groups? | |
| **LDAP\_GROUP\_NAME** | *limesurvey* | no | yes | group name an user should belong to for a successful login to LimeSurvey | |

From Apache image it got these environmental variables for further usage:

| env                   | default               | mandatory | change recommended | description | comment |
| --------------------- | --------------------- |:---------:|:------------------:| ----------- | --- |
| **PHP_TIMEZONE**      | *"Europe/Berlin"*     | no | yes                | timezone-file to use as default – can be one value selected out of `/usr/share/zoneinfo/`, i.e. `<region>/<city>` |  |
| **APACHE\_WORKDIR**   | */var/www/html*       | no | no                | home folder of apache web application | installation directory for auto installation of LimeSurvey during build process of the image |
| **APACHE\_LOG\_DIR**  | */var/log/apache2*    | no | yes                | folder for log files of apache |  |
| **APACHE\_PUBLIC\_DIR** | **$APACHE\_WORKDIR** | no | yes               | folder used within apache configuration to be published – can be usefull if i.e. subfolder `public` of webproject should be exposed |  |
| **PHP_XDEBUG**        | *0*                   | no | yes                | You can use this to enable xdebug. start-apache2 script will enable xdebug if **PHP_XDEBUG** is set to *1* |  |
| **YESWWW**            | false                 | no | yes                | Duplicate content has to be avoided – therefore a decision for containers delivering content of `www.domain.tld` and `domain.tld` has to be made which one should be the mainly used one. **YESWWW** will be overridden by **NOWWW** if both are true. |  |
| **NOWWW**             | false                 | no | yes                | See **YESWWW** |  |
| **HTTPS**             | true                  | no | yes                | relevant for **YESWWW** and **NOWWW** since config rules have to be adjusted. |  |
| **SMTP\_HOST**        |                       | no | yes                |  | should be set to your smtp host, i.e. `mail.example.com` |  |
| **SMTP\_PORT**        |                       | no | yes                |  | defaults to `587` |  |
| **SMTP\_FROM**        |                       | no | yes                |  | should be set to your sending from address, i.e. `motiontool@example.com` |  |
| **SMTP\_USER**        |                       | no | yes                |  | defaults to `SMTP_FROM` and has to be the user, you are authenticating on the **SMTP_HOST** |  |
| **SMTP\_PASS**        |                       | no | yes                |  | should be set to your plaintext(!) smtp password, i.e. `I'am very Secr3t!` |  |
| **WORKINGUSER**       | *www-data*            | no | no                 | user that works as apache user – not implemented changable |  |
| **TERM**              | *xterm*               | no | no                 | set terminal type – default *xterm* provides 16 colors |  |
| **DEBIAN\_FRONTEND**  | *noninteractive*      | no | no                 | set frontent to use – default self-explaining  |  |


## Installed Tools

| tool(s)                      | description |
| ---------------------------- | ----------- |
| **software-properties-common**, **procps** | simplify further installations |
| **python-setuptools**, **python-pip**, **python-pkg-resources** | simplify python installations |
| **python-jinja2**, **j2cli** | used for template provisioning |
| **python-yaml**, **python-paramiko** | provision Image for further provisioning via Ansible | **vim**, **nano**            | editors |
| **python-httplib2**            | Small, fast HTTP client library for Python |
| **python-keyczar**             | Toolkit for safe and simple cryptography |
| **htop**, **tree**, **tmux**, **screen**, **sudo**, **git**, **zsh**, **ssh**, **screen** | usefull ops tools – oh-my-zsh is installed further|
| **supervisor**               | process manager that allows to manage long-running programs |
| **gnupg**, **openssl**       | encryption tools |
| **curl**, **wget**           | fetch remote content |
| **mysql-client**, **libpq-dev**, **postgresql-client**, **sqlite3**, **libsqlite3-dev** | install database things – except of SQLite3 no real database is installed since full databases should run at least on a separate container |
| **libkrb5-dev**, **libc-client-dev** | devtools especially for email |
| **zlib1g-dev**               | compression library |
| **libfreetype6-dev**, **libjpeg62-turbo-dev**, **libmcrypt-dev**, **libpng-dev** | simplify working with and on images |
| **nodejs**                   | javascript development tools |
| **composer**                 | php package manager |
| **msmtp**, **msmtp-mta**     | simple and easy to use SMTP client replacing sendmail |

## PHP Libraries installed

**imap**, **pdo**, **pdo_mysql**, **imap**, **zip**, **gd**, **exif**, **mcrypt**

## PHP Modules enabled

**rewrite**

## Files to be aware of

### `/templates/apache.j2` – the Apache Config

The apache config used within containers of this image. It will be provisioned at every start of the container – so you should consider to mount a new template instead of mounting a default apache config directly.

<details>
 <summary>Full Template</summary>

```jinja2
<VirtualHost *:80>

    ServerAdmin root
    DocumentRoot {{ APACHE_PUBLIC_DIR | default(APACHE_WORKDIR) }}

    <Directory {{ APACHE_PUBLIC_DIR | default(APACHE_WORKDIR) }}/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order deny,allow
        Allow from all
    </Directory>

    AccessFileName .htaccess
	<FilesMatch "^\.ht">
		Require all denied
	</FilesMatch>

    LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
	LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
	LogFormat "%h %l %u %t \"%r\" %>s %O" common
	LogFormat "%{Referer}i -> %U" referer
	LogFormat "%{User-agent}i" agent

    CustomLog /proc/self/fd/1 combined

    <FilesMatch \.php$>
		SetHandler application/x-httpd-php
	</FilesMatch>

    ErrorLog {{ APACHE_LOG_DIR }}/error.log
    CustomLog {{ APACHE_LOG_DIR }}/access.log combined

    # Multiple DirectoryIndex directives within the same context will add
	# to the list of resources to look for rather than replace
	# https://httpd.apache.org/docs/current/mod/mod_dir.html#directoryindex
	DirectoryIndex disabled
	DirectoryIndex index.php index.html

</VirtualHost>
```
</details>

## last built

2023-07-23 23:22:32
