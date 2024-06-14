while true; do
    export ID=$(( $RANDOM % 2 + 2 ))
    docker network disconnect -f yugabytedb-network yugabytedb-node$ID
    sleep 2
    echo "Reconnecting yugabytedb-node$ID to yugabytedb-network ..."
    docker network connect yugabytedb-network yugabytedb-node$ID
done
