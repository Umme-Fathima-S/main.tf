provider "aws" {
  region  = "ap-south-1"
}
/* AWS VPC */
resource "aws_vpc" "myvpc" {
  cidr_block  = "10.0.0.0/16"
}
/* PUBLIC SUBNET */
resource "aws_subnet" "public_subnet" {
  vpc_id      = "aws_vpc.myvpc.id"
  cidr_block  = "10.0.1.0/24"
}
/* PRIVATE SUBNET */
resource "aws_subnet" "private_subnet" {
  vpc_id      = "aws_vpc.myvpc.id"
  cidr_block  = "10.0.2.0/24"
}
/* INTERNET GATEWAY */
resource "aws_internet_gateway" "igw" {
  vpc_id = "aws_vpc.myvpc.id"
}
/* ROUTE TABLE */
resource "aws_route_table" "public_route_table" {
  vpc_id = "aws_vpc.myvpc.id"
  route  {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = "aws_internet_gateway.igw.id"
  }
}
/* ROUTE TABLE ASSOCIATION */
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = "aws_subnet.public_subnet.id"
  route_table_id = "aws_route_table.public_route_table.id"
}
/* ELASTIC IP fOR NAT GATEWAY */
resource "aws_eip" "natgateway_eip" {
  vpc  = true
}
/* NAT GATEWAY */
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "aws_eip.natgateway_eip.id}"
  subnet_id     = "aws_subnet.public_subnet.id"
}
/* ROUTE TABLE FOR NAT GATEWAY */
resource "aws_route_table" "private_route_table" {
  vpc_id = "aws_vpc.myvpc.id"
  route  {
    cidr_block  = "0.0.0.0/0"
    nat_gateway_id  = "aws_nat_gateway.nat_gateway.id"
  }
}
/* ROUTE TABLE ASSOCIATION */
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = "aws_subnet.private_subnet.id"
  route_table_id = "aws_route_table.private_route_table.id"
}
/* AWS KMS KEY */
resource "aws-kms_key" "CMK" {
  key_name   = "aws_key"
  public_key = "ssh-rsa1234abcd-12ab-34cd-56ef-1234567890ab"
}
data "aws_availability_zones" "available_zones" {
/* EC2 INSTANCE IN PRIVATE SUBNET */
resource "aws_instance" "ec2_instance" {
  ami               = "ami0767046d1677be5a0"
  instance_type     = "t2.micro"
  availability_zone = "data.aws_availability_zones.available_zones.names[0]"
  key_name          = "aws_key"
  subnet_id         = "aws_subnet.private_subnet.id"
}
/* AWS RDS INSTANCE */
resource "aws_db_instance" "db_instance" {
  engine            = "mysql"
  allocated storage =  10
  instance_class    = "db.t2.micro"
  availability_zone = "data.aws_availability_zones.available_zones.names[0]"
  username          = "rdsusername"
  password          = "rdspassword"
  subnet_id         = "aws_subnet.private_subnet.id"
}














