output "alb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = aws_lb.alb.*.id
}

output "alb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = aws_lb.alb.*.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.alb.*.dns_name
}

output "alb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = aws_lb.alb.*.arn_suffix
}

output "alb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = aws_lb.alb.*.zone_id
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = aws_lb_listener.alb_listener.*.arn
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = aws_lb_listener.alb_listener.*.id
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.alb_target_group.*.arn
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = aws_lb_target_group.alb_target_group.*.arn_suffix
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = aws_lb_target_group.alb_target_group.*.name
}
