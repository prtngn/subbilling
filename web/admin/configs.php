<?php
define('SQL_INC',1);
define('CURR_MENU','configs');
require 'inc/common.inc.php';
check_permissions(CURR_MENU,1);
$tpl->display('configs.tpl');
?>