# Nameko examples (from Nameko project) running inside AWS Cloud 

The goal of this repository is to runs some ligthweight Nameko microservices 
into the AWS Cloud.

**This is, obviously, only for testing, not for production purpose.**

**Work in Progress**

## Architecture

This project will create this resources into your AWS account:

- ECS Cluster
- ECS tasks (running in FARGATE mode)
- ElastiCache Redis Cluster
- RDS PostGreSQL database

## Deployment 

You can use the Terraform template embedded in this project for deploying the 
microservices.

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## License

This project is under MIT license.
