REGISTRY = szabacsik
IMAGE = ubuntu_apache_php_phalcon
TAG = latest
NOW = $(shell TZ="Europe/Budapest" date +'%Y.%m.%d. %H:%M:%S.%3N')

NAME = $(REGISTRY)/$(IMAGE):$(TAG)
CONTAINER = $(REGISTRY)-$(IMAGE)

command = pwd
argument = "-P"
default_host_volume_source = $(subst /c/users/,/c/Users/,$(shell $(command) $(argument)))/../www
default_container_volume_target = /attached

messages: get-environment-variables
	$(info $$NOW = [$(NOW)])
	$(info $$host_volume_source = [${host_volume_source}])
	$(info $$docker_host_volume_source = [${docker_host_volume_source}])
	$(info $$container_volume_target = [${container_volume_target}])
	$(info $$git_clone_target = [${git_clone_target}])

build:
	docker build -t $(NAME) .

build-nocache:
	docker build --no-cache -t $(NAME) .

deploy: get-environment-variables messages
	mkdir -p "$(host_volume_source)"
	mkdir -p "$(host_volume_source)/etc"
	mkdir -p "$(host_volume_source)/artifact/public"
	mkdir -p "$(host_volume_source)/artifact/application"
	mkdir -p "$(host_volume_source)/artifact/vendor"
	mkdir -p "$(host_volume_source)/artifact/tests"
	mkdir -p "$(host_volume_source)/temp"
	find "$(host_volume_source)" -name "temp" -exec rm -rf {} +
	#apache.conf
	git clone https://gist.github.com/72b348e56bacc2abe1c574ffe169edc1.git "$(git_clone_target)/temp"
	chmod 700 "$(host_volume_source)/temp" -R
	sleep 1
	find $(host_volume_source)/temp -name '.git' -exec rm -rf {} +
	mv $(host_volume_source)/temp/* $(host_volume_source)/etc/
	find "$(host_volume_source)" -name "temp" -exec rm -rf {} +
	#php.ini
	git clone https://gist.github.com/42dff0f9c8e28d6dcf95fcda10fd7608.git "$(git_clone_target)/temp"
	chmod 700 "$(host_volume_source)/temp" -R
	sleep 1
	find $(host_volume_source)/temp -name '.git' -exec rm -rf {} +
	mv $(host_volume_source)/temp/* $(host_volume_source)/etc/
	find "$(host_volume_source)" -name "temp" -exec rm -rf {} +
	#index.php
	git clone https://gist.github.com/a6e433f6c3aca8c159775cc99f540cf9.git "$(git_clone_target)/temp"
	chmod 700 "$(host_volume_source)/temp" -R
	sleep 1
	find $(host_volume_source)/temp -name '.git' -exec rm -rf {} +
	mv $(host_volume_source)/temp/* $(host_volume_source)/artifact/public/
	#composer.json
	git clone https://gist.github.com/3eeb37ee4bf6db14ccb29871576abadb.git "$(git_clone_target)/temp"
	chmod 700 "$(host_volume_source)/temp" -R
	sleep 1
	find $(host_volume_source)/temp -name '.git' -exec rm -rf {} +
	mv $(host_volume_source)/temp/* $(host_volume_source)/artifact/
	chmod 777 "$(host_volume_source)" -R

run:
	docker run -d --name=$(CONTAINER) -p 80:80 -p 443:443 -v "$(docker_host_volume_source)":$(container_volume_target) $(NAME)

debug:
	docker run -a STDERR --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME)

tail:
	docker run --name=$(CONTAINER) -p 80:80 -p 443:443 $(NAME) tail -f /dev/null

bash:
	docker exec -u 0 -it $(CONTAINER) bash

get-environment-variables:
ifndef environment_host_volume_source
host_volume_source = $(default_host_volume_source)
$(info $$environment_host_volume_source is not set value of host_volume_source will be [${default_host_volume_source}])
else
host_volume_source = $(subst C:/,/c/,$(environment_host_volume_source))
$(info $$environment_host_volume_source is set to [${environment_host_volume_source}] using this value for host_volume_source)
endif
ifndef environment_container_volume_target
container_volume_target = $(default_container_volume_target)
$(info $$environment_container_volume_target is not set value of container_volume_target will be [${default_container_volume_target}])
else
container_volume_target = $(environment_container_volume_target)
$(info $$environment_container_volume_target is set to [${environment_container_volume_target}] using this value for container_volume_target)
endif
ifdef environment_git_clone_target
git_clone_target = $(environment_git_clone_target)
$(info $$environment_git_clone_target is set to [${environment_git_clone_target}] using this value for git_clone_target)
else
git_clone_target = $(host_volume_source)
$(info $$environment_git_clone_target is not set value of git_clone_target will be [${host_volume_source}])
endif
ifdef environment_windows_host_volume_source
docker_host_volume_source = $(environment_windows_host_volume_source)
$(info $$environment_windows_host_volume_source is set to [${environment_windows_host_volume_source}] using this value for docker_host_volume_source)
else
docker_host_volume_source = $(host_volume_source)
$(info $$environment_windows_host_volume_source is not set value of docker_host_volume_source will be [${host_volume_source}])
endif
