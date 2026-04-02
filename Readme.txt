open docker

kind create cluster --config kind-ingress.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl apply -f jenkins/
kubectl apply -f grafana/

kubectl get pods -w