# GitHub Actions Workflow Demo

## Intro

This is a repository to show the multiple ways CI/CD can be leveraged to setup OpenShift deployment in your environments.

Note: The examples are posted in the openshift.yml in the base repo

## Requirements
* Self-hosted runner in your env (Follow the following to setup self-hosted runner: https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners
* OpenShift token and OpenShift API URL (https://access.redhat.com/solutions/2972601)

## Build
Build can be done for images using the following buildah-build and push-to-docker-io actions
Example:
```
- name: Buildah Action
  id: build-image
  uses: redhat-actions/buildah-build@v2
  with:
    image: ${{ env.IMAGE_NAME }}
    tags: ${{ env.DOCKER_TAG }}
    containerfiles: |
      ./Dockerfile
- name: Push to GitHub Container Repository
  id: push-to-docker-io
  uses: redhat-actions/push-to-registry@v2
  with:
    image: ${{ steps.build-image.outputs.image }}
    tags: ${{ env.DOCKER_TAG }}
    registry: ${{ env.REGISTRY }} 
    username: ${{ env.GITHUB_USER }} 
    password: ${{ env.DOCKER_SECRET }} 
```

## Deploy
Deploy can be done using two mechanisms

### Method 1: oc cli
The oc cli can be utilized using the run action. 
Example:
```
    - name: OC Apply
      run: |
        oc apply -f k8s.yaml
```
Note: The presumption here is that oc is already installed in the runner

### Method 2: Native GitHub Actions
The oc cli can be utilized using the run action. 
Example:
```
    - name: Create and expose app
      uses: redhat-actions/oc-new-app@v1
      with:
        app_name: mocf-build-from-scratch
        image: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ env.DOCKER_TAG }}
        namespace: mocf-dummy
```
Note: The presumption here is that oc is already installed in the runner


# Usage for OpenShift

## Docker registry location:
- https://hub.docker.com/repository/docker/rhcpranava/mocf-api
- To pull the image, use the following command:
```
docker pull docker.io/rhcpranava/mocf-api:latest
```

## OpenShift Deployment:
- Use the k8s yaml file to create a pod
- Expose the pod
```
oc expose pod/mocf-mock-pod -n mocf-dummy
```
- Create a route
```
oc expose svc/mocf-mock-pod -n mocf-dummy
```

## Usage
Endpoints are as follows:
- /api/10m
- /api/1m
- /api/64k
- /api/50k
- /api/40k
- /api/30k
- /api/25k
- /api/20k
- /api/15k
- /api/10k
- /api/5k
