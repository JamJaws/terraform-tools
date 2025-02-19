## Build

```shell
docker build -t terraform-tools --build-arg TARGETARCH=arm64 .
```

## Run

```shell
docker run --rm -v "$PWD":/workspace pre-commit-madness pre-commit run --files $(git diff --name-only master)
```
