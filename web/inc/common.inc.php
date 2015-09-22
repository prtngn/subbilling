<?php
require 'inc/config.inc.php';
require 'inc/sql.inc.php';
require 'inc/auth.inc.php';
require 'inc/template.inc.php';
require 'inc/lang/'.$language.'.inc.php';
require 'inc/func.inc.php';
require 'inc/menu.inc.php';
$tpl->assign('lang',$lang);
$tpl->assign('version','0.32');
$tpl->assign('web_page','http://www.subbilling.info');
$tpl->assign('tech_mail','support@subbilling.info');
$tpl->assign('year',date(Y));
?>
