# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to AWS via Docker Cloud

Docker Cloud is a service for continuously deploying Docker applications (i.e. applications packaged inside Docker containers). It can connect with cloud providers like Amazon Web Services (AWS), Digital Ocean, Microsoft Azure, SoftLayer, and Packet to deploy your Docker applications to real hardware. This example deploys the salutation microservice to an EC2 instance on AWS via Docker Cloud.

**1. Create an AWS Account**

Follow the instructions on [Creating an AWS Account](http://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/AboutAWSAccounts.html).

**2. Create a Free Docker ID**

Create a Docker ID (username) using the [Docker Cloud sign up page](https://cloud.docker.com). Further instructions for Docker ID creation can be found at [Docker Docs: Docker ID](https://docs.docker.com/docker-id/).

**3. Connect Docker Cloud to a Cloud Provider (AWS)**

Once you've created a Docker ID, you can use it to log into [Docker Cloud](https://cloud.docker.com/#). From here, you need to connect your Docker Cloud account to your existing AWS account. Instructions for connecting the accounts can be found at [Docker Docs: Link Amazon Web Services to Docker Cloud](https://docs.docker.com/docker-cloud/cloud-swarm/link-aws-swarm/).

**4. Create a Node Cluster**

Before you can deploy Docker applications to AWS, you need to define the infrastructure upon which the containers will run. The infrastructure can be thought of as a collection of Linux machines or "nodes" that form a "node cluster". To create a node cluster, navigate to the **Node Clusters** tab in Docker Cloud and click **Create**. Then, fill out the form and click **Launch Node Cluster**.

![Create Node Cluster](https://s3-us-west-1.amazonaws.com/udacity-iosnd/server-side-swift/dc-create-node-cluster.png)

> **Note**: The the above image, the `us-west-2` region is used because of its proximity to Udacity. Also, the `t2-nano` size is chosen for nodes because it falls under AWS free usage tier.

**5. Build and Tag Runtime Docker Image**

With infrastructure in-place, you can technically begin deploying Docker applications from Docker Cloud's preset/default images. However, for this example, you'll want to build your own custom Docker image that contains the salutation microservice. Once the image is built, you can upload it to the Docker Registry so that it can be used by Docker Cloud.

```bash
# build runtime image for registry
docker build -t <docker-id>/s3-salutation-runtime:1.0.0 -f Dockerfile-runtime .
```

**6. Upload Runtime Image to Docker Registry**

```bash
# push runtime container to docker registry
docker push <docker-id>/s3-salutation-runtime:1.0.0
```

**7. Create Service Using Uploaded Runtime Image**

Almost there! The infrastructure is ready and the Docker image is ready, now we need to create a service.

A service can be created by specifying a Docker application (a Docker image) plus some additional settings for how the application should be deployed and maintained. To create a service, go to the **Services** tab in Docker Cloud and click **Create**. Then, select the server icon which lists your Docker images and select the `<docker-id>/s3-salutation-runtime` image.

On the next screen, you can configure settings for the service. Many of the settings will already be pre-filled with default values based on the Docker image and its underlying Dockerfile. At a minimum, you will need to change a setting in the **Ports** section for the app to work properly:

![Port Setting](https://s3-us-west-1.amazonaws.com/udacity-iosnd/server-side-swift/dc-port-setting.png)

Specifically, you want to make sure that container port 80 is published, and that the node port is also set to 80.

We also recommend the following **General settings**:

- Set `AUTORESTART` to `Always`
    - If the container suddenly stops/fails, then Docker Cloud will automatically restart a new one!
- Set `AUTOREDEPLOY` to `True/On`
    - When set to `True/On`, Docker Cloud will automatically redeploy your Docker application every time a new version of the Docker image (with a matching tag) is pushed to the Docker Registry

Finally click **Create & Deploy** to finish creating the service. This will create the service and run a container using the specified Docker image.

**8. Configure AWS Security Group to Accept All Inbound HTTP Traffic**

This is the last step! At this point, the service should be up and the container should be running on an EC2 instance on AWS. However, by default, Docker Cloud and AWS only allows the EC2 instance that runs your container to accept HTTP requests that come from within your AWS Virtual Private Cloud (VPN). The VPN is a virtual network dedicated to your AWS account. So, to fix this, you need to configure the default VPN Security Group to accept any HTTP traffic from any IP.

- Sign into your AWS account
- Under the **Services** tab, go to **EC2** in the **Compute** section
- Under the **NETWORK & SECURITY** section in the sidebar, select **Security Groups**
- From the security groups table, select the row for the security group where the **Group Name** is equal to `default`
- Once you've selected the `default` security group, choose the **Inbound** tab and click **Edit**
- In the dialog that appears, click **Add Rule**
- For the new rule, use the following settings:
    - Type: `HTTP`
    - Protocol: `TCP` (will autofill)
    - Port Range: `80` (will autofill)
    - Source: `Anywhere`
- Finally, click **Save** to add the new rule to the security group

![Security Rule](https://s3-us-west-1.amazonaws.com/udacity-iosnd/server-side-swift/dc-aws-security-group-rule.png)
