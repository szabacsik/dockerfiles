REGISTRY = improwerk
IMAGE = ubuntu_apache_php
TAG = latest

NAME = $(REGISTRY)/$(IMAGE):$(TAG)
CONTAINER = $(REGISTRY)-$(IMAGE)

build:
	docker build -t $(NAME) .

build-nocache:
	docker build --no-cache -t $(NAME) .

run:
	docker run -d --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME)

debug:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME)

tail:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME) tail -f /dev/null

bash:
	docker exec -it $(CONTAINER) bash
