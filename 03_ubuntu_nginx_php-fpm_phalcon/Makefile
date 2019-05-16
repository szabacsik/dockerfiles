REGISTRY = szabacsik
IMAGE = ubuntu_nginx_php-fpm_phalcon
TAG = $(shell date +'%y%m%d')
NAME = $(REGISTRY)/$(IMAGE):$(TAG)
CONTAINER = $(REGISTRY)-$(IMAGE)

build:
	docker build -t $(NAME) .

build-nocache:
	docker build --no-cache -t $(NAME) .

bash:
	docker run -p 80:80 -p 443:443 --rm -it $(NAME) /bin/bash

run:
	docker run -p 80:80 -p 443:443 -d --rm --name=$(CONTAINER) $(NAME)
