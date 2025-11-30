resource "aws_instance" "my-ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.sg_id]

  user_data = templatefile("${path.module}/cloud-init.sh", {
    db_name      = var.db_name
    db_username  = var.db_username
    db_password  = var.db_password
    rds_endpoint = var.rds_endpoint
    rds_port     = var.rds_port
  })

  # user_data = <<-EOF
  #   #!/bin/bash

  #   apt-get update -y
  #   apt-get upgrade -y
  #   apt-get install -y nginx
  #   systemctl enable nginx
  #   systemctl start nginx
  #   echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html
  # EOF
}
