resource "aws_rds_instance" "database" {
  allocated_storage = 20
  engine           = "mysql"
  instance_class   = "db.t3.micro"
  username        = "admin"
  password        = "securepassword"
}
