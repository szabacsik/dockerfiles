REGISTRY = szabacsik
IMAGE = ubuntu_nginx_php-fpm_phalcon
TAG = $(shell date +'%y%m%d')
NAME = $(REGISTRY)/$(IMAGE):$(TAG)
CONTAINER = $(REGISTRY)-$(IMAGE)

build:
	docker build -t $(NAME) .

build-nocache:
	docker build --no-cache -t $(NAME) .

run-bash:
	docker run -p 80:80 -p 443:443 -p 9001:9001 --rm -it $(NAME) /bin/bash

run:
	docker run -p 80:80 -p 443:443 -p 9001:9001 -d --rm --name=$(CONTAINER) $(NAME)

bash:
	docker exec -it -u0 $(CONTAINER) /bin/bash

stop:
	docker stop $(CONTAINER)

versions:
	docker run --rm -it $(NAME) /home/worker/versions.sh

clean:
	-docker kill $(shell docker ps -q)
	-docker rm $(shell docker ps -a -q)
	-docker rmi $(shell docker images -a -q)
	-docker system prune -a --force
	docker ps -a
	docker images -a

USERNAME = $(shell bash -c 'read -p "Username: " username; echo $$username')
PASSWORD = $(shell bash -c 'read -p "Password: " password; echo $$password')
LATEST_IMAGE_ID = $(shell docker images | awk '{print $$3}' | awk 'NR==2')
LATEST_IMAGE_NAME = $(REGISTRY)/$(IMAGE):latest
push:
	docker login -u $(USERNAME) -p $(PASSWORD)
	docker tag $(LATEST_IMAGE_ID) $(LATEST_IMAGE_NAME)
	docker push $(REGISTRY)/$(IMAGE):$(TAG)
	docker push $(LATEST_IMAGE_NAME)
