<?php
require_once(__DIR__ . DIRECTORY_SEPARATOR . 'config.php');

echo('Hello ' . $config['name'] . ', ' . '<br>');
echo('Version: ' . $config['version'] . '<br>');
echo json_encode($config);
echo('<br>');
