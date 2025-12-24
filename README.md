docker build -t app .
docker tag app kerasai/php-app:8.3-apache
docker login
docker push kerasai/php-app:8.3-apache

rm -rf /var/www/html
ln -s /code/web /var/www/html
