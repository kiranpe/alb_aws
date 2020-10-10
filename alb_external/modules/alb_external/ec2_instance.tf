locals {
  ec2_tags = {
    Name = "${terraform.workspace}-instance"
    CreatedBy = "Kiran Peddineni"
  }
}

resource "aws_instance" "docker" {
   ami  = data.aws_ami.ubuntu.id
   instance_type   = var.instance_type
   key_name        = var.key_name
   security_groups = [aws_security_group.alb_ingress.id]
   
   subnet_id       = element(var.subnet_ids, 1)
     
#   user_data = file("${path.module}/install_apache.sh")

   user_data = <<-EOF
               #!/bin/bash
               #Script to install docker and deploy a apache server to test alb connection

               sudo apt-get update
               sudo apt-get install -y docker.io
               sudo docker pull httpd
               sudo mkdir /opt/app
               echo "<h1>Deployed via Terraform!!!!</h1>" | sudo tee -a /opt/app/index.html
               echo "${terraform.workspace}-instance" | sed 's/^/<h1>/' | sed 's/$/<h1>/' | sudo tee -a /opt/app/index.html
               sudo docker run -it --name apache -p 80:80 -v /opt/app:/usr/local/apache2/htdocs -d httpd
             EOF

   tags = local.ec2_tags
}
