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
### set environment variables
#### Windows 8 mintty ( Docker Quickstart Terminal )
```mintty
export environment_host_volume_source=\/c\/Users\/andras.szabacsik\/userspace\/cloud\/Dropbox\/Workspaces\/COM0151\/offline\/attached
```
