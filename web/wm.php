<?php
define('SQL_INC',1);
define('CURR_MENU','wm');

require 'inc/common.inc.php';


$tpl->assign('id_user', $id_user);
$tpl->display('wm.tpl');
?>