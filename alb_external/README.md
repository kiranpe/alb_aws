ALB EXTERNAL
--------------

--> Create workspaces

    Ex: terraform workspace new prod

--> it will create worspace folders in your backend s3 bucket

--> Now Run terraform apply.
   --> it will create external application load balancer using your workspace variable.
   --> if you want to create dev instance create dev worspace and run it.

--> terraform state file will be your s3 bucket.
