ALB EXTERNAL
--------------

--> Intialize terraform
    
    Ex: terrform init
    
--> Now create workspaces

    Ex: terraform workspace new prod

    --> It will create worspace folders in your backend s3 bucket.

--> Then Run terraform apply.

    --> It will create EC2 instance and Security group and External Application Load Balancer using your workspace variable and attach the EC2 instance to
    Load balancer Target Group.
   
    --> If you want to create dev instance create dev worspace first and run scripts.

--> Terraform state file will be your backend s3 bucket.
