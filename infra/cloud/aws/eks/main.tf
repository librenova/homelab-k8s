module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "aws-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.subnet_ids
}
