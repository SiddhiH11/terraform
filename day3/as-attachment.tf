resource "aws_autoscaling_attachment" "home_tg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.home_asg.name
  lb_target_group_arn    = aws_lb_target_group.home_target_group.arn
}

resource "aws_autoscaling_attachment" "laptop_tg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.laptop_asg.name
  lb_target_group_arn    = aws_lb_target_group.laptop_target_group.arn
}

resource "aws_autoscaling_attachment" "mobile_tg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.mobile_asg.name
  lb_target_group_arn    = aws_lb_target_group.mobile_target_group.arn
}