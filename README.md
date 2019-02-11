# iso-maker


# Create Docker container.
```
docker build --rm -t pressboxx/iso-maker
```

# Create ISO image.
```
docker run --rm -v \`pwd\`/iso/:/iso/ -t -i --privileged pressboxx/iso-maker /bin/bash
```
