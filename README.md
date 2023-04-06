# IRIS-Systems_Recruitment2023

For task 3, first I created a network named mynetwork with the command docker network create mynetwork(network name). After that I launched a container of the rails-app image and a container of mysql image using the following commands:
```
docker run --name app --network mynetwork -p 8080:3000 app_image_id rails s -p 3000 -b '0.0.0.0' (for rails-app container)
docker run --name mysql --network mynetwork -p 3306:3306 -e MYSQL_USER_PASSWORD=password mysql_image_id (for mysql container).
```
Then, I pulled nginx image from docker hub and I launched nginx container with the following command:
docker run --name nginx --network mynetwork -p 80:80 nginx_image_id.
After this I edited the nginx.conf file inside nginx container. I used docker exec -it nginx bash to enter the container and access the nginx.conf file. I included the following lines in the file:
```nginx
http {
  server { 
    listen 80;
    listen [::]:80;
    server_name cloudflare;
    location / {
      proxy_pass http://app:3000/;
      proxy_set_header Host $host;
    }
  }
}
```
Now, the rails app is accessed at `http://cloudflare` instead of `http://localhost:8080` since nginx is configured as a reverse proxy for the rails app.
  
