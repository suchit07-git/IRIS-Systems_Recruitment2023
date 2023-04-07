# IRIS-Systems_Recruitment2023

In docker, for data persistence, we generally use volumes since it is managed by docker itself. In this case, we need to persist the db data and the nginx configuration data.
A volume can be created by running `docker volume create volume_name`.
For this task I created two volumes named db-data(for mysql container) and conf-data(for nginx container).
And I mounted them to the respective containers while running the containers using the following commands:

`docker run --name mysql --network mynetwork -p 3306:3306 --mount type=volume,src=db-data,target=/var/lib/mysql/ -e MYSQL_ROOT_PASSWORD=password mysql_image_id`

`docker run --name nginx --network mynetwork -p 80:80 --mount type=volume,src=conf-data,target=/etc/nginx/ nginx`
To edit the nginx.conf file I docker exec command and changed the nginx.conf file inside the container.
Now, even if we stop and remove the container, the data still persists.

Initial state
![mysql](https://user-images.githubusercontent.com/78025461/230542653-9286e2ad-2b61-4c1f-9ac6-57b435e9fa77.png)

Creating and mounting the volume
![mysql(2)](https://user-images.githubusercontent.com/78025461/230542664-2d07b9d2-8e76-40e9-85f5-a01687d4e23b.png)

Checking if the initially stored data is still present or not
![mysql(3)](https://user-images.githubusercontent.com/78025461/230542671-8c534d4b-0ab6-4183-888c-c5f8e1f43fa3.png)
