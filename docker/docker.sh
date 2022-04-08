#!/usr/bin/env bash

IDA_RSA_FILE_PATH="${HOME}/.ssh/id_rsa"

if  [ ! -e $IDA_RSA_FILE_PATH ];
    then echo "key file "$IDA_RSA_FILE_PATH" did not exist, please specify correct file path."; exit;
fi

echo "using $IDA_RSA_FILE_PATH as key file"

upOption=""
login=false
optspec=":ld"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        l)
             echo "->Login after start up" >&2
             login=true
             upOption="-d"
            ;;
    esac
    case "${optchar}" in
        d)
             echo "->Start up to background" >&2
             upOption="-d"
            ;;
    esac
done

containerName="silverstripe_project"

##Update Apache UID
uid=$(id -u)
if [ $uid -gt 100000 ]; then
	uid=1000
fi

sed "s/\$USER_ID/$uid/g" ./apache_php81/Dockerfile.dist > ./apache_php81/Dockerfile

if [ ! -e ./docker-env ]; then
    cp ./docker-env.dist ./docker-env
fi

##build and launch containers
docker-compose build
docker-compose up $upOption

# setup ssh
docker exec -it $containerName mkdir -p /var/www/.ssh
docker cp --follow-link $IDA_RSA_FILE_PATH $containerName:/var/www/.ssh/id_rsa
docker cp --follow-link ~/.ssh/known_hosts $containerName:/var/www/.ssh/known_hosts

# git config
docker exec $containerName git config --global user.email "ivo.bathke@gmail.com"
docker exec $containerName git config --global user.name "Ivo bathke"

##make ssh files accessable for www-data
docker exec -it $containerName chown -R www-data:www-data /var/www/.ssh

##composer selfupdate
docker exec -it $containerName composer selfupdate

if [ $login = true ]; then
	docker exec -it -u www-data $containerName zsh
	docker-compose stop
fi
