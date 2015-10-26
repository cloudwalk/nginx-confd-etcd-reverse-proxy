# NGINX reverse proxy configured by confd using ETCD as backend

[![Docker Repository on Quay.io](https://quay.io/repository/cloudwalk/nginx-confd-etcd-reverse-proxy/status "Docker Repository on Quay.io")](https://quay.io/repository/cloudwalk/nginx-confd-etcd-reverse-proxy)

This is a [NGINX reverse proxy] configured dynamically through [confd] using [etcd]
as backend.

We use [confd] to listen for changes in etcd folder `/applications`, reloading
`nginx.conf` in case some key in `/applications` changes.

This is used to proxy requests to applications running in a CoreOS cluster.

## Registering services

To register a service to be accessed in `test.cloudwalk.io`, for example, we should
set it's internal `ip:port` in etcd key `/applications/test/1`.

If it has more than one server to be added to it's upstream, we just set all of
them incrementing the server index, like this:

```
etcdctl set /applications/test/1 192.168.1.101:5000
etcdctl set /applications/test/2 192.168.1.102:5000
etcdctl set /applications/test/3 192.168.1.103:5000
```

We can add as many services as we want to following this pattern.

Usually, we create [discovery services] to automatically register the service.

## Running it

We can use the provided [service file] to start it
in our CoreOS cluster.

For example, to start two instances of it:

```
fleetctl start nginx-reverse-proxy@{1,2}
```

[NGINX reverse proxy]:https://www.nginx.com/resources/admin-guide/reverse-proxy/
[confd]:https://github.com/kelseyhightower/confd
[etcd]:https://github.com/coreos/etcd
[discovery services]:https://github.com/coreos/fleet/blob/master/Documentation/examples/service-discovery.md
[service file]:nginx-reverse-proxy.service
