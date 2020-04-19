# remix-docker
Docker image for [Remix ide](https://github.com/ethereum/remix-ide) built from source.

#### Run

```
docker run -v $HOME/contracts:/remix/app --name=remix-docker -d \
      -p 127.0.0.1:8081:8080 \
      -p 127.0.0.1:65520:65520 \
      unibtc/remix-docker:latest
```

##### Note
This docker image only listens to internal localhost, therefor ports are not accessible outside the server.
If serving remotely, you must setup your own reverse proxy like nginx to point to the container.
