# Deamon
kubectl apply -f cadvisor.daemonset.yaml

# Postgres
kubectl apply -f postgres.secret.yaml
kubectl apply -f postgres.configmap.yaml
kubectl apply -f postgres.volume.yaml
kubectl apply -f postgres.deployment.yaml
kubectl apply -f postgres.service.yaml

# Redis
kubectl apply -f redis.configmap.yaml
kubectl apply -f redis.deployment.yaml
kubectl apply -f redis.service.yaml

# Poll
kubectl apply -f poll.deployment.yaml
kubectl apply -f poll.ingress.yaml
kubectl apply -f poll.service.yaml

# Result
kubectl apply -f result.deployment.yaml
kubectl apply -f result.ingress.yaml
kubectl apply -f result.service.yaml

# Worker
kubectl apply -f worker.deployment.yaml

# Traefik
kubectl apply -f traefik.deployment.yaml
kubectl apply -f traefik.rbac.yaml
kubectl apply -f traefik.service.yaml

# Create database manually after first deploy
set username orchestrator
set postgres_deployment_id 'kubectl get pods -l=app=postgres -o name'
set postgres_container_id "postgres"
echo "CREATE TABLE votes (id text PRIMARY KEY, vote text NOT NULL);" \
| kubectl exec -i $postgres_deployment_id -c $postgres_container_id \
– psql -U $username

# Adds 2 fake DNS to /etc/hosts
echo "(kubectl get nodes -o jsonpath='{ .items[*].status.addresses[?(@.type=="ExternalIP")].address }') \
poll.dop.io result.dop.io" \
| sudo tee -a /etc/hosts

# Check websites
curl result.dop.io:30021
curl poll.dop.io:30021
curl poll.dop.io:30042