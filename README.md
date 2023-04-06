# IRIS-Systems_Recruitment2023

For this task, I launched two more containers of the rails-app image using the command described in task3 and named them app2 and app3.
Now, for load balancing I used upstream directive to define a group of servers. The updated nginx.conf file is:
```nginx
upstream servers {
  server app:3000;
  server app2:3000;
  server app3:3000;
}
server {
  listen 80;
  listen [::]:80;
  server_name cloudflare;
  location / {
    proxy_pass http://servers;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```
We can also add weights to the servers if a server is powerful than others. We can see the logs of a container to check if it has been requested or not.
  
