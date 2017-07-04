# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to Microsoft Azure Cloud

We will be roughly following [this existing deployment guide](https://docs.microsoft.com/en-us/azure/container-service/container-service-kubernetes-walkthrough).

**1. Build and Tag Runtime Docker Image**

Before any setup with Azure, you must create a runtime Docker image containing the salutation executable and its minimum runtime dependencies. Once the image is built, upload it to the Docker Registry for future use.

```bash
# build runtime image for registry
docker build -t <docker-id>/s3-salutation-runtime:1.0.0 -f Dockerfile-runtime .
```

**2. Upload Runtime Image to Docker Registry**

```bash
# push runtime container to docker registry
docker push <docker-id>/s3-salutation-runtime:1.0.0
```

**3. Create a Free Azure Account**

After successfully uploading your image, you're ready to sign-up for an account for  Microsoft's Azure cloud. Use this [link](https://account.azure.com/signup?offer=MS-AZR-0044P) to sign-up and create an Azure account. If you have an existing Microsoft/Live account, then you can create an account by connecting to your existing account.

> **Note**: This deployment will not exceed Azure's free-usage tier.

**4. Prepare Azure CLI and Kubernetes Environment**

We will be creating and deploying our service using the [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and [Kubernetes](https://kubernetes.io). These tools could be downloaded to your local machine, but we'll use a Docker container instead. To create and run a Docker container with these tools installed, use the following command:

```bash
# build and run the image
docker pull azuresdk/azure-cli-python

# mount your home directory to use any pre-existing ssh keys
docker run -it --rm -v ${HOME}:/root azuresdk/azure-cli-python bash

# install kubernetes CLI (from the container)
bash-4.3# az acs kubernetes install-cli
```

**5. Create Kubernetes Cluster**

With the environment ready, you can create an Azure resource group and Kubernetes container service (a cluster). You'll use these to deploy the salutation service:

```bash
# login to the azure cloud
az login

# create a azure resource group to house the cluster
# make sure to substitute the location that makes most sense for you (ex: eastus)
az group create -n SalutationGroup -l [location]

# create cluster!
az acs create --orchestrator-type=kubernetes --resource-group SalutationGroup --name=SalutationService --agent-count=1 --generate-ssh-keys
```

> **Note**: We use an `--agent-count=1` to limit the size of the cluster and stay within Azure's free usage tier. Also, the `--generate-ssh-keys` option is provided to ensure SSH keys are generated. If SSH keys are found at `~/.ssh` with default names, then they are used. Otherwise, new keys are generated.

Here are some other commands useful for debugging and modifying the newly created cluster:

```bash
# list pods running within clusters
kubectl get pods

# see more detailed information about the status of pod
kubectl describe pods [name-of-pod]

# remove cluster deployment
kubectl delete deployments salutation

# remove resource group (and cluster)
az group delete --name SalutationGroup
```

**6. Config CLI to Use Your Cluster**

Next, run the following command to configure the Kubernetes CLI to use your newly created cluster.

```bash
# this command saves the cluster credentials at $HOME/.kube/config
# this is the default location the CLI expects
az acs kubernetes get-credentials --resource-group=SalutationGroup --name=SalutationService
```

**7. Deploy Salutation Server as Kubernetes Deployment**

Now, you can use the Kubernetes CLI to deploy the salutation server to your cluster.

```bash
# assumes image (ex. jarrodparkes/s3-salutation-runtime:1.0.0) has already been uploaded to docker registry
kubectl run salutation --image jarrodparkes/s3-salutation-runtime:1.0.0
```

**8. Expose the Deployment**

After you've deployed the service, open port 80 so it can send/retrieve traffic.

```bash
kubectl expose deployments salutation --port=80 --type=LoadBalancer
```

**9. Test the Service!**

Finally, we're ready to test our deployment! Use the following command to determine the IP address of the running service, and then run `curl` to test.

```bash
# see the status of the running service (includes the external IP)
# the first time you run this you may see <pending> for the external IP
# just keep trying until the external IP address is set
kubectl get svc

# test it!
curl [external-ip-address]
```
