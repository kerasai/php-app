docker build -t app .
docker tag app kerasai/php-app:8.3-apache
docker login
docker push kerasai/php-app:8.3-apache

rm -rf /var/www/html
ln -s /code/web /var/www/html

docker run -d -p 8080:80 --name appserver kerasai/php-app:8.3-apache
docker exec -it appserver bash
docker kill appserver
