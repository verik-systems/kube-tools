DOCKER_IMAGE=veriks/kube-tools
DOCKER_TAG=v0.3.1

build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

run:
	docker run -it $(DOCKER_IMAGE):$(DOCKER_TAG) bash	
	  
docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)