docker build -t shogunstudios/multi-client:latest -t shogunstudios/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t shogunstudios/multi-server:latest -t shogunstudios/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t shogunstudios/multi-worker:latest -t shogunstudios/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push shogunstudios/multi-client:latest
docker push shogunstudios/multi-server:latest
docker push shogunstudios/multi-worker:latest

docker push shogunstudios/multi-client:$SHA
docker push shogunstudios/multi-server:$SHA
docker push shogunstudios/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=shogunstudios/multi-server:$SHA
kubectl set image deployments/client-deployment client=shogunstudios/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=shogunstudios/multi-worker:$SHA
