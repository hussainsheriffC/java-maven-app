variable "region" {
  default = "us-east-1"
}
variable "vpc-cidr-block" {
    default = "10.0.0.0/16"
}
variable "subnet-cidr-block" {
    default = "10.0.10.1/24"
}
variable "avail_zone" {
    default = "us-east-1a"
}
variable "env_prefix" {
    default = "dev"
}
variable "my-ip" {
    default = "54.147.0.252/32"
}
variable "instance-type" {
    default = "t2.micro"
}