# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to Bluemix with Kubernetes

This guide outlines the steps necessary to deploy the salutation service to Bluemix using Kubernetes. Kubernetes is a container orchestration tool that allows you to run a highly available cluster of connected computers as if they were a single unit. With a Kubernetes cluster, you can easily scale (up or down) the infrastructure required to run a service based on demand, upgrades, etc..

We will be roughly following [this guide](https://www.ibm.com/blogs/bluemix/2017/03/deploying-go-server-ibm-bluemix-container-service/) (with some minor changes) which deploys a Go service to a Kubernetes cluster on Bluemix.

**1. Install the Bluemix and Kubernetes CLI**

- [Bluemix CLI](https://clis.ng.bluemix.net/ui/home.html)
- [Kubernetes CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-curl)

Once you've installed the Bluemix CLI, you must also install the container service plugin:

```bash
bx plugin install container-service -r Bluemix
```

**2. Build Runtime Docker Image**

Next, you must create a runtime Docker image containing the salutation executable and its minimum runtime dependencies. Once the image is built, upload it to the Bluemix Registry for future use.

```bash
docker build -t s3-salutation-runtime:1.0.0 -f Dockerfile-runtime .
```

**3. Tag and Upload Runtime Image to Bluemix Registry**

```bash
# retag image to prepare for bluemix registry
docker tag s3-salutation-runtime:1.0.0 registry.ng.bluemix.net/<space>/s3-salutation-runtime

# log into your bluemix account
bx login -a https://api.ng.bluemix.net

# push image to bluemix registry
docker push registry.ng.bluemix.net/<space>/s3-salutation-runtime
```

> **Note**: If you receive a "unauthorized: authentication required" message when trying to push your image to the Bluemix registry, then try the `bx cr login` before reattempting.

**4. Create Kubernetes Cluster on Bluemix**

After you've pushed the runtime image, you're ready to create the Kubernetes cluster:

```bash
# initialize the container service plug-in
bx cs init

# create Kubernetes cluster (since only --name is provided, cluster uses free tier)
bx cs cluster-create --name salutation-cluster
```

**5. Set Kubernetes CLI Context to New Cluster**

Next, run the following command to configure the Kubernetes CLI to use your newly created cluster:

```bash
# run the export command that is shown afterwards
bx cs cluster-config salutation-cluster

# export config to env variable
export KUBECONFIG=[path-from-previous-command-output]
```

**6. Deploy Salutation Server to Cluster Using YAML Config**

```bash
kubectl create -f server-deployment.yml
```

**7. Test It!**

Finally, we're ready to test our deployment! Use the following commands to determine the IP address of the running service, and then run `curl` to test.

````bash
# check for public IP
bx cs workers salutation-cluster

# test it! make sure to use port 30080!
curl [external-ip-address]:30080
```
