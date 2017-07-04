# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to Google Container Service

This guide outlines the steps necessary to deploy the salutation service to the Google Container Service using Kubernetes. Kubernetes is a container orchestration tool that allows you to run a highly available cluster of connected computers as if they were a single unit. With a Kubernetes cluster, you can easily scale (up or down) the infrastructure required to run a service based on demand, upgrades, etc..

> **Note**: This example may incur some minor fees because it is impossible to setup a Kubernetes cluster using the "micro" machine type from Google's free tier. Instead, we will be using a "small" machine type with 1.7 GB of memory. This machine type costs an estimated $5.11 USD per month.

**1. Build and Tag Runtime Docker Image**

Before any setup with Google, you must create a runtime Docker image containing the salutation executable and its minimum runtime dependencies. Once the image is built, upload it to the Docker Registry for future use.

```bash
# build runtime image for registry
docker build -t <docker-id>/s3-salutation-runtime:1.0.0 -f Dockerfile-runtime .
```

**2. Upload Runtime Image to Docker Registry**

```bash
# push runtime container to docker registry
docker push <docker-id>/s3-salutation-runtime:1.0.0
```

**3. Sign-Up for Google Account**

[Sign-Up for a Google Account](https://accounts.google.com/SignUp) if you don't already have one.

**4. Create a New Container Engine Project from Google Cloud Console**

Go to the [Google Container Engine console](https://console.cloud.google.com/kubernetes) and create a new project.

**5. Create a New Container Cluster from Google Cloud Console**

Once you've created your project, create a new cluster using the following options:

- name: [anything-you-want]
- description: [anything-you-want]
- zone: [zone-closest-you] (* assuming US)
- machine type: small
- memory: 1.7 GB
- size: 1

The rest of the options can be left as default.

**6. Setup Docker Container Environment with GCloud and Kubernetes CLIs**

For the rest of the deployment, we'll use a Docker container that already has the Google Cloud (`gcloud`) and Kubernetes CLIs installed:

```bash
# download google cloud image
docker pull google/cloud-sdk

# create google cloud container and start bash session
docker run -it --rm google/cloud-sdk bash
```

**7. Set Kubernetes CLI Context to Cluster**

Next, from the Docker container we setup in the previous step, run the following commands to configure the Kubernetes CLI to use your cluster:

```bash
# auth into gcloud account (follow instructions in output)
gcloud auth login

# determine project id for your container project
gcloud projects list

# set gcloud to use your project
gcloud config set project [project-id]

# set config for kubernetes cli
gcloud container clusters get-credentials [cluster-name] --zone [cluster-zone] --project [project-id]
```

**8. Deploy Salutation Service to Cluster**

Now, you can use the Kubernetes CLI to deploy the salutation server to your cluster.

```bash
# assumes image (ex. jarrodparkes/s3-salutation-runtime:1.0.0) has already been uploaded to docker registry
kubectl run salutation --image jarrodparkes/s3-salutation-runtime:1.0.0
```

**9. Expose the Deployment**

After you've deployed the service, open port 80 so it can send/retrieve traffic.

```bash
kubectl expose deployments salutation --port=80 --type=LoadBalancer
```

**10. Test It!**

Finally, we're ready to test our deployment! Use the following commands to determine the IP address of the running service, and then run `curl` to test.

```bash
# find the IP address for the "LoadBalancer Ingress" (salutation service)
kubectl describe services

# test it!
curl [ip-address]
```
