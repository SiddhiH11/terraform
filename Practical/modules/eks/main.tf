resource "aws_iam_role" "cluster_role" {
  name = "cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    env = var.env
  }
}

resource "aws_iam_policy_attachment" "cluster-policy-attachment" {
  name       = "cluster-policy-attachment"
  roles      = [aws_iam_role.cluster_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.default_vpc.id ]
  }
}

resource "aws_eks_cluster" "my_cluster" {
  name = "my_cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.34"

  vpc_config {
    subnet_ids = data.aws_subnets.default_subnets.ids
  }

  depends_on = [
    aws_iam_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]

  timeouts {
    create = "20m"
  }

}


resource "aws_iam_role" "node_role" {
  name = "node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    env = var.env
  }
}

resource "aws_iam_policy_attachment" "worker-node-policy-attachment" {
  name       = "worker-node-policy-attachment"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "cni-node-policy-attachment" {
  name       = "cni-node-policy-attachment"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "container-node-policy-attachment" {
  name       = "container-node-policy-attachment"
  roles      = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my_node_group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.default_subnets.ids
  instance_types = [ "t3.small" ]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_policy_attachment.cni-node-policy-attachment,
    aws_iam_policy_attachment.container-node-policy-attachment,
    aws_iam_policy_attachment.worker-node-policy-attachment
  ]

  timeouts {
    create = "20m`"
  }
}