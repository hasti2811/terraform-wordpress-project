output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "public_subnet_1" {
  value = aws_subnet.public-1.id
}

output "public_subnet_2" {
  value = aws_subnet.public-2.id
}

output "private_subnet_1" {
  value = aws_subnet.private-1.id
}

output "private_subnet_2" {
  value = aws_subnet.private-2.id
}