...connect your docker cloud to a provider (will use AWS example)

```bash
# build runtime image for registry
docker build -t <username>/<image>:<tag> -f Dockerfile-runtime .
```

```bash
# push runtime container to docker registry
docker push <username>/<image>:<tag>
```

... then the other steps for docker cloud
