resource "aws_key_pair" "vprofile-app-key" {
  key_name   = "vprofile-app-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcakJsXCoIZbrctgiHPchDL/E3X7MJ6ndzqoOaOm25u vprofile-app-key"
  tags = {
    Name    = "vprofile-app-key"
    Project = var.PROJECT
  }
}


resource "aws_key_pair" "vprofile-backend-key" {
  key_name   = "vprofile-backend-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBckgf8kcfsVCFiivbrkSNl1Q1YUytN5tTbxYkaDnGBi vprofile-backend-key"
  tags = {
    Name    = "vprofile-backend-key"
    Project = var.PROJECT
  }
}