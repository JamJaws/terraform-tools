This Docker image is built to allow commiting quickly without waiting on slow pre-commit hooks.
Use it to run all your heavy checks pre-commit on command.

## 🔨 Build

```shell
docker build -t terraform-tools --build-arg TARGETARCH=arm64 .
```

## 🧑‍💻Usage

main
```shell
docker run --rm -v "$PWD":/workspace jamjaws/terraform-tools pre-commit run --files $(git diff --name-only main)
```

master

```shell
docker run --rm -v "$PWD":/workspace jamjaws/terraform-tools pre-commit run --files $(git diff --name-only master)
```

## 💡 Why?

Pre-commit hooks can be slow, especially with security and compliance tools.
This container lets you commit fast and validate later — without compromising code quality.
