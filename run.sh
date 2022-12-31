#/bin/bash

docker run -d -it -p 8999:8000 --name=project1 --restart=always --privileged -v project1-nginx-conf:/etc/nginx project1:v1 