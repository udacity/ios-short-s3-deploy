module "elasticbeanstalk" {
  source = "github.com/nicholasjackson/terraform-modules/elasticbeanstalk-docker"

  instance_type = "t2.nano"

  application_name        = "salutation"
  application_description = "Salutation microservice"
  application_environment = "development"
  application_version     = "1.0.0"
  docker_image            = "docker.io/jarrodparkes/s3-salutation-runtime"
  docker_tag              = "1.0.0"
  docker_ports            = ["8080"]
  health_check            = "/"
}

output "elasticbeanstalk_cname" {
  value = "${module.elasticbeanstalk.cname}"
}
