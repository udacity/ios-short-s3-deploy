# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to AWS and Elastic Beanstalk (EB) with Terraform

Elastic Beanstalk (EB) is an extensive orchestration service offered by AWS. In simple terms, EB will allow you to stand-up and scale applications across EC2 instances. For this example, Hashicorp's Terraform tool is used to describe infrastructure (EC2 instance) and to automate the provisioning and deployment of the salutation microservice to the infrastructure.

> **Note**: Terraform is not limited to defining and provisioning AWS infrastructure. It is "platform polyglot" and can be used across many different providers to describing your [infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_Code).

> **Important**: The following instructions assume you've already installed [Homebrew](https://brew.sh) — a package manager for macOS.

**1. Create an AWS Account**

Follow the instructions on [Creating an AWS Account](http://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).

**2. Install Terraform**

```bash
# install terraform
brew install terraform

# update modules
terraform get

# check terraform config
terraform plan
```

**3. Install `direnv`**

`direnv` is a command-line tool that allows you to set environment variables that only apply to the current working directory.

```bash
# install direnv
brew install direnv

# make direnv available for bash shell
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# reload bashrc to make direnv available
source ~/.bashrc
```

**4. Set "Directory-Level" Environment Variables**

With `direnv` installed, you need to set a few environment variables that will be used by Terraform to help configure infrastructure on AWS.

> **Note**: View [Managing Access Keys for Your AWS Account](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) to create and/or locate your existing AWS access values.

```bash
# set the region closest to you (ex. eu-west-1)
echo export AWS_REGION=XX-XXXX-X >> .envrc

# set AWS access key id (ex. AKIAIOSFODNN7EXAMPLE)
echo export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXX >> .envrc

# set AWS secret access key (ex. wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY)
echo export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxx >> .envrc

# load directory-level environment variables from .envrc
direnv allow .
```

**5. Build and Tag Runtime Docker Image**

```bash
# build runtime image for registry
docker build -t <docker-id>/s3-salutation-runtime:1.0.0 -f Dockerfile-runtime .
```

**6. Upload Runtime Image to Docker Registry**

```bash
# push runtime container to docker registry
docker push <docker-id>/s3-salutation-runtime:1.0.0
```

**7. Update Terraform Configuration to Use Your Docker Image**

In `elasticbeanstalk.tf`, ensure that the `docker_image` setting uses the correct path your Docker image on the Docker Registry:

```bash
module "elasticbeanstalk" {
  # ...
  docker_image            = "docker.io/<docker-id>/s3-salutation-runtime"
  docker_tag              = "1.0.0"
  docker_ports            = ["80"]
  health_check            = "/"
}
```

> **Note**: If you don't set the `docker_image`, then it will use an instructor's runtime image by default. This should work in most cases, but if for some reason the Docker image is removed from the registry, then you will need to provide your own.

**8. Run `terraform get` and `terraform apply` to Create and Deploy Application to AWS**

```bash
# load terraform modules
terraform get

# create instrasture and deploy application using terraform
terraform apply
```

> **Note**: The deployment of this container should be covered by the free AWS usage tier. But, make sure you clean up after yourself when you're done with this application by using the `terraform destroy`.
