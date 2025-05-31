resource "aws_instance" "web" {
  ami                    = "ami-0e35ddab05955cf57"      #change ami id for different region
  instance_type          = "t2.large"
  key_name               = "ssh"              #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]

  tags = {
    Name = "Jenkins-SonarQube"
  }

  root_block_device {
    volume_size = 28
  }
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name        = "Jenkins-VM-SG"
  description = "Allow TLS inbound traffic"

 ingress {
    from_port = 22
    to_port = 22 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}
