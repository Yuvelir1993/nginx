# General
Learning nginx

## APIs

http://localhost:8080/server1/
http://localhost:8080/server1/hello
http://localhost:8080/server2/
http://localhost:8080/server2/hello

## Dev
Get into container
```bash
sudo docker exec -it <id> sh
```

### Get ETH 0 IP
```bash
ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
```
