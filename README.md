# IRIS-Systems_Recruitment2023

For running multi container apps, docker compose is used as we can make the necessary configurations by writing a yaml file and then we can start the app by just running docker compose up.
All the services defined in docker-compose.yml file are in the same network. So, they'll be able to communicate with each other and the network is created by docker itself.

The docker-compose.yml file which I used is:version: '3.9'
```yaml
services:
  db:
    image: mysql
    container_name: mysql
    restart: always
    volumes:
      - mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: src_development
      MYSQL_PASSWORD: password
    ports:
      - '3306:3306'
  web: &web
    container_name: app
    build:
      context: .
      dockerfile: Dockerfile
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    ports:
      - '8080:3000'
    depends_on:
      - db
    links:
      - db
  app2:
    <<: *web
    container_name: app2
    ports:
      - '8081:3000'
  app3:
    <<: *web
    ports:
      - '8082:3000'
    container_name: app3
  nginx:
    image: nginx
    container_name: nginx
    restart: unless-stopped
    build:
      context: .
      dockerfile: Dockerfile.nginx
    volumes: 
      - conf-data:/etc/nginx/
    ports:
      - '80:80'
      - '443:443'
    links:
      - web
volumes:
  mysql-data:
  conf-data:
```
Here, there are five services namely app, app2, app3, nginx and mysql and there are two volumes namely mysql-data and conf-data.
The Dockerfile for app is:
```Dockerfile
FROM ruby:3.0.5
RUN apt-get update && apt-get install -y default-mysql-client && apt-get install -y nano
RUN mkdir /rails-app
WORKDIR /rails-app
COPY ./src/ /rails-app
RUN bundle install
CMD ["bundle", "exec"]
```
The dockerfile for nginx is:
```Dockerfile
FROM nginx
COPY ./nginx.conf /etc/nginx/
```
Giving container names is important or else nginx won't be able to access the apps.
