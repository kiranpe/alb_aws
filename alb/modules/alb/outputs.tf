locals {
  lb_id              = aws_lb.alb.*.id
  lb_arn             = aws_lb.alb.*.arn
  lb_dns_name        = aws_lb.alb.*.dns_name
  lb_arn_suffix      = aws_lb.alb.*.arn_suffix
  lb_zone_id         = aws_lb.alb.*.zone_id
  http_listener_arns = aws_lb_listener.alb_listener.*.arn
  http_listener_ids  = aws_lb_listener.alb_listener.*.id
  target_group_arns  = aws_lb_target_group.alb_target_group.*.arn
  target_group_names = aws_lb_target_group.alb_target_group.*.name
}

output "alb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = local.lb_id
}

output "alb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = local.lb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = local.lb_dns_name
}

output "alb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = local.lb_arn_suffix
}

output "alb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = local.lb_zone_id
}

output "alb_http_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = local.http_listener_arns
}

output "alb_http_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = local.http_listener_ids
}

output "alb_target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = local.target_group_arns
}

output "alb_target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = aws_lb_target_group.alb_target_group.*.arn_suffix
}

output "alb_target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = local.target_group_names
}
