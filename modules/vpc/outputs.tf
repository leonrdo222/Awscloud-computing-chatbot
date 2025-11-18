###############################################
# VPC Module Outputs
###############################################

# ---------- VPC ----------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# ---------- PUBLIC SUBNETS ----------
output "public_subnet_id_1" {
  description = "Public Subnet 1 ID (AZ1)"
  value       = aws_subnet.public.id
}

output "public_subnet_id_2" {
  description = "Public Subnet 2 ID (AZ2)"
  value       = aws_subnet.public2.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [
    aws_subnet.public.id,
    aws_subnet.public2.id
  ]
}

# ---------- PRIVATE SUBNETS ----------
output "private_subnet_id_1" {
  description = "Private Subnet 1 ID (AZ1)"
  value       = aws_subnet.private.id
}

output "private_subnet_id_2" {
  description = "Private Subnet 2 ID (AZ2)"
  value       = aws_subnet.private2.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [
    aws_subnet.private.id,
    aws_subnet.private2.id
  ]
}

# ---------- INTERNET GATEWAY ----------
output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

# ---------- ROUTE TABLE ----------
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}
