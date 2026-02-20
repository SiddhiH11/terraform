resource "aws_launch_template" "home_launch_template" {
    image_id = var.image_id
    instance_type = var.instance_type
    name = "${var.project}-${var.env}-home-lt"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.security_group.id]

    tags = {
        env = var.env
    }

    user_data = base64encode(<<EOF
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl enable apache2
    systemctl start apache2
    echo "<h1> Hello World </h1>" > /var/www/html/index.html
    EOF 
    )
}


resource "aws_launch_template" "mobile_launch_template" {

  image_id      = var.image_id
  instance_type = var.instance_type
  name          = "${var.project}-${var.env}-mobile-lt"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    env = var.env
  }

  user_data = base64encode(<<EOF
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
mkdir /var/www/html/mobile
echo "<h1>THIS IS MOBILE PAGE... CONNECT HERE</h1>" > /var/www/html/mobile/index.html
EOF
)

}

resource "aws_launch_template" "laptop_launch_template" {

  image_id      = var.image_id
  instance_type = var.instance_type
  name          = "${var.project}-${var.env}-laptop-lt"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.security_group.id]

  tags = {
    env = var.env
  }

  user_data = base64encode(<<EOF
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
mkdir /var/www/html/laptop
echo "<h1>This is Laptop Page... SALE! SALE! SALE! </h1>" > /var/www/html/laptop/index.html
EOF
  )
}