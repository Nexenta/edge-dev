
## Introduction 
COSBench is a distributed benchmark tool to test cloud object storage systems. Cosbench is a benchmark for object storage services, written and maintained by Intel.

This branch of COSBench enhances object randomization such that de-duplication and compression have no effect on generated object payloads.

COSbench consists of two key components: 

Driver (also referred to as COSBench Driver or Load Generator): 

>Responsible for workload generation, issuing operations to target cloud object storage, and collecting performance statistics. 
>Can be accessed via http://<driver-host>:18088/driver/index.html. 

Controller (also referred to as COSBench Controller):
 
>Responsible for coordinating drivers to collectively execute a workload, collecting and aggregating runtime status or benchmark results from driver instances, and accepting workload submissions. 
>Can be accessed via http://<controller-host>:19088/controller/index.html. 

## Customization 

 Customized application for Nexeta Edge scalability testing. 

COSBench was customized to allow Nexenta Edge testing
* The long random sequences (2M) are used to generate the storage load. This change provides ability to generate load on the Nexenta Edge system with uncompressible data.
* The S3 MD5 checking was disabled.

## Installation
1.	Install Docker onto you system
For Docker Linux systems configuration and installation refer to [DockerDocs]( https://docs.docker.com/engine/installation/)  

2.	Pull nexenta/cosbench  Docker image using command:

`$ docker pull nexenta/cosbench`

## Run Instructions

##### 1. Run controller and driver in one Docker container on one node.

`$ docker run -p 19088:19088 -p 18088:18088  -e ip=<node ip>  -e t=both -e n=1  nexenta/cosbench`

E.g.

`$ docker run -p 19088:19088 -p 18088:18088  -e ip=10.15.20.66  -e t=both -e n=1 nexenta/cosbench`

##### 2. Run controller and driver in multiple docker contains on one node

`$ docker run -p 19088:19088 -p 18088:18088  -e ip=<node ip>  -e t=both -e n=<number of driver instances> -v $(which docker):/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock  nexenta/cosbench`

E.g.

`$ docker run -p 19088:19088 -p 18088:18088  -e ip=10.15.20.66  -e t=both -e n=2 -v $(which docker):/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock  nexenta/cosbench`

##### 3. Distributed load drivers on multiple nodes
###### 3.1  Run Only Driver on each node

`$ docker run  -p 18088:18088  -e ip=<node ip> -e t=driver nexenta/cosbench`

E.g.

`$ docker run  -p 18088:18088  -e ip=10.15.20.66 -e t=driver nexenta/cosbench`

###### 3.2 Run Controller on the node 

`$ docker run -p 19088:19088   -e ip=<comma separated driver node ip list> -e t=controller nexenta/cosbench`

E.g.

`$ docker run -p 19088:19088   -e ip=10.15.20.66,10.15.20.67 -e t=controller nexenta/cosbench`

## Example Workloads 

S3 https://github.com/Nexenta/nedge-cosbench/blob/master/s3-config.xml

Swift https://github.com/Nexenta/nedge-cosbench/blob/master/swift-config.xml 

## Opening Cosbench in browser

 In browser address bar type: 

>http://< controler IP >:19088/controller

## Stop Instruction
`$ Docker ps`

`$ Docker stop <Container ID>`
