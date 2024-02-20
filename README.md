# AWS Infrastructure + Kubernetes Infrastructure + Application
### Full VPC + EKS + ClusterAutoscaler
### Nginx Ingress Controller + Ingress
### Python Flask Application with UWSGI with HorizontalPodAutoscaler

## Prerequisites
1. Install and configure aws-cli
2. Install kubectl
3. Install terraform
4. Install jq

## Pre Deployment
1. Navigate to the following directory
```bash
cd terraform/env/perimiter81
```
2. Fill in all the relevant values in the **variables.tfvars** file

## Deployment
```bash
cd terraform/env/perimiter81/

terraform init
terraform validate
terraform plan -var-file="variables.tfvars" -out terraform.plan
terraform apply terraform.plan
```

## Post Deployment
1. Configure kubectl
    - **Option one**: as part of the deployment a "config" file was created in the same directory (see above). You can use it to execute kubectl commands by using the --kubeconfig <path-to-file>
    - **Option two**: you can use the file mentioned in "1.a" and override/merge-to your local ~/.kube/config
    - **Option three**: You can execute the below command which will automatically update your ~/.kube/config file with the correct details
```bash
aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw eks_cluster_name)
```
2. Deploy Cluster Autoscaler
```bash
cd ../../../auto-scalers/

sed "s/PUT_ACCOUNT_ID_HERE/$(aws sts get-caller-identity | jq -r ".Account")/g" cluster/values.yaml
sed "s/PUT_CLUSTER_NAME_HERE/$(terraform output -raw eks_cluster_name)/g" cluster/templates/deployment.yaml

helm install --upgrade cluster-autoscaler cluster

cd ../ingress-nginx

# Put the correct value for the ssl cert under service.annotations in the values.yaml file
# service.beta.kubernetes.io/aws-load-balancer-ssl-cert: arn:aws:acm:us-east-1:XXXXXXXX:certificate/XXXXXX-XXXXXXX-XXXXXXX-XXXXXXXX

helm install --upgrade ingress-nginx .
```
3. Deploy the application
```bash
cd ../application_server

helm install --upgrade application-server application_chart
```

## Cleanup of all the created resources
```bash
cd terraform/env/perimiter81/

terraform destroy -var-file="variables.tfvars" --auto-approve
```
