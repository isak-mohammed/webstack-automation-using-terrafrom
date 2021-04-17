resource "aws_key_pair" "bastion_instance_keypair" {
  key_name   = "terraformstack"
  public_key = file(var.PUBLIC_KEY_PATH)
}