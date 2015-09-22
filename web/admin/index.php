<?php
	define('SQL_INC',1);
	require 'inc/common.inc.php';
	
	header('location: '.$menu[$perms['def_page']]['url']);
?>