resource "aws_instance" "db_initialisation_instance" {
  ami                    = lookup(var.AMIS, var.REGION)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.db_initialisation_keypair.key_name
  subnet_id              = module.vpc.public_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.db_initialisation_sg.id]

  tags = {
    "Name" = "db_initialisation"
  }

  provisioner "file" {
    content     = templatefile("templates/db-initialisation.tmpl", { rds-endpoint = aws_db_instance.rds_mysql.address, dbuser = var.dbuser, dbpass = var.dbpasswd })
    destination = "/tmp/db-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install mysql-client-5.7 -y",
      "sudo chmod +x /tmp/db-init.sh",
      "sudo /tmp/db-init.sh"
    ]
  }

  connection {
    user        = var.USERNAME
    private_key = file(var.PRIVATE_KEY_PATH)
    host        = self.public_ip
  }

  depends_on = [aws_db_instance.rds_mysql]

}