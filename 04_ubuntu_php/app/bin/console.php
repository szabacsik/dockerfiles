<?php
$php='hehe';
require_once(__DIR__.DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR.'config.php');
echo('Hello ' . $config['name'] . ', ' . PHP_EOL);
echo('Version: ' . $config['version'] . PHP_EOL);
echo json_encode($config);
echo(PHP_EOL);

