REGISTRY = improwerk
IMAGE = ubuntu_apache_php
TAG = latest

NAME = $(REGISTRY)/$(IMAGE):$(TAG)
CONTAINER = $(REGISTRY)-$(IMAGE)

MOUNT_POINT_OUTSIDE = /c/Users/andras.szabacsik/workspace/app
MOUNT_POINT_INSIDE = /attached

messages:
	@echo MOUNT_POINT_OUTSIDE: $(MOUNT_POINT_OUTSIDE)
	@echo MOUNT_POINT_INSIDE: $(MOUNT_POINT_INSIDE)

build:
	docker build -t $(NAME) .

build-nocache:
	docker build --no-cache -t $(NAME) .

deploy: messages
	mkdir -p $(MOUNT_POINT_OUTSIDE)
	mkdir -p $(MOUNT_POINT_OUTSIDE)/htdocs

run: deploy
	docker run -d --name=$(CONTAINER) -p 80:80 -p 443:443 -v $(MOUNT_POINT_OUTSIDE):$(MOUNT_POINT_INSIDE) $(NAME)

debug:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME)

tail:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME) tail -f /dev/null

bash:
	docker exec -u 0 -it $(CONTAINER) bash
