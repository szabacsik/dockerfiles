#!/bin/bash
printf "Operating System: `lsb_release -d -s`\n"
printf "Kernel: `uname -r`\n"
printf "Nginx: `nginx -V 2>&1 | head -n 1`\n"
printf "PHP: `php -r "echo phpversion();"`\n"
printf "Phalcon: `php -r 'echo Phalcon\Version::get();'`\n"
printf "PHPUnit: `phpunit --version`\n"
printf "Codeception: `codecept --version`\n"
printf "Composer: `composer --version`\n"