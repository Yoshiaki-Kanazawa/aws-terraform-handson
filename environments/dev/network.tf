########### VPC ###########
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "handson-vpc"
  }
}

########### subnet ###########
module "subnet_public_ingress_1a" {
  source = "../../modules/subnet"
  name = "handson-subnet-public-ingress-1a"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  is_public = true
  availability_zone = "ap-northeast-1a"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_public_ingress_1c" {
  source = "../../modules/subnet"
  name = "handson-subnet-public-ingress-1c"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  is_public = true
  availability_zone = "ap-northeast-1c"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_private_container_1a" {
  source = "../../modules/subnet"
  name = "handson-subnet-private-container-1a"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.8.0/24"
  is_public = false
  availability_zone = "ap-northeast-1a"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_private_container_1c" {
  source = "../../modules/subnet"
  name = "handson-subnet-private-container-1c"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.9.0/24"
  is_public = false
  availability_zone = "ap-northeast-1c"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_private_db_1a" {
  source = "../../modules/subnet"
  name = "handson-subnet-private-db-1a"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.16.0/24"
  is_public = false
  availability_zone = "ap-northeast-1a"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_private_db_1c" {
  source = "../../modules/subnet"
  name = "handson-subnet-private-db-1c"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.17.0/24"
  is_public = false
  availability_zone = "ap-northeast-1c"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_public_management_1a" {
  source = "../../modules/subnet"
  name = "handson-subnet-public-management-1a"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.240.0/24"
  is_public = true
  availability_zone = "ap-northeast-1a"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_public_management_1c" {
  source = "../../modules/subnet"
  name = "handson-subnet-public-management-1c"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.241.0/24"
  is_public = true
  availability_zone = "ap-northeast-1c"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_private_egress_1a" {
  source = "../../modules/subnet"
  name = "handson-subnet-private-egress-1a"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.248.0/24"
  is_public = false
  availability_zone = "ap-northeast-1a"
  depends_on = [
    aws_vpc.vpc
  ]
}

module "subnet_private_egress_1c" {
  source = "../../modules/subnet"
  name = "handson-subnet-private-egress-1c"
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.249.0/24"
  is_public = false
  availability_zone = "ap-northeast-1c"
  depends_on = [
    aws_vpc.vpc
  ]
}

########### Internet Gateway ###########
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "handson-igw"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

########### route table ###########
resource "aws_route_table" "rt_app" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "handson-rt-app"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_route_table_association" "rta_app_1a" {
  subnet_id = module.subnet_private_container_1a.subnet_id
  route_table_id = aws_route_table.rt_app.id
  depends_on = [
    aws_route_table.rt_app
  ]
}

resource "aws_route_table_association" "rta_app_1c" {
  subnet_id = module.subnet_private_container_1c.subnet_id
  route_table_id = aws_route_table.rt_app.id
  depends_on = [
    aws_route_table.rt_app
  ]
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "handson-rt-public"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route" "route_igw" {
  route_table_id = aws_route_table.rt_public.id
  gateway_id = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_route_table.rt_public
  ]
}

resource "aws_route_table_association" "rta_public_ingress_1a" {
  subnet_id = module.subnet_public_ingress_1a.subnet_id
  route_table_id = aws_route_table.rt_public.id
  depends_on = [
    aws_route_table.rt_public
  ]
}

resource "aws_route_table_association" "rta_public_ingress_1c" {
  subnet_id = module.subnet_public_ingress_1c.subnet_id
  route_table_id = aws_route_table.rt_public.id
  depends_on = [
    aws_route_table.rt_public
  ]
}

resource "aws_route_table_association" "rta_public_management_1a" {
  subnet_id = module.subnet_public_management_1a.subnet_id
  route_table_id = aws_route_table.rt_public.id
  depends_on = [
    aws_route_table.rt_public
  ]
}

resource "aws_route_table_association" "rta_public_management_1c" {
  subnet_id = module.subnet_public_management_1c.subnet_id
  route_table_id = aws_route_table.rt_public.id
  depends_on = [
    aws_route_table.rt_public
  ]
}

resource "aws_route_table" "rt_db" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "handson-rt-db"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_route_table_association" "rta_db_1a" {
  subnet_id = module.subnet_private_db_1a.subnet_id
  route_table_id = aws_route_table.rt_db.id
  depends_on = [
    aws_route_table.rt_db
  ]
}

resource "aws_route_table_association" "rta_db_1c" {
  subnet_id = module.subnet_private_db_1c.subnet_id
  route_table_id = aws_route_table.rt_db.id
  depends_on = [
    aws_route_table.rt_db
  ]
}

########### security group ###########
module "sg_ingress" {
  source = "../../modules/security_group"
  name = "handson-sg-ingress"
  vpc_id = aws_vpc.vpc.id
  ingress_rules = {
    http = {
      port = 80
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = []
    }
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

module "sg_frontend" {
  source = "../../modules/security_group"
  name = "handson-sg-frontend"
  vpc_id = aws_vpc.vpc.id
  ingress_rules = {
    http = {
      port = 80
      cidr_blocks = []
      security_groups = [
        module.sg_ingress.sg_id
      ]
    }
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

module "sg_management" {
  source = "../../modules/security_group"
  name = "handson-sg-management"
  vpc_id = aws_vpc.vpc.id
  ingress_rules = {}
  depends_on = [
    aws_vpc.vpc
  ]
}

module "sg_inner_alb" {
  source = "../../modules/security_group"
  name = "handson-sg-inner-alb"
  vpc_id = aws_vpc.vpc.id
  ingress_rules = {
    http = {
      port = 80
      cidr_blocks = []
      security_groups = [
        module.sg_frontend.sg_id,
        module.sg_management.sg_id
      ]
    }
    http-test = {
      port = 10080
      cidr_blocks = []
      security_groups = [
        module.sg_management.sg_id
      ]
    }
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

module "sg_backend" {
  source = "../../modules/security_group"
  name = "handson-sg-backend"
  vpc_id = aws_vpc.vpc.id
  ingress_rules = {
    http = {
      port = 80
      cidr_blocks = []
      security_groups = [
        module.sg_inner_alb.sg_id
      ]
    }
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

module "sg_db" {
  source = "../../modules/security_group"
  name = "handson-sg-db"
  vpc_id = aws_vpc.vpc.id
  ingress_rules = {
    aurora = {
      port = 3306
      cidr_blocks = []
      security_groups = [
        module.sg_frontend.sg_id,
        module.sg_backend.sg_id,
        module.sg_management.sg_id
      ]
    }
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

module "sg_vpce" {
  source = "../../modules/security_group"
  name = "handson-sg-vpce"
  vpc_id = aws_vpc.vpc.id
  ingress_rules = {
    https = {
      port = 443
      cidr_blocks = []
      security_groups = [
        module.sg_frontend.sg_id,
        module.sg_backend.sg_id,
        module.sg_management.sg_id
      ]
    }
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

########### Service Discovery Service ###########
resource "aws_service_discovery_private_dns_namespace" "internal_namespace" {
  name        = "local"
  description = "This is namespace for the ECS service."
  vpc         = "${aws_vpc.vpc.id}"

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_service_discovery_service" "ecs_service_discovery" {
  name = "handson-ecs-service-access"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.internal_namespace.id}"

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  depends_on = [
    aws_service_discovery_private_dns_namespace.internal_namespace
  ]
}