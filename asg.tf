

resource "aws_autoscaling_group" "vprofile-app-ASG" {
  vpc_zone_identifier = data.aws_subnets.default.ids
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.vprofile-app-LT.id
    version = "$Latest"
  }

  health_check_type = "ELB"


  target_group_arns = [aws_lb_target_group.vprofile-las-TG.arn]



}


resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.vprofile-app-ASG.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value     = 50.0
    disable_scale_in = true # Puedes poner true si no quieres que reduzca
  }
}