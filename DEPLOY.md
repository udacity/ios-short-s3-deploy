# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to Bluemix Cloud Foundry

> **Note**: Cloud Foundry provides runtimes required to execute your applications on the Bluemix cloud. When you push an application to Bluemix using the Cloud Foundry `cf push` command, Bluemix automatically detects which buildpack should be used for your application.

> **Important**: You are not allowed to use port 80 for running your application. We recommend using Kitura's default 8080 port.

**1. Create `Procfile` to Specify Start Command**

```
web: <exec_name>
```

**2. (Optional) Create Cloud Foundry `manifest.yml` File**

```yaml
---
applications:
- name: <exec_name>
  random-route: true # generates a random route (url) for your app
  memory: 256M
  command: <exec_name>
  buildpack: swift_buildpack
```

**3. (Optional) Create Cloud Foundry `.cfignore` File**

```
.build/*
Packages/*
```

**4. Push Application to Cloud Foundry**

```bash
cf push
```
