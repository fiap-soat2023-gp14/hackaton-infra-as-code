resource "aws_docdb_subnet_group" "service" {
  name       = "docdb-fiaph-acka-project"
  subnet_ids = "${aws_subnet.private_subnets.*.id}"
}

resource "aws_docdb_cluster_instance" "service" {
  count              = 1
  identifier         = "docdb-fiap-hacka-project-${count.index}"
  cluster_identifier = aws_docdb_cluster.service.id
  instance_class     = "db.t3.medium"
}

resource "aws_docdb_cluster" "service" {
  skip_final_snapshot             = true
  db_subnet_group_name            = aws_docdb_subnet_group.service.name
  cluster_identifier              = "docdb-fiap-hacka-project"
  engine                          = "docdb"
  master_username                 = var.docdb_username
  master_password                 = var.docdb_password
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.service.name
  vpc_security_group_ids          = ["${aws_security_group.docdb-security-group-fiap-project.id}"]
}

resource "aws_docdb_cluster_parameter_group" "service" {
  family = "docdb5.0"
  name   = "docdb-fiap-hacka-project"
}