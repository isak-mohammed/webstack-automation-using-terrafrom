variable "REGION" {
  default = "eu-west-2"
}
variable "AMIS" {
  type = map
  default = {
    eu-west-1 = "ami-096cb92bb3580c758"
    eu-west-2 = "ami-0244a5621d426859b"
    eu-west-3 = "ami-096cb92bb3580c750"
  }
}

variable "PRIVATE_KEY_PATH" {
  default = "terraformstack"
}

variable "PUBLIC_KEY_PATH" {
  default = "terraformstack.pub"
}

variable "USERNAME" {
  default = "ubuntu"
}

variable "MYIP" {
  default = "51.9.138.33/32"
}

variable "rmquser" {
  default = "isak"
}

variable "rmqpass" {
  default = "terraformstack@123"
}

variable "dbuser" {
  default = "admin"
}

variable "dbpasswd" {
  default = "admin123"
}

variable "dbname" {
  default = "accounts"
}

variable "instance_count" {
  default = "1"
}
variable "VPC_NAME" {
  default = "web-vpc"
}

variable "AZ_1" {
  default = "eu-west-2a"
}

variable "AZ_2" {
  default = "eu-west-2b"
}

variable "AZ_3" {
  default = "eu-west-2c"
}

variable "VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "Private_Subnet_1" {
  default = "10.0.1.0/24"
}

variable "Private_Subnet_2" {
  default = "10.0.2.0/24"
}

variable "Private_Subnet_3" {
  default = "10.0.3.0/24"
}

variable "Public_Subnet_1" {
  default = "10.0.4.0/24"
}

variable "Public_Subnet_2" {
  default = "10.0.5.0/24"
}

variable "Public_Subnet_3" {
  default = "10.0.6.0/24"
}