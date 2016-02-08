# Consul Alerts Container

This project puts [Consul Alerts](https://github.com/AcalephStorage/consul-alerts) in scratch docker container. It is available on [Docker Hub](https://registry.hub.docker.com/u/alectolytic/consul-alerts/) and can be pulled using the following command.

```sh
docker pull alectolytic/consul-alerts
```

You will note that this is a tiny image.
```
$ docker images | grep docker.io/alectolytic/consul-alerts
alectolytic/consul-alerts       latest    01c314a10ab     4 minutes ago   9.923 MB
```

## Quickstart

#### Docker Compose

```sh
docker-compose up
```

The provided docker-compose configuration will spin up a consul and consul-alerts instance. The consul-alerts instance is linked to the consul instance. This is useful for evaluation, testing and debugging.
