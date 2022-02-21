TAG?=v1

build:
	docker build -t veriks/kube-tools:$(TAG) . -f Dockerfile

push:
	docker push veriks/kube-tools:$(TAG)