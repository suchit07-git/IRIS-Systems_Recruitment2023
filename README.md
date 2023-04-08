# IRIS-Systems_Recruitment2023

```nginx
events {
}

http {
  upstream servers {
    server app:3000;
    server app2:3000;
    server app3:3000;
  }
  limit_req_zone $binary_remote_addr zone=mylimit:10m rate=5r/s;
  server {
    listen 80;
    listen [::]:80;
    server_name cloudflare;
    location / {
      limit_req zone=mylimit burst=10 nodelay;
      proxy_pass http://servers;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
    }
  }
}
```
For this task, I used the limit_req_zone directive to set the parameters for rate limiting and limit_req to enable rate limiting within the context(location /).
The name of the shared memory zone which is used to store the state of IP addresses is mylimit and the size that can be used for storing is 10 MB and the rate is set to 5 requests per second or 1 request for every 0.2 seconds.
Now, inside the location context, we have enabled rate limiting by writing limit_req with two parameters. Here, the burst parameter is used to specify the number of excessive requests that need to be buffered in a queue. This is done so that, if we get two requests within the rate limit time, instead of returning status code 503 to the second request, the request will be added to a queue and will be processed according to its order in the queue.
Also, the nodelay parameter is used along with burst so as to enable nginx to forward a request immediately as long as there is a slot in the queue.
For testing, I used Apache HTTP server benchmarking tool ab. 
I sent 100 requests concurrently using the command `ab -c 100 -n 100 http://cloudflare/` once with burst and nodelay parameters used and in the other case it wasn't used.
As shown in the figure, the time taken for tests is 0.054 seconds and the number of failed requests is 89 when burst and nodelay parameters are used and when they aren't used the time taken is 0.298 seconds and the total number of failed requests is 99.
In the case where burst and nodelay parameters are used, the time taken and the number of failed requests are relatively less when compared to the case where burst and nodelay parameters are not used.
When burst and nodelay parameters are used, since 100 concurrent requests are sent to the server, the nginx server forwards just one request to the server since all the requests are sent concurrently which makes the number of requests sent within 0.2 seconds to exceed 1. 
Now, with burst parameter set to 10, nginx adds 10 requests to the queue and sends them periodically according to the rate and returns status code 503 for rest of the requests.
When burst and nodelay parameters aren't used, there is no queue and since all requests are sent concurrently, nginx just sends one request to the server and returns status 503 for rest of the requests.

With burst and nodelay parameters
![task7](https://user-images.githubusercontent.com/78025461/230734490-92b07865-7623-4e32-9f78-03fd09f5f03d.png)

Without burst and nodelay parameters
![task7(1)](https://user-images.githubusercontent.com/78025461/230734494-63363fdc-3c8a-49dc-8bfd-e1fcc3aea9b5.png)
