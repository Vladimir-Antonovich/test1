# Test task for the DevOps position.

The project contains two subfolders and a script `deploy.sh`

1. The folder __nginx__ contains Dockerfile and config files for the nginx server.
The nginx server configured to response to `/health` and `/message` requests.

2. The folder __k8s__ contains yaml files which creates a deployment, a service and configmap for dev or stage envs.

3. The script `deploy.sh` builds the docker image, pushes it to docker repo. After that it creates the namespace and other stuf in kubernetes.

Example:

```
bash deploy.sh -v v.0.3 -n test1-ns
```

Output example:

```
Build the image
[+] Building 0.8s (8/8) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 31B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                                                    0.6s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 189B                                                                                  0.0s
 => [1/3] FROM docker.io/library/nginx@sha256:f5747a42e3adcb3168049d63278d7251d91185bb5111d2563d58729a5c9179b0     0.0s
 => => resolve docker.io/library/nginx@sha256:f5747a42e3adcb3168049d63278d7251d91185bb5111d2563d58729a5c9179b0     0.0s
 => CACHED [2/3] RUN mkdir -p etc/nginx/templates                                                                  0.0s
 => CACHED [3/3] COPY ./templates/* /etc/nginx/templates/                                                          0.0s
 => exporting to image                                                                                             0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:b0f558175eda4f825d885cd85c5eaaff3a34537edffaa782d435f6ba77585df2                       0.0s
 => => naming to docker.io/antonovichvladimir/nginx-test1                                                          0.0s
 => => naming to docker.io/antonovichvladimir/nginx-test1:v0.1                                                     0.0s
Push the image
 The push refers to repository [docker.io/antonovichvladimir/nginx-test1]
7299bb2a2154: Layer already exists
82801a865a93: Layer already exists
4d33db9fdf22: Layer already exists
6791458b3942: Layer already exists
2731b5cfb616: Layer already exists
043198f57be0: Layer already exists
5dd6bfd241b4: Layer already exists
8cbe4b54fa88: Layer already exists
v0.1: digest: sha256:47669b469b7ab64f6c7c5a1b77a014f46e2e87aca83ec4e95c2d707f2a674ba7 size: 1984
The push refers to repository [docker.io/antonovichvladimir/nginx-test1]
7299bb2a2154: Layer already exists
82801a865a93: Layer already exists
4d33db9fdf22: Layer already exists
6791458b3942: Layer already exists
2731b5cfb616: Layer already exists
043198f57be0: Layer already exists
5dd6bfd241b4: Layer already exists
8cbe4b54fa88: Layer already exists
latest: digest: sha256:47669b469b7ab64f6c7c5a1b77a014f46e2e87aca83ec4e95c2d707f2a674ba7 size: 1984
Create a deployment on k8s
~/test/test1-master ~/test/test1-master
namespace/test2 created
configmap/test1 created
deployment.apps/nginx-deployment created
service/test1-service created
~/test/test1-master
Waiting available pods...
Deployment status:
NAME               READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS    IMAGES                           SELECTOR
nginx-deployment   1/1     1            1           11s   nginx-test1   antonovichvladimir/nginx-test1   app=web
Pods:
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-545d445bb4-5pd9x   1/1     Running   0          11s
Services:
NAME            TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE
test1-service   LoadBalancer   10.43.2.25   192.168.1.242   80:30843/TCP   11s
Health status: UP
Message: NGINX in Stage-lab
```

