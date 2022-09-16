resource "aws_eip" "this" {
  network_interface = aws_instance.this[0].primary_network_interface_id
  instance          = aws_instance.this[0].id
}
