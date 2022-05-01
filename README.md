# Appointment booking system admin dashboard

This project is a web admin client for businesses to use for appointment management, written in Flutter Web.
Since starting the project this client has been rewritten in Blazor because of Flutter Web's poor initial load time.

Backend API URL is set to localhost by default, but is overridden at the CI stage with an environment variable.
The project is then dockerized and pushed to an Azure Container Registry

The virtual machine is hosted in Azure and is running linux, where an instance of Watchtower (https://containrrr.dev/watchtower/) checks for new images every 30 seconds and pulls the latest image if a new one is detected.

Below are a few screenshots...

![alt text](https://i.ibb.co/rw7m7X4/Screenshot-2022-03-07-at-21-55-24.png)
![alt text](https://i.ibb.co/5hdBsGR/Screenshot-2022-03-07-at-21-57-48.png)
![alt text](https://i.ibb.co/r4RsMj9/Screenshot-2022-03-07-at-21-56-49.png)
![alt text](https://i.ibb.co/Q6phBh0/Screenshot-2022-03-07-at-21-55-46.png)
![alt text](https://i.ibb.co/fpYKQ7d/Screenshot-2022-03-07-at-21-55-41.png)
![alt text](https://i.ibb.co/wssvvrK/Screenshot-2022-03-07-at-21-55-35.png)
![alt text](https://i.ibb.co/HxVLD5t/Screenshot-2022-03-07-at-21-56-00.png)
![alt text](https://i.ibb.co/wYfk1fb/Screenshot-2022-03-07-at-21-57-12.png)
![alt text](https://i.ibb.co/d64vrjd/Screenshot-2022-03-07-at-21-55-09.png)
![alt text](https://i.ibb.co/KmMRrYL/Screenshot-2022-03-07-at-21-55-30.png)
