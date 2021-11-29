# Mediawiki Deployment

![alt text](https://github.com/sasidharchalla/mediawiki/blob/main/architecture.png)

Infrastructure:
Created on Azure platform.

Deployment:
This deployment has Horizontol Pod Autoscaling enabled which will automatically scale the application pods based on the load, ensuring high availability of the application.


### Building the application image
To create a docker image with mediawiki application and push to the docker hub, execute below commands:
```
docker build -t <image-name>-:<tag> Dockerfile
docker tag <image-name>:<tag> <dockerhub-username>/<image-name>:<tag>
docker login
docker push <dockerhub-username>/<image-name>:<tag>
```
After pushing image to dockerhub, image can be used in helm-charts.

### Building infrastructure using terraform
Before deploying the application you need to login by az client
```
az login
```
After placing/exporting the credentails, execute the below commands seqentially:
(For Dev environment)
```
cd terraform/
terraform workspace new dev
terraform init
terraform plan -var-file=environments/development/dev.tfvars -out AzurePrivateNetwork
terraform apply AzurePrivateNetwork
```
### Deploy using helm
Once the terraform is successfully applied, follow these steps, We can only access AKS cluster from jumpbox(since the cluster is private)
(Helm,kubectl,Azure client,Git are already installed on the jumpbox )
```
terraform output show jumpbox_public_ip //Note down the public ip
ssh -i "./modules/jumpbox/private_key.pem" adminuser@<jumpbox publicIP>
```

After logging into jumpbox,
```
az login
az aks get-credentials --resource-group mediawiki-kube-dev --name private-aks-dev
git clone https://github.com/sasidharchalla/mediawiki.git
helm install develop mediawiki -n dev --create-namespace
```
### Verfying
Get public IP of mediawiki through kubectl command.
```
kubectl get svc -n dev develop-mediawiki -o wide
```
Run it from the browser.

#### Technologies and tools
- Azure
- Terraform
- Docker
- Helm
