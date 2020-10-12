output "alb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb_internal.alb_id
}

output "alb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb_internal.alb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb_internal.alb_dns_name
}

output "alb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.alb_internal.alb_arn_suffix
}

output "alb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.alb_internal.alb_zone_id
}

output "alb_http_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.alb_internal.alb_http_listener_arns
}

output "alb_http_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = module.alb_internal.alb_http_listener_ids
}

output "alb_target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.alb_internal.alb_target_group_arns
}

output "alb_target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = module.alb_internal.alb_target_group_names
}
