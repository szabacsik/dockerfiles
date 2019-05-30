#!/bin/bash
printf "Operating System: `lsb_release -d -s`\n"
printf "Kernel: `uname -r`\n"
command="nginx -v"
commandResult=$( ${command} 2>&1 )
nginxVersionNumber=$(echo $commandResult | grep -o '[0-9.]*$')
printf "Nginx: %s\n" $nginxVersionNumber
printf "PHP: `php -r "echo phpversion();"`\n"
printf "Phalcon: `php -r 'echo Phalcon\Version::get();'`\n"
printf "PHPUnit: `phpunit --version`\n"
printf "Codeception: `codecept --version`\n"
printf "Composer: `composer --version`\n"