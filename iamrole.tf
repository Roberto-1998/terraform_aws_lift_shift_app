resource "aws_iam_role" "vprofile_ec2_role" {
  name = "vprofile-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement : [{
      Effect = "Allow",
      Principal : {
        Service : "ec2.amazonaws.com"
      },
      Action : "sts:AssumeRole"
    }]
  })

  tags = {
    Project = var.PROJECT
  }
}

resource "aws_iam_role_policy" "vprofile_s3_policy" {
  name = "vprofile-s3-access"
  role = aws_iam_role.vprofile_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource : [
          "arn:aws:s3:::terraformstate9808/artifact/*",
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "vprofile_instance_profile" {
  name = "vprofile-ec2-instance-profile"
  role = aws_iam_role.vprofile_ec2_role.name
}