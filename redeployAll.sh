# Delete secret and rebuild
kubectl delete cm aws-secret

#Deploy ConfigMap
kubectl apply -f aws-secret.yaml
kubectl apply -f env-secret.yaml
kubectl apply -f env-configmap.yaml

#Delete services
kubectl delete service backend-feed
kubectl delete service backend-user
kubectl delete service frontend
kubectl delete service reverseproxy

#Deploy Services
kubectl apply -f service-feed.yaml
kubectl apply -f service-user.yaml
kubectl apply -f service-frontend.yaml
kubectl apply -f service-reverseproxy.yaml



#configure eks
aws eks update-kubeconfig --region region-code --name my-cluster


# Delete Deployments
kubectl delete deploy backend-user
kubectl delete deploy backend-feed
kubectl delete deploy reverseproxy
kubectl delete deploy frontend

#Deployments
kubectl apply -f feed-deploy.yaml
kubectl apply -f user-deploy.yaml
kubectl apply -f frontend-deploy.yaml 
kubectl apply -f reverseproxy-deploy.yaml


# Delete public services
kubectl delete service publicreverseproxy
kubectl delete service publicfrontend


#Portforward 
kubectl expose deployment frontend --type=LoadBalancer --name=publicfrontend

kubectl port-forward service/frontend 8100:8100

#Delete evicted pods
kubectl delete pod $(kubectl get pods | grep Evicted | awk '{print $1}')
