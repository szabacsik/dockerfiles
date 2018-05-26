# dockerfiles
Collection of my docker recipes
## 01_lamp_stack
| component  | version                                                      |
|------------|--------------------------------------------------------------|
| Ubuntu     | 14.04.4 LTS                                                  |
| Apache2    | 2.4.7                                                        |
| PHP        | 5.5.9-1ubuntu4.21                                            |
| MySQL      | 14.14 Distrib 5.5.55                                         |
| phpmyadmin | 4.0.10deb1                                                   |
| ssh        | OpenSSH_6.6.1p1 Ubuntu-2ubuntu2.8, OpenSSL 1.0.1f 6 Jan 2014 |
| ezSQL      | Branch:master                                                |
### build the container
```bash
docker build -t szabacsik/01_lamp:1.0 . --no-cache=true
```
### run the container
```bash
docker run -it -p 8080:80 -p 2222:22 -p 33306:3306 szabacsik/01_lamp:1.0
```
### start the services
```bash
/opt/services.sh
```
## 02_ubuntu_apache_php
### Windows 10 Linux Subsystem Ubuntu bash
#### Set environment variables
```bash
$ export DOCKER_HOST=tcp://0.0.0.0:2375
```
```bash
$ export environment_host_volume_source=/mnt/c/Users/[USERNAME]/www
```
```bash
$ export environment_windows_host_volume_source=C:\\Users\\[USERNAME]\\www
```
#### Enter to the project folder
```bash
$ cd ../dockerfiles/02_ubuntu_apache_php
```
#### Build
```bash
$ make build
```
#### Deploy
```bash
$ make deploy
```
#### Run
```bash
$ make run
```
#### Test
```bash
$ wget -qO- http://localhost/ | grep -i 'phalcon' | wc -l
```
#### Clean up
```bash
$ docker rm $(docker ps -a -q); docker rmi $(docker images -a -q); docker system prune -a
```

#### Windows 8 mintty ( Docker Quickstart Terminal )
```mintty
export environment_host_volume_source=\/c\/Users\/andras.szabacsik\/userspace\/cloud\/Dropbox\/Workspaces\/COM0151\/offline\/attached
```
