resource "aws_key_pair" "db_initialisation_keypair" {
  key_name   = "terraformstack"
  public_key = file(var.PUBLIC_KEY_PATH)
}