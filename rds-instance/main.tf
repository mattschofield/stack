variable "allocated_storage" {
  description = "The amount of storage to allocate to this RDS instance"
  default     = 10
}

variable "engine" {
  default = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"
  default = {
    mysql = "5.6.22"
    postgres = "9.4.1"
  }
}

# db.m3.large
variable "instance_class" {
  description = "The size of database instance to use"
  default     = "db.t1.micro"
}

variable "name" {
  description = "The name will be used to prefix and tag the resources, e.g mydb"
}

variable "master_username" {
  description = "The master user username"
}

variable "master_password" {
  description = "The master user password"
}

variable "subnet_ids" {
  description = "A comma-separated list of subnet IDs"
}

resource "aws_db_subnet_group" "main" {
  name        = "${var.name}"
  description = "RDS instance subnet group"
  subnet_ids  = ["${split(",", var.subnet_ids)}"]
}

resource "aws_db_instance" "main" {
  allocated_storage      = "${var.allocated_storage}"
  engine                 = "${var.engine}"
  engine_version         = "${lookup(var.engine_version, var.engine)}"
  instance_class         = "${var.instance_class}"
  name                   = "${var.name}"
  username               = "${var.master_username}"
  password               = "${var.master_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.main.id}"
  multi_az               = true
}

# OUTPUTS
output "subnet_group" {
  value = "${aws_db_subnet_group.main.name}"
}
output "db_instance_id" {
  value = "${aws_db_instance.main.id}"
}
output "db_instance_address" {
  value = "${aws_db_instance.main.address}"
}