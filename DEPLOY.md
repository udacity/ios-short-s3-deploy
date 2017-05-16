# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to Heroku

> **Note**: The Heroku buildpack for Swift provides a build-time adapter that can compile and run a Swift application on Heroku.

**1. Create `Procfile` to Specify Start Command**

```
web: salutation --workers 3 --bind 0.0.0.0:$PORT
```

**2. Push Application to Cloud Foundry**

```bash
cf push
```
