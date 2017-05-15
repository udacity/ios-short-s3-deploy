# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.l1monolith.apiary.io/#).

The salutation microservice uses the Swift Package Manager to manage dependencies.

## Swift Dependencies

- Kitura
- HeliumLogger

## How to Use

The salutation microservice can technically be built to run on macOS or Ubuntu Linux. However, we recommend building for Ubuntu Linux since that will likely be the environment used if you were to deploy the microservice into the cloud. Furthermore, to assure consistency between development and possible deployment environments, Docker is used. Take the following steps to build and run the microservice on your host machine:

**1] Build the Docker Image**

```bash
docker build -t s3-salutation:1.0.0 .
```

**2] Run the Docker Image (start Bash shell)**

```bash
docker run -it -v $(pwd):/app -p 80:80 s3-salutation:1.0.0 /bin/bash
```

**3] Build the Monolith**

```bash
# assuming you are located at /app
swift build
```

**4] Run the Monolith**

```bash
# assuming you are located at /app
.build/debug/salutation
```

**5] Test an Endpoint!**

```bash
curl localhost
```
