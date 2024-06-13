set -e

# image tag is `yugabytedb/yugabyte:2.21.1.0-b271-aarch64``
export IMAGE_SHA=848ff36bf479eec0cfe6af99b995cc2bb0dab11b0cc2d931302288a346f4f787

docker rm -f yugabytedb-node1 yugabytedb-node2 yugabytedb-node3

docker network rm -f yugabytedb-network
docker network create yugabytedb-network

docker run -d --name yugabytedb-node1 --net yugabytedb-network \
    -p :15433 -p :5433 \
    --restart unless-stopped \
    $IMAGE_SHA \
    bin/yugabyted start --background=false

docker run -d --name yugabytedb-node2 --net yugabytedb-network \
    -p :15433 -p :5433 \
    --restart unless-stopped \
    $IMAGE_SHA \
    bin/yugabyted start --join=yugabytedb-node1 --background=false

docker run -d --name yugabytedb-node3 --net yugabytedb-network \
    -p :15433 -p :5433 \
    --restart unless-stopped \
    $IMAGE_SHA \
    bin/yugabyted start --join=yugabytedb-node1 --background=false

sleep 20

docker exec -it yugabytedb-node1 bin/ysqlsh -h yugabytedb-node1 \
    -c 'select host, port from yb_servers()' | cat
