REGISTRY = improwerk
IMAGE = ubuntu_apache_php
TAG = latest

NAME = $(REGISTRY)/$(IMAGE):$(TAG)
CONTAINER = $(REGISTRY)-$(IMAGE)

host_volume_source = /c/Users/andras.szabacsik/workspace/app
container_volume_target = /attached

messages:
	@echo host_volume_source: $(host_volume_source)
	@echo container_volume_target: $(container_volume_target)

build:
	docker build -t $(NAME) .

build-nocache:
	docker build --no-cache -t $(NAME) .

deploy: messages
	mkdir -p $(host_volume_source)
	mkdir -p $(host_volume_source)/htdocs

run: deploy
	docker run -d --name=$(CONTAINER) -p 80:80 -p 443:443 -v $(host_volume_source):$(container_volume_target) $(NAME)

debug:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME)

tail:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME) tail -f /dev/null

bash:
	docker exec -u 0 -it $(CONTAINER) bash
