#General vars
prefix      = "perimiter81"
project     = "perimiter81"
application = "perimiter81"
aws_region  = "us-east-1"

#VPC
create_vpc              = true
vpc_cidr_block          = "10.0.0.0/16"
azs                     = ["us-east-1a", "us-east-1b"]
public_subnet_cidr      = ["10.0.10.0/24", "10.0.20.0/24"]
private_subnet_cidr     = ["10.0.1.0/24", "10.0.2.0/24"]
enable_nat_gateway      = true
public_eks_tag          = { "kubernetes.io/role/elb" = 1 }
private_eks_tag         = { "kubernetes.io/role/internal-elb" = 1 }

#EKS
cluster_name            = "main"
k8s_version             = "1.28"
node_instance_type      = "t3.medium"
aws_iam                 = "eks-cluster-autoscaler"
desired_capacity        = 1
max_size                = 5
min_size                = 1
max_unavailable         = 1
endpoint_private_access = true
endpoint_public_access  = true
eks_cw_logging          = ["api", "audit", "authenticator", "controllerManager", "scheduler"]