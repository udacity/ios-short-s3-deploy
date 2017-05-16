```bash
docker build -t docker.io/<docker_account>/<image>:<tag> .
docker push docker.io/<docker_account>/<image>:<tag>
```

# Deploying container to ElasticBeanstalk

1. Create an AWS account at amazon.com
2. Set the following credentials as environment variables, I recommend using direnv for this

```bash
export AWS_REGION=eu-west-1
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxx
```

3. Install terraform `brew install terraform`
4. Run `terraform get` to update the modules
5. Run `terraform plan` to check config
6. Run `terraform apply` to create and deploy environment

NOTE: The deployment of this container should be covered by your free plan but make sure you clean up afteryourself and destroy the environment with `terraform destroy`
