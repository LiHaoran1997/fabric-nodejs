docker exec peer0.fabric.gfe.com /bin/bash -c "/nacos-start.sh" 
docker exec peer1.fabric.gfe.com /bin/bash -c "/nacos-start.sh"
docker exec peer2.fabric.gfe.com /bin/bash -c "/nacos-start.sh"
docker exec peer0.fabric.deke.com /bin/bash -c "/nacos-start.sh"

docker exec peer1.fabric.deke.com /bin/bash -c "nohup java -Djava.security.egd=file:/dev/./urandom -jar /app.jar >> /Monitor.log &" 

docker exec peer2.fabric.deke.com /bin/bash -c "nohup java -Djava.security.egd=file:/dev/./urandom -jar /app.jar >> /Monitor.log &" 

docker exec peer0.fabric.dbiir.com /bin/bash -c "nohup java -Djava.security.egd=file:/dev/./urandom -jar /app.jar >> /Monitor.log &" 
