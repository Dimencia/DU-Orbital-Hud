# `wrap.lua` Docker Image

The main purpose of this image is for using the container in the Github Actions pipeline,
to compile the source files into autoconf.  

However, as a bonus you can also use it locally to compile by simply mounting your repo;
```
docker run -v `pwd`:/du duorbitalhud/duwrap:latest scripts/wrap.sh true
```

Note; it doesn't actually contain `wrap.lua` and `wrap.sh`, just everything needed to run those.

## Build
```
docker build -t duorbitalhud/duwrap:latest .
```

## Push
```
docker push duorbitalhud/duwrap:latest
```

Note; to push you need to be logged in with your docker hub account, using `docker login`.
