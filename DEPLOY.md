# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to Bluemix Container Service

**1. Build Runtime Docker Image**

```bash
docker build -t s3-salutation-runtime:1.0.0 -f Dockerfile-runtime .
```

**2. Tag and Upload Runtime Image to Bluemix Registry**

```bash
# retag image to prepare for bluemix registry
docker tag s3-salutation-runtime:1.0.0 registry.ng.bluemix.net/<space>/s3-salutation-runtime

# push image to bluemix registry
docker push registry.ng.bluemix.net/<space>/s3-salutation-runtime
```

> **Note**: If you receive a "unauthorized: authentication required" message when trying to push your image to the Bluemix registry, then try the `bx cr login` command before reattempting.

**3. Request Public IP from Bluemix**

```bash
# request ip address to be used for a container
cf ic ip request
```

**4. Create Container on Bluemix**

```bash
# create container on bluemix!
cf ic run -p <ip_address>:80:80 --name salutation registry.ng.bluemix.net/<space>/s3-salutation-runtime
```
