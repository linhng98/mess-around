output "eip_ip" {
  description = "The ip of eip"
  value       = aws_eip.this.public_ip
}
