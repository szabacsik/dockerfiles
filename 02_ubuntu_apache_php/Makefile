REGISTRY = improwerk
IMAGE = ubuntu_apache_php
TAG = latest

NAME = $(REGISTRY)/$(IMAGE):$(TAG)
CONTAINER = $(REGISTRY)-$(IMAGE)

command = pwd
argument = "-P"
default_host_volume_source = $(subst /c/users/,/c/Users/,$(shell $(command) $(argument)))
default_container_volume_target = /attached

messages:
	$(info $$host_volume_source is set to [${host_volume_source}])
	$(info $$container_volume_target is set to [${container_volume_target}])

build:
	docker build -t $(NAME) .

build-nocache:
	docker build --no-cache -t $(NAME) .

deploy: get-environment-variables messages
	mkdir -p "$(host_volume_source)"
	mkdir -p "$(host_volume_source)/etc"
	mkdir -p "$(host_volume_source)/application"
	- git clone https://gist.github.com/72b348e56bacc2abe1c574ffe169edc1.git "$(host_volume_source)/etc"

run: deploy
	docker run -d --name=$(CONTAINER) -p 80:80 -p 443:443 -v $(host_volume_source):$(container_volume_target) $(NAME)

debug:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME)

tail:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME) tail -f /dev/null

bash:
	docker exec -u 0 -it $(CONTAINER) bash

get-environment-variables:
ifndef environment_host_volume_source
host_volume_source = $(default_host_volume_source)
$(info $$environment_host_volume_source variable is not set falling back to default [${host_volume_source}])
else
host_volume_source = $(subst C:/,/c/,$(environment_host_volume_source))
endif
ifndef environment_container_volume_target
container_volume_target = $(default_container_volume_target)
$(info $$environment_container_volume_target variable is not set falling back to default [${container_volume_target}])
else
container_volume_target = $(environment_container_volume_target)
endif
