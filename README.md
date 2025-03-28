# proxy
vps001+tinyproxy


build:
```
docker build -t imxiaofan/proxy .
```

start:
```
docker run --device /dev/net/tun --device /dev/vhost-net --cap-add=NET_ADMIN --cap-add=NET_RAW -d --name my-proxy -p 8888:8888 -e VPN_SERVER=<your_vps001_server> -e VPN_USER=<your_vps001_user> -e VPN_PASSWORD=<your_vps001_password> imxiaofan/proxy
```

setup proxy for linux:
```
export http_proxy=http://<your_local_ip>:8888
export https_proxy=http://<your_local_ip>:8888
```

