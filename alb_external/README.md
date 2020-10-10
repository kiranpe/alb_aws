ALB EXTERNAL
--------------

--> Intialize terraform
    
    Ex: terrform init
    
--> Now create workspaces

    Ex: terraform workspace new prod

    --> It will create worspace folders in your backend s3 bucket.

--> Then Run terraform apply.

    --> It will create external application load balancer using your workspace variable.
   
    --> If you want to create dev instance create dev worspace and run it.

--> Terraform state file will be your backend s3 bucket.
