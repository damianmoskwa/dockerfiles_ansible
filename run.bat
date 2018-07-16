docker build -t master .
docker build -t node node01/.
docker container run -it -d --name node01 node 
docker container run -it -d -p 49154:22 --link node01:node01 --name master_node master