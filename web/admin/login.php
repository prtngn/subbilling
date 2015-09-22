<?php
	require "inc/config.inc.php";
	require "inc/template.inc.php";
	require "inc/lang/$language.inc.php";
	
	if ($_GET["logout"]) {
		session_start();
		unset($_SESSION["login"]);
		unset($_SESSION["passwd"]);
		session_destroy();
	}	
	
	$tpl->assign("lang",$lang);
	$tpl->display("login.tpl");
?>