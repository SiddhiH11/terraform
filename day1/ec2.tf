provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my_instance" {
    ami = "ami-0c1fe732b5494dc14"
    instance_type = "t3.micro"
    key_name = "new-key"
    vpc_security_group_ids = ["sg-07316d011e1dec8ce"]
    tags = {
        Name = "my_instance"
        env = "dev"
    }
}

# <block_type> <resource_name> <block_name> {
# -------
# --CONFIGURATION-----
# -------
#}