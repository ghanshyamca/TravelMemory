output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "web_instance_private_ip" {
  value = aws_instance.web.private_ip
}

output "db_instance_private_ip" {
  value = aws_instance.db.private_ip
}
