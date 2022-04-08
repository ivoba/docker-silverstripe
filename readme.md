# Dev Docker setup for SilverStripe
Dev Docker setup for SilverStripe projects i use for development.

What does it bring?

- PHP 8.1 + Xdebug
- Mysql 5.7 (Older version because of shared hosting limits)
- Apache 2.4 (Also due to shared hosting limits)
- PHPMyAdmin for DB administration
- Mailcatcher for testing emails
- Zsh in container
- UserID handling to avoid permission issues when processes in the container 
  (the shell script will adjust www-data in the container to your userID on the host, so it will be the same as on the host)


## Usage

1. Copy the docker folder to your SilverStripe project.
2. Adjust replace `silverstripe_project.php` with your SilverStripe project name.
3. Ajust `git config`section in docker.sh with your creds.
4. Adjust `containerName` in docker.sh with your container name.
5. In Terminal change directory to the docker folder.
6. Run `./docker.sh -l` to start the containers. You will logged in into the php docker container
7. Inside the php container you can run `composer install` or any other console tasks like `vendor/bin/sake dev/build`.
8. In browser go to http://localhost:8089 and should see the SilverStripe site.
