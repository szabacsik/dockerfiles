<?php
require_once ( '/var/www/test/forks/ezsql/ezSQL-master/shared/ez_sql_core.php' );
require_once ( '/var/www/test/forks/ezsql/ezSQL-master/mysql/ez_sql_mysql.php' );
global $db;
$db = new ezSQL_mysql ( 'root', '123456', 'mysql', 'localhost', 'UTF-8' );
$db -> query ( "SET NAMES 'utf8' COLLATE 'utf8_hungarian_ci'" );
$db -> query ( "SET CHARACTER SET utf8" );
$my_tables = $db->get_results("SHOW TABLES",ARRAY_N);
$db->debug();
foreach ( $my_tables as $table )
{
    $db->get_results("DESC $table[0]");
    $db->debug();
}
?>
