# icinga2-docker

This repository contains a (quasi-)modular image of the Icinga2 monitor systems, orchestrated by docker-compose.

It is slightly based on the original Dockerfile by [https://github.com/jjethwa/icinga2] (Jordan Jethwa's icinga2 docker image), which is also available as a dockerhub-repository is located at [https://hub.docker.com/r/jordan/icinga2/](https://hub.docker.com/r/jordan/icinga2/).



## Image details

1. Features four containers:
   - core: the icinga2 system, plus the ssmtp facility
   - web: icingaweb2, the web-based, eye-candy gui, plus pnp4nagios
   - sql: library/mariadb (no modification, no dockerfile, just as-is)
   - snmptrap: an snmptrap system based on snmptt, snmptrapd
   
1. Based on debian:jessie-slim (core, snmptrap) and debian:stretch-slim (web)

1. Key-Features:
   - icinga2
   - icingacli
   - icingaweb2
   - icingaweb2-pnp4nagios module
   - ssmtp
   - MariaDB
   - Supervisor
   - Apache2
   - SSL Support
   - pnp4nagios
   - a bunch of special plugins for monitoring ups, printer and temp sensor (via SNMP)
1. No SSH. Use docker [exec](https://docs.docker.com/engine/reference/commandline/exec/) or [nsenter](https://github.com/jpetazzo/nsenter)

1. If passwords are not supplied, they will be randomly generated and shown via stdout.

## Usage

Images are not (yet) available on docker hub, sorry!

However, just clone this repository, set variables in secrets.env and .env and build the image with:

    docker-compose build

then start the four containers:

    docker-compose up

et voilà, you are set! You will find:

	- icinga2 running on port 5665;
        - icingaweb running on port 80;
        - snmptrap running on port 162

## Volume Reference

The directives in docker-compose.yaml create a series of directories in the ${FIRSTNAME}/ directory located into icinga2-docker directory; this ensures the portability of configuration and data through different versions of container.

In order to get a full clean system, just remove the ${FIRSTNAME}/ (or just parts of it) before running new containers.


| Volume | ro/rw | Description & Usage |
| ------ | ----- | ------------------- |
| /etc/apache2/ssl | **ro** | Mount optional SSL-Certificates (see SSL Support) |
| /etc/ssmtp/revaliases | **ro** | revaliases map (see Sending Notification Mails) |
| /etc/ssmtp/ssmtp.conf | **ro** | ssmtp configufation (see Sending Notification Mails) |
| /etc/icinga2 | rw | Icinga2 configuration folder |
| /etc/icingaweb2 | rw | Icingaweb2 configuration folder |
| /var/lib/mysql | rw | MySQL Database |
| /var/lib/icinga2 | rw | Icinga2 Data |
| /var/lib/php5/sessions/ | rw | Icingaweb2 PHP Session Files |
| /usr/lib/nagios/plugins | rw | nagios plugins' directory |
| /var/log/apache2 | rw | logfolder for apache2 (not neccessary) |
| /var/log/icinga2 | rw | logfolder for icinga2 (not neccessary) |
| /var/log/icingaweb2 | rw | logfolder for icingaweb2 (not neccessary) |
| /var/log/mysql | rw | logfolder for mysql (not neccessary) |
| /var/log/supervisor | rw | logfolder for supervisord (not neccessary) |
| /var/spool/icinga2 | rw | spool-folder for icinga2 (not neccessary) |
| /var/cache/icinga2 | rw | cache-folder for icinga2 (not neccessary) |

## Icinga Web 2

Icinga Web 2 can be accessed at [http://localhost/icingaweb2](http://localhost/icingaweb2) with the credentials *icingaadmin*:*icinga* (if not set differently via variables).

# Sending Notification Mails

The core container has `ssmtp` installed, which forwards mails to a preconfigured static server.

You have to create the files `ssmtp.conf` for general configuration and `revaliases` (mapping from local Unix-user to mail-address).

```
# ssmtp.conf
root=<E-Mail address to use on>
mailhub=smtp.<YOUR_MAILBOX>:587
UseSTARTTLS=YES
AuthUser=<Username for authentication (mostly the complete e-Mail-address)>
AuthPass=<YOUR_PASSWORD>
FromLineOverride=NO
```
**But be careful, ssmtp is not able to process special chars within the password correctly!**

`revaliases` follows the format: `Unix-user:e-Mail-address:server`.
Therefore the e-Mail-address has to match the `root`'s value in `ssmtp.conf`
Also server has to match mailhub from `ssmtp.conf` **but without the port**.

```
# revaliases
root:<VALUE_FROM_ROOT>:smtp.<YOUR_MAILBOX>
nagios:<VALUE_FROM_ROOT>:smtp.<YOUR_MAILBOX>
www-data:<VALUE_FROM_ROOT>:smtp.<YOUR_MAILBOX>
```

These files have to get mounted into the container. Add these flags to your `docker run`-command:
```
-v $(pwd)/revaliases:/etc/ssmtp/revaliases:ro
-v $(pwd)/ssmtp.conf:/etc/ssmtp/ssmtp.conf:ro
```

If you want to change the display-name of sender-address, you have to define the variable `ICINGA2_USER_FULLNAME`.

If this does not work, please ask your provider for the correct mail-settings or consider the [ssmtp.conf(5)-manpage](https://linux.die.net/man/5/ssmtp.conf) or Section ["Reverse Aliases" on ssmtp(8)](https://linux.die.net/man/8/ssmtp).
Also you can debug your config, by executing inside your container `ssmtp -v $address` and pressing 2x Enter.
It will send an e-Mail to `$address` and give verbose log and all error-messages.

# Adding own modules

To use your own modules, you're able to install these into `enabledModules`-folder of your `/etc/icingaweb2` volume.

## Environment variables Reference

| Environmental Variable | Default Value | Description |
| ---------------------- | ------------- | ----------- |
| `ICINGA_PASSWORD` | *randomly generated* | MySQL password for icinga |
| `ICINGAWEB2_PASSWORD` | *randomly generated* | MySQL password for icingaweb2 |
| `DIRECTOR_PASSWORD` | *randomly generated* | MySQL password for icinga director |
| `IDO_PASSWORD` | *randomly generated* | MySQL password for ido |
| `DEBIAN_SYS_MAINT_PASSWORD` | *randomly generated* | Password for debian-syst-maint account |
| `ICINGA2_FEATURE_GRAPHITE` | false | Set to true or 1 to enable graphite writer |
| `ICINGA2_FEATURE_GRAPHITE_HOST` | graphite | hostname or IP address where Carbon/Graphite daemon is running |
| `ICINGA2_FEATURE_GRAPHITE_PORT` | 2003 | Carbon port for graphite |
| `ICINGA2_FEATURE_GRAPHITE_URL` | http://${ICINGA2_FEATURE_GRAPHITE_HOST} | Web-URL for Graphite |
| `ICINGA2_FEATURE_DIRECTOR` | true | Set to false or 0 to disable icingaweb2 director |
| `DIRECTOR_KICKSTART` | true | Set to false to disable icingaweb2 director's auto kickstart at container startup. *Value is only used, if icingaweb2 director is enabled.* |
| `ICINGAWEB2_ADMIN_USER` | icingaadmin | Icingaweb2 Login User<br>*After changing the username, you should also remove the old User in icingaweb2-> Configuration-> Authentication-> Users* |
| `ICINGAWEB2_ADMIN_PASS` | icinga | Icingaweb2 Login Password |
| `ICINGA2_USER_FULLNAME` | Icinga | Sender's display-name for notification e-Mails |
| `APACHE2_HTTP` | `REDIRECT` | **Variable is only active, if both SSL-certificate and SSL-key are in place.** `BOTH`: Allow HTTP and https connections simulateously. `REDIRECT`: Rewrite HTTP-requests to HTTPS |


