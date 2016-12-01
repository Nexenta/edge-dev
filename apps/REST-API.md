## Nexenta Edge Swagger Docker Container

### Introduction 

Nexenta Edge Swagger is an interface to Nexenta Edge REST API. 

For more information on Swagger visit http://swagger.io/

>Nexenta provides a Swagger front-end to the NexentaEdge management REST API. 
>Using the browser based Swagger interface, you can configure and retrieve information about the NexentaEdge cluster. 

### Installation
1.	Install Docker onto you system
For Docker Linux systems configuration and installation refer to [DockerDocs]( https://docs.docker.com/engine/installation/)  

2.	Pull nexenta/nedge-swagger Docker image from dockerhub using command:
`$docker pull nexenta/nedge-swagger`

### Run Instructions

`$ docker run -p 80:8080 nexenta/nedge-swagger`

### Opening Swagger in browser
 In browser address bar type: 
http://<docker host IP>/dist/index.html

In the URL field, enter:
http://<management IP>:8080/v2/swagger.json
> <management IP> is the IP of  NexentaEdge management node.

In the Username/password fields, enter NexentaEdge management user credentials.

### Stop Instruction
`$ Docker ps`
`$ Docker stop <Container ID>`
