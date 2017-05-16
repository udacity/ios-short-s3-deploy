# Salutation Service

This repository contains the salutation microservice. It contains a single endpoint which returns a random salutation. To see an example response, visit the [Salutation Microservice Docs on Apiary](http://docs.salutationmicroservice.apiary.io/#).

## How to Deploy to Heroku

> **Note**: The Heroku buildpack for Swift provides a build-time adapter that can compile and run a Swift application on Heroku.

> **Important**: Heroku doesn't allow use of port 80. Instead run the microservice using the default Kitura port of 8080.

**1. Ensure Port Assignment Checks for $PORT Environment Variable**

```swift
// in main.swift...
import Foundation

// Resolve the port that we want the server to listen on
let port: Int
let defaultPort = 80
if let requestedPort = ProcessInfo.processInfo.environment["PORT"] {
    port = Int(requestedPort) ?? defaultPort
} else {
    port = defaultPort
}
```

**2. Create `Procfile` to Specify Start Command**

```
web: <exec> --workers 3 --bind 0.0.0.0:$PORT
```

**3. Create App on Heroku with Swift Buildpack**

```bash
heroku create --buildpack https://github.com/kylef/heroku-buildpack-swift.git
```

**4. Add Remote Branch to Heroku App**

```bash
heroku git:remote -a <app_name>
```

**5. Push to Heroku**

```bash
git push heroku heroku:master
```
